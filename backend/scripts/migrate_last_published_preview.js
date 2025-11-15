require('dotenv').config();
const { supabase } = require('../src/utils');

/**
 * Script para migrar el último preview publicado a la tabla instagram_posts
 * Este script busca el último preview con status='published' y lo agrega a instagram_posts
 */
async function migrateLastPublishedPreview() {
  try {
    console.log('🔍 Buscando el último preview publicado...');

    // Buscar el último preview publicado
    const { data: publishedPreviews, error: previewError } = await supabase
      .from('instagram_previews')
      .select('*')
      .eq('status', 'published')
      .order('published_at', { ascending: false })
      .limit(1);

    if (previewError) {
      throw new Error(`Error buscando previews: ${previewError.message}`);
    }

    if (!publishedPreviews || publishedPreviews.length === 0) {
      console.log('⚠️ No se encontraron previews publicados');
      return;
    }

    const preview = publishedPreviews[0];
    console.log('✅ Preview encontrado:', {
      id: preview.id,
      type: preview.type,
      topic: preview.topic,
      instagram_media_id: preview.instagram_media_id,
      instagram_url: preview.instagram_url,
      published_at: preview.published_at
    });

    // Verificar que tenga instagram_media_id
    if (!preview.instagram_media_id) {
      console.error('❌ El preview no tiene instagram_media_id. No se puede migrar.');
      return;
    }

    // Verificar si ya existe en instagram_posts
    const { data: existingPost, error: checkError } = await supabase
      .from('instagram_posts')
      .select('*')
      .eq('instagram_post_id', preview.instagram_media_id)
      .single();

    if (existingPost && !checkError) {
      console.log('ℹ️ El post ya existe en instagram_posts:', existingPost.id);
      console.log('   No se necesita migrar.');
      return;
    }

    // Determinar la URL del media
    let mediaUrl = null;
    if (preview.type === 'reel') {
      mediaUrl = preview.video_url || preview.image_url;
    } else {
      mediaUrl = preview.image_url;
    }

    if (!mediaUrl) {
      console.error('❌ El preview no tiene media_url. No se puede migrar.');
      return;
    }

    // Obtener información adicional desde Instagram si es posible
    let mediaInfo = {
      id: preview.instagram_media_id,
      media_type: preview.type === 'reel' ? 'VIDEO' : 'IMAGE', // Usar 'VIDEO' en lugar de 'REELS' para el constraint
      caption: preview.final_caption || preview.suggested_caption?.captions?.[0]?.content || '',
      permalink: preview.instagram_url,
      timestamp: preview.published_at || preview.created_at
    };

    // Intentar obtener más información desde Instagram
    if (process.env.INSTAGRAM_ACCESS_TOKEN && preview.instagram_media_id) {
      try {
        console.log('🔍 Obteniendo información adicional desde Instagram...');
        const fieldsResp = await fetch(`https://graph.instagram.com/v24.0/${preview.instagram_media_id}?fields=media_type,media_url,caption,permalink,timestamp`, {
          headers: { 'Authorization': `Bearer ${process.env.INSTAGRAM_ACCESS_TOKEN}` }
        });
        
        if (fieldsResp.ok) {
          const fields = await fieldsResp.json();
          // Mapear el media_type de Instagram a los valores aceptados por la BD
          let mappedMediaType = 'IMAGE';
          if (fields.media_type) {
            // Instagram puede devolver 'REELS', 'VIDEO', etc.
            // Mapear a los valores aceptados por la BD (probablemente 'VIDEO' o 'IMAGE')
            if (fields.media_type === 'REELS' || fields.media_type === 'VIDEO' || preview.type === 'reel') {
              mappedMediaType = 'VIDEO';
            } else {
              mappedMediaType = 'IMAGE';
            }
          } else if (preview.type === 'reel') {
            mappedMediaType = 'VIDEO';
          }
          
          mediaInfo = {
            ...mediaInfo,
            media_type: mappedMediaType,
            media_url: fields.media_url || mediaUrl,
            caption: fields.caption || mediaInfo.caption,
            permalink: fields.permalink || mediaInfo.permalink,
            timestamp: fields.timestamp || mediaInfo.timestamp
          };
          console.log('✅ Información adicional obtenida desde Instagram');
          console.log('   Media type mapeado:', mappedMediaType);
        }
      } catch (e) {
        console.warn('⚠️ No se pudo obtener información adicional desde Instagram:', e.message);
        // Usar información básica disponible
        mediaInfo.media_url = mediaUrl;
      }
    } else {
      mediaInfo.media_url = mediaUrl;
    }

    // Insertar en instagram_posts
    console.log('💾 Insertando post en instagram_posts...');
    const { data: newPost, error: insertError } = await supabase
      .from('instagram_posts')
      .insert({
        media_id: mediaInfo.id,
        instagram_post_id: mediaInfo.id,
        media_type: mediaInfo.media_type,
        image_url: mediaInfo.media_url || '',
        media_url: mediaInfo.media_url,
        caption: mediaInfo.caption,
        permalink: mediaInfo.permalink,
        timestamp: mediaInfo.timestamp ? new Date(mediaInfo.timestamp) : new Date()
      })
      .select()
      .single();

    if (insertError) {
      throw new Error(`Error insertando post: ${insertError.message}`);
    }

    console.log('✅ Post migrado exitosamente a instagram_posts:', {
      id: newPost.id,
      instagram_post_id: newPost.instagram_post_id,
      media_type: newPost.media_type,
      permalink: newPost.permalink
    });

  } catch (error) {
    console.error('❌ Error en la migración:', error);
    process.exit(1);
  }
}

// Ejecutar el script
migrateLastPublishedPreview()
  .then(() => {
    console.log('✅ Script completado');
    process.exit(0);
  })
  .catch((error) => {
    console.error('❌ Error fatal:', error);
    process.exit(1);
  });


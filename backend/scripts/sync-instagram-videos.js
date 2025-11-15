#!/usr/bin/env node

/**
 * Script para sincronizar los últimos videos/reels de Instagram a la base de datos
 * 
 * Este script obtiene los últimos videos y reels publicados en Instagram y los guarda
 * en la tabla instagram_posts si no existen ya.
 * 
 * Uso:
 *   node scripts/sync-instagram-videos.js
 *   node scripts/sync-instagram-videos.js --limit 50
 *   node scripts/sync-instagram-videos.js --limit 100 --only-reels
 * 
 * Opciones:
 *   --limit <number>     Número máximo de medios a obtener (default: 50)
 *   --only-reels         Solo sincronizar reels (excluir videos normales)
 *   --only-videos        Solo sincronizar videos normales (excluir reels)
 */

require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');

// Configuración de Supabase
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

// Importar funciones necesarias
const { getAllInstagramAccountMedia, getInstagramMediaInfo } = require('../src/utils/functions');

/**
 * Obtener o crear un post de Instagram en la base de datos
 */
async function getOrCreateInstagramPost(mediaInfo) {
  try {
    if (!mediaInfo || !mediaInfo.id) {
      throw new Error('Información de media no válida');
    }

    // Buscar post existente por instagram_post_id primero, luego por media_id
    let existingPost = null;
    let searchError = null;
    
    // Primero buscar por instagram_post_id
    const { data: postById, error: errorById } = await supabase
      .from('instagram_posts')
      .select('*')
      .eq('instagram_post_id', mediaInfo.id)
      .single();
    
    if (postById && !errorById) {
      existingPost = postById;
    } else {
      // Si no se encuentra por instagram_post_id, buscar por media_id
      const { data: postByMediaId, error: errorByMediaId } = await supabase
        .from('instagram_posts')
        .select('*')
        .eq('media_id', mediaInfo.id)
        .single();
      
      existingPost = postByMediaId;
      searchError = errorByMediaId;
    }

    if (existingPost && !searchError) {
      return { post: existingPost, created: false };
    }

    // Determinar si es video o reel y establecer los campos correctos
    const isReel = mediaInfo.media_type === 'REELS';
    const isVideo = mediaInfo.media_type === 'VIDEO';
    const mediaType = isReel ? 'REEL' : (isVideo ? 'VIDEO' : 'IMAGE');

    // Crear nuevo post solo si no existe
    const insertData = {
      media_id: mediaInfo.id,
      instagram_post_id: mediaInfo.id,
      media_type: mediaType,
      media_url: mediaInfo.media_url,
      caption: mediaInfo.caption || null,
      permalink: mediaInfo.permalink || null,
      timestamp: mediaInfo.timestamp ? new Date(mediaInfo.timestamp) : new Date(),
      status: 'published',
      created_by: 'system',
      published_at: mediaInfo.timestamp ? new Date(mediaInfo.timestamp) : new Date()
    };

    // Para videos y reels, usar video_url en lugar de image_url
    if (isReel || isVideo) {
      insertData.video_url = mediaInfo.media_url;
      insertData.image_url = null; // Los videos no tienen image_url
    } else {
      insertData.image_url = mediaInfo.media_url;
      insertData.video_url = null;
    }

    const { data: newPost, error: insertError } = await supabase
      .from('instagram_posts')
      .insert(insertData)
      .select()
      .single();

    if (insertError) {
      console.error(`   ❌ Error creando post ${mediaInfo.id}:`, insertError.message);
      throw insertError;
    }

    return { post: newPost, created: true };
  } catch (error) {
    console.error(`   ❌ Error en getOrCreateInstagramPost para ${mediaInfo?.id}:`, error.message);
    throw error;
  }
}

/**
 * Función principal para sincronizar videos/reels
 */
async function syncInstagramVideos(options = {}) {
  try {
    const limit = options.limit || 50;
    const onlyReels = options.onlyReels || false;
    const onlyVideos = options.onlyVideos || false;

    console.log('🎬 Iniciando sincronización de videos/reels de Instagram...');
    console.log(`   📊 Límite: ${limit}`);
    console.log(`   🎞️ Solo reels: ${onlyReels ? 'Sí' : 'No'}`);
    console.log(`   🎥 Solo videos: ${onlyVideos ? 'Sí' : 'No'}`);
    console.log('');

    // Obtener todos los medios de Instagram
    console.log('📡 Obteniendo medios de Instagram...');
    const allMedia = await getAllInstagramAccountMedia(limit);
    console.log(`   ✅ Obtenidos ${allMedia.length} medios`);
    console.log('');

    // Filtrar solo videos y reels
    let videosAndReels = allMedia.filter(media => {
      const isReel = media.media_type === 'REELS';
      const isVideo = media.media_type === 'VIDEO';
      
      if (onlyReels && !isReel) return false;
      if (onlyVideos && !isVideo) return false;
      
      return isReel || isVideo;
    });

    console.log(`🎬 Encontrados ${videosAndReels.length} videos/reels para sincronizar`);
    console.log('');

    if (videosAndReels.length === 0) {
      console.log('✅ No hay videos/reels para sincronizar');
      return;
    }

    // Procesar cada video/reel
    let created = 0;
    let updated = 0;
    let errors = 0;

    for (let i = 0; i < videosAndReels.length; i++) {
      const media = videosAndReels[i];
      const mediaType = media.media_type === 'REELS' ? 'Reel' : 'Video';
      
      try {
        console.log(`[${i + 1}/${videosAndReels.length}] Procesando ${mediaType} ${media.id}...`);
        
        // Obtener información detallada del media (incluyendo like_count)
        const mediaInfo = await getInstagramMediaInfo(media.id);
        if (!mediaInfo) {
          console.log(`   ⚠️ No se pudo obtener información detallada, usando datos básicos`);
        }

        // Usar información detallada si está disponible, sino usar datos básicos
        const finalMediaInfo = mediaInfo || media;
        
        // Guardar o actualizar en la base de datos
        const result = await getOrCreateInstagramPost(finalMediaInfo);
        
        if (result.created) {
          created++;
          console.log(`   ✅ ${mediaType} creado en la base de datos`);
        } else {
          updated++;
          console.log(`   ℹ️ ${mediaType} ya existe en la base de datos`);
        }

        // Pequeña pausa para evitar rate limiting
        if (i < videosAndReels.length - 1) {
          await new Promise(resolve => setTimeout(resolve, 300));
        }
      } catch (error) {
        errors++;
        console.error(`   ❌ Error procesando ${mediaType} ${media.id}:`, error.message);
      }
      
      console.log('');
    }

    // Resumen final
    console.log('═══════════════════════════════════════════════════════════');
    console.log('📊 RESUMEN DE SINCRONIZACIÓN');
    console.log('═══════════════════════════════════════════════════════════');
    console.log(`   📥 Total procesados: ${videosAndReels.length}`);
    console.log(`   ✅ Nuevos creados: ${created}`);
    console.log(`   ℹ️ Ya existentes: ${updated}`);
    console.log(`   ❌ Errores: ${errors}`);
    console.log('═══════════════════════════════════════════════════════════');
    
    if (created > 0) {
      console.log(`\n🎉 ¡Se agregaron ${created} nuevos videos/reels a la base de datos!`);
    } else if (updated === videosAndReels.length) {
      console.log(`\n✅ Todos los videos/reels ya estaban en la base de datos`);
    }

  } catch (error) {
    console.error('❌ Error en sincronización:', error);
    process.exit(1);
  }
}

// Parsear argumentos de línea de comandos
const args = process.argv.slice(2);
const options = {};

for (let i = 0; i < args.length; i++) {
  if (args[i] === '--limit' && args[i + 1]) {
    options.limit = parseInt(args[i + 1], 10);
    i++;
  } else if (args[i] === '--only-reels') {
    options.onlyReels = true;
  } else if (args[i] === '--only-videos') {
    options.onlyVideos = true;
  }
}

// Ejecutar sincronización
syncInstagramVideos(options)
  .then(() => {
    console.log('\n✅ Sincronización completada');
    process.exit(0);
  })
  .catch((error) => {
    console.error('\n❌ Error fatal:', error);
    process.exit(1);
  });


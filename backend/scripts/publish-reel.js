#!/usr/bin/env node

/**
 * Script para publicar un reel a Instagram
 * 
 * Uso:
 *   node scripts/publish-reel.js <preview-id>
 *   node scripts/publish-reel.js <preview-id> --caption "Mi caption personalizado"
 * 
 * Ejemplo:
 *   node scripts/publish-reel.js 1763095080347
 *   node scripts/publish-reel.js 1763095080347 --caption "¡Mira este increíble reel!"
 */

require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');

// Configuración de Supabase
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

// Importar función de publicación
const { publishInstagramReel } = require('../src/utils/functions');

async function publishReel(previewId, customCaption = null) {
  try {
    console.log(`🔍 Buscando preview con ID: ${previewId}`);
    
    // Obtener preview de la base de datos
    let preview = null;
    let previewError = null;
    
    // Intentar buscar por UUID primero
    const { data: previewByUuid, error: errorByUuid } = await supabase
      .from('instagram_previews')
      .select('*')
      .eq('id', previewId)
      .single();
    
    if (!errorByUuid && previewByUuid) {
      preview = previewByUuid;
    } else {
      // Si no se encuentra como UUID, buscar por timestamp aproximado
      console.log(`⚠️ Preview no encontrado como UUID, buscando por timestamp aproximado...`);
      
      // Buscar previews recientes de tipo reel
      const { data: recentPreviews, error: recentError } = await supabase
        .from('instagram_previews')
        .select('*')
        .eq('type', 'reel')
        .in('status', ['draft', 'generating'])
        .order('created_at', { ascending: false })
        .limit(20);
      
      if (!recentError && recentPreviews && recentPreviews.length > 0) {
        // Si el ID es numérico y parece un timestamp, buscar el más cercano
        if (/^\d+$/.test(previewId)) {
          const idTimestamp = parseInt(previewId);
          console.log(`   Buscando preview creado alrededor de: ${new Date(idTimestamp).toISOString()}`);
          
          // Buscar el preview más cercano en tiempo (dentro de 2 horas)
          const matchingPreview = recentPreviews.find(p => {
            const createdAt = new Date(p.created_at).getTime();
            const timeDiff = Math.abs(createdAt - idTimestamp);
            return timeDiff < 7200000; // Dentro de 2 horas
          });
          
          if (matchingPreview) {
            preview = matchingPreview;
            console.log(`✅ Preview encontrado por timestamp aproximado:`);
            console.log(`   ID real: ${preview.id}`);
            console.log(`   Creado: ${preview.created_at}`);
          } else {
            // Si no hay coincidencia exacta, mostrar los más recientes
            console.log(`\n📋 Previews recientes encontrados:`);
            recentPreviews.slice(0, 5).forEach((p, idx) => {
              const createdAt = new Date(p.created_at).getTime();
              const timeDiff = Math.abs(createdAt - idTimestamp);
              console.log(`   ${idx + 1}. ID: ${p.id}`);
              console.log(`      Creado: ${p.created_at}`);
              console.log(`      Estado: ${p.status}`);
              console.log(`      Tema: ${p.topic}`);
              console.log(`      Diferencia de tiempo: ${Math.round(timeDiff / 1000 / 60)} minutos`);
            });
          }
        }
      }
      
      if (!preview) {
        previewError = errorByUuid || new Error('Preview no encontrado');
      }
    }

    if (previewError || !preview) {
      console.error('❌ Preview no encontrado:', previewError);
      console.error(`\n💡 Intenta usar el UUID real del preview de la lista anterior`);
      process.exit(1);
    }

    console.log('✅ Preview encontrado:');
    console.log(`   Tipo: ${preview.type}`);
    console.log(`   Tema: ${preview.topic}`);
    console.log(`   Estado: ${preview.status}`);
    console.log(`   Video URL: ${preview.video_url || preview.image_url || 'No disponible'}`);

    if (preview.status === 'published') {
      console.log('⚠️ Este preview ya fue publicado');
      if (preview.instagram_url) {
        console.log(`   URL de Instagram: ${preview.instagram_url}`);
      }
      return;
    }

    if (preview.type !== 'reel') {
      console.error('❌ Este preview no es un reel');
      process.exit(1);
    }

    // Determinar la URL del video
    const videoUrl = preview.video_url || preview.image_url;
    if (!videoUrl) {
      console.error('❌ No hay video disponible para publicar');
      process.exit(1);
    }

    // Determinar el caption
    let caption = customCaption;
    if (!caption) {
      caption = preview.final_caption || 
                preview.suggested_caption?.captions?.[0]?.content || 
                '';
    }

    console.log('\n📤 Publicando reel a Instagram...');
    console.log(`   Video URL: ${videoUrl}`);
    console.log(`   Caption: ${caption ? (caption.substring(0, 100) + '...') : 'Sin caption'}`);

    // Publicar el reel
    const publishResult = await publishInstagramReel(videoUrl, caption);

    if (!publishResult.success) {
      console.error('❌ Error publicando reel:', publishResult.error);
      process.exit(1);
    }

    console.log('\n✅ Reel publicado exitosamente!');
    console.log(`   Media ID: ${publishResult.media_id || publishResult.post_id}`);
    if (publishResult.permalink) {
      console.log(`   URL: ${publishResult.permalink}`);
    }

    // Actualizar preview en la base de datos
    const updateData = {
      status: 'published',
      published_at: new Date().toISOString(),
      final_caption: caption || preview.final_caption,
      instagram_media_id: publishResult.media_id || publishResult.post_id,
      instagram_url: publishResult.permalink || null,
    };

    const { data: updatedPreview, error: updateError } = await supabase
      .from('instagram_previews')
      .update(updateData)
      .eq('id', previewId)
      .select()
      .single();

    if (updateError) {
      console.error('⚠️ Error actualizando preview en BD:', updateError);
    } else {
      console.log('✅ Preview actualizado en la base de datos');
    }

  } catch (error) {
    console.error('❌ Error:', error);
    process.exit(1);
  }
}

// Leer argumentos de línea de comandos
const args = process.argv.slice(2);
const previewId = args[0];

if (!previewId) {
  console.error('❌ Uso: node scripts/publish-reel.js <preview-id> [--caption "texto"]');
  console.error('\nEjemplo:');
  console.error('  node scripts/publish-reel.js 1763095080347');
  console.error('  node scripts/publish-reel.js 1763095080347 --caption "Mi caption personalizado"');
  process.exit(1);
}

// Buscar caption personalizado en los argumentos
let customCaption = null;
const captionIndex = args.indexOf('--caption');
if (captionIndex !== -1 && args[captionIndex + 1]) {
  customCaption = args[captionIndex + 1];
}

// Ejecutar publicación
publishReel(previewId, customCaption);


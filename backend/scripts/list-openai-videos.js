#!/usr/bin/env node

/**
 * Script para listar y recuperar videos de OpenAI API
 * 
 * Uso:
 *   node scripts/list-openai-videos.js                    # Listar últimos videos conocidos
 *   node scripts/list-openai-videos.js <video-id>          # Verificar estado de un video específico
 *   node scripts/list-openai-videos.js <video-id> --download # Descargar y guardar un video
 */

require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');

// Configuración
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);

/**
 * Verificar estado de un video en OpenAI
 */
async function checkVideoStatus(videoId) {
  try {
    const response = await fetch(`https://api.openai.com/v1/videos/${videoId}`, {
      headers: {
        'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`
      }
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`Error: ${response.status} - ${errorText}`);
    }

    return await response.json();
  } catch (error) {
    throw error;
  }
}

/**
 * Descargar video de OpenAI
 */
async function downloadVideo(videoId) {
  try {
    const response = await fetch(`https://api.openai.com/v1/videos/${videoId}/content`, {
      headers: {
        'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`
      }
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new Error(`Error descargando: ${response.status} - ${errorText}`);
    }

    const buffer = Buffer.from(await response.arrayBuffer());
    return buffer;
  } catch (error) {
    throw error;
  }
}

/**
 * Subir video a Supabase Storage
 */
async function uploadToSupabase(videoBuffer, fileName) {
  try {
    const { data: uploadData, error: uploadError } = await supabase.storage
      .from('magneto-bucket')
      .upload(fileName, videoBuffer, {
        contentType: 'video/mp4',
        cacheControl: '3600'
      });

    if (uploadError) {
      throw uploadError;
    }

    const { data: publicUrlData } = supabase.storage
      .from('magneto-bucket')
      .getPublicUrl(fileName);

    return publicUrlData.publicUrl;
  } catch (error) {
    throw error;
  }
}

/**
 * Buscar videos recientes en la base de datos que puedan tener job IDs
 */
async function findRecentVideoJobs() {
  try {
    // Buscar previews recientes de tipo reel que puedan tener metadata con job IDs
    const { data: previews, error } = await supabase
      .from('instagram_previews')
      .select('*')
      .eq('type', 'reel')
      .order('created_at', { ascending: false })
      .limit(20);

    if (error) {
      throw error;
    }

    return previews;
  } catch (error) {
    throw error;
  }
}

/**
 * Función principal
 */
async function main() {
  const args = process.argv.slice(2);
  const shouldDownload = args.includes('--download');
  const shouldFindLatest = args.includes('--latest');
  
  // Filtrar flags para obtener el video ID real
  const videoId = args.find(arg => !arg.startsWith('--'));

  try {
    if (shouldFindLatest) {
      // Buscar el último video completado automáticamente
      console.log('🔍 Buscando el último video completado...\n');
      
      // Buscar previews recientes que puedan tener job IDs pendientes
      const recentPreviews = await findRecentVideoJobs();
      
      // Buscar previews sin video pero que puedan tener un job pendiente
      const pendingPreviews = recentPreviews.filter(p => 
        p.status === 'generating' || 
        (p.status === 'draft' && !p.image_url)
      );

      if (pendingPreviews.length > 0) {
        console.log(`📋 Encontrados ${pendingPreviews.length} previews pendientes:\n`);
        
        for (const preview of pendingPreviews.slice(0, 3)) {
          console.log(`📹 Preview ID: ${preview.id}`);
          console.log(`   Tema: ${preview.topic}`);
          console.log(`   Estado: ${preview.status}`);
          console.log(`   Creado: ${preview.created_at}`);
          console.log('');
        }
        
        console.log('💡 Nota: Los job IDs de OpenAI no se guardan en la BD.');
        console.log('   Necesitas el job ID específico para verificar el video.');
        console.log('   Revisa los logs del servidor para encontrar el job ID.');
      } else {
        console.log('✅ No hay previews pendientes sin video.');
      }
      
      console.log('\n💡 Para verificar un video específico:');
      console.log('   node scripts/list-openai-videos.js <video-id>');
      console.log('\n💡 Para descargar un video completo:');
      console.log('   node scripts/list-openai-videos.js <video-id> --download');
    } else if (videoId) {
      // Verificar video específico
      console.log(`🔍 Verificando video: ${videoId}`);
      const videoData = await checkVideoStatus(videoId);
      
      console.log('\n📊 Información del video:');
      console.log(`   ID: ${videoData.id}`);
      console.log(`   Estado: ${videoData.status}`);
      console.log(`   Progreso: ${videoData.progress || 'N/A'}%`);
      if (videoData.created_at) {
        console.log(`   Creado: ${new Date(videoData.created_at * 1000).toISOString()}`);
      }
      if (videoData.error) {
        console.log(`   Error: ${JSON.stringify(videoData.error)}`);
      }

      if (shouldDownload && (videoData.status === 'completed' || videoData.status === 'succeeded')) {
        console.log('\n📥 Descargando video...');
        const videoBuffer = await downloadVideo(videoId);
        console.log(`✅ Video descargado: ${videoBuffer.length} bytes`);

        // Guardar localmente
        const fileName = `video-${videoId}-${Date.now()}.mp4`;
        const filePath = path.join(__dirname, '..', 'downloads', fileName);
        const downloadsDir = path.join(__dirname, '..', 'downloads');
        
        if (!fs.existsSync(downloadsDir)) {
          fs.mkdirSync(downloadsDir, { recursive: true });
        }

        fs.writeFileSync(filePath, videoBuffer);
        console.log(`💾 Video guardado localmente: ${filePath}`);

        // Subir a Supabase
        console.log('\n☁️ Subiendo a Supabase Storage...');
        const supabaseFileName = `ai-generated-reel-${Date.now()}.mp4`;
        const publicUrl = await uploadToSupabase(videoBuffer, supabaseFileName);
        console.log(`✅ Video subido a Supabase: ${publicUrl}`);
      } else if (shouldDownload) {
        console.log(`\n⚠️ El video no está completo (estado: ${videoData.status}). No se puede descargar.`);
      }
    } else {
      // Listar videos recientes conocidos
      console.log('🔍 Buscando videos recientes en la base de datos...\n');
      
      const recentPreviews = await findRecentVideoJobs();
      
      if (recentPreviews.length === 0) {
        console.log('❌ No se encontraron previews recientes');
        return;
      }

      console.log(`📋 Encontrados ${recentPreviews.length} previews recientes:\n`);

      // Buscar el último video que pueda tener un job ID pendiente
      // Nota: Los job IDs no se guardan en la BD actualmente, así que intentaremos
      // verificar videos recientes basándonos en patrones conocidos
      
      for (const preview of recentPreviews.slice(0, 5)) {
        console.log(`📹 Preview ID: ${preview.id}`);
        console.log(`   Tema: ${preview.topic}`);
        console.log(`   Estado: ${preview.status}`);
        console.log(`   Creado: ${preview.created_at}`);
        if (preview.image_url) {
          console.log(`   Video URL: ${preview.image_url}`);
        }
        console.log('');
      }

      console.log('\n💡 Para buscar el último video completado:');
      console.log('   node scripts/list-openai-videos.js --latest');
      console.log('\n💡 Para verificar un video específico de OpenAI:');
      console.log('   node scripts/list-openai-videos.js <video-id>');
      console.log('\n💡 Para descargar un video completo:');
      console.log('   node scripts/list-openai-videos.js <video-id> --download');
      console.log('\n💡 Ejemplo:');
      console.log('   node scripts/list-openai-videos.js video_6916b1c375a08190841bc9f03e0e0e2d058a74347517642f --download');
    }
  } catch (error) {
    console.error('❌ Error:', error.message);
    if (error.stack) {
      console.error(error.stack);
    }
    process.exit(1);
  }
}

main();


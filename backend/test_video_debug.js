require('dotenv').config();
const { GoogleGenAI } = require("@google/genai");

async function testVideoGeneration() {
  try {
    console.log('🎬 Iniciando prueba de generación de video...');
    
    if (!process.env.GEMINI_API_KEY) {
      console.error('❌ GEMINI_API_KEY no está configurado');
      return;
    }
    
    const ai = new GoogleGenAI({
      apiKey: process.env.GEMINI_API_KEY
    });
    
    console.log('✅ Cliente Google GenAI inicializado');
    
    const prompt = `Create a caricaturesco Instagram Reel video (9:16 aspect ratio, 6 seconds max) about: "Consejos para entrevistas técnicas"

VIDEO REQUIREMENTS:
- High quality video content
- Instagram Reel dimensions (9:16 - vertical)
- Duration: Maximum 6 seconds
- Style: caricaturesco
- Language: Spanish
- Accent: colombiano

CONTENT REQUIREMENTS:
- Main topic: "Consejos para entrevistas técnicas"
- Engaging visual storytelling
- Professional but engaging content
- Suitable for job/tech content
- Clear audio and visual quality

BRANDING REQUIREMENTS (MANDATORY):
- Watermark: "MAGNETO EMPLEOS" (subtle, bottom right corner)
- Instagram handle: "@magneto_empleos" (subtle, bottom left corner)
- Both branding elements should be visible but not intrusive

AUDIO REQUIREMENTS:
- Clear Spanish narration
- Accent: colombiano
- Professional tone
- Engaging and informative
- Background music appropriate for the content

VISUAL ELEMENTS:
- Professional video quality
- Smooth transitions
- Clear text overlays when needed
- Engaging visual elements
- Tech/professional theme appropriate

Generate a complete video ready for Instagram Reels with proper branding and audio.`;

    console.log('📤 Iniciando generación de video...');
    
    // Iniciar generación de video
    let operation = await ai.models.generateVideos({
      model: "veo-3.0-generate-001",
      prompt: prompt,
    });
    
    console.log('⏳ Video en cola de generación, esperando...');
    console.log('📊 Operation info:', operation);
    
    // Polling hasta que el video esté listo
    while (!operation.done) {
      console.log("⏳ Esperando que la generación del video se complete...");
      await new Promise((resolve) => setTimeout(resolve, 10000)); // Esperar 10 segundos
      operation = await ai.operations.getVideosOperation({
        operation: operation,
      });
      console.log('📊 Operation status:', operation.done);
    }
    
    console.log('✅ Video generado exitosamente');
    console.log('📊 Operation response:', operation.response);
    
    // Verificar si hay videos generados
    if (!operation.response || !operation.response.generatedVideos || operation.response.generatedVideos.length === 0) {
      console.error('❌ No se encontraron videos generados');
      return;
    }
    
    // Descargar el video generado
    const videoFile = operation.response.generatedVideos[0].video;
    console.log('📥 Descargando video...');
    console.log('📄 Video file info:', videoFile);
    
    // Descargar el video usando el método correcto de la API
    const videoBuffer = await ai.files.download({
      file: videoFile,
    });
    
    console.log('📦 Video descargado, tipo:', typeof videoBuffer);
    console.log('📦 Video descargado, tamaño:', videoBuffer ? videoBuffer.length : 'undefined');
    
    if (!videoBuffer || videoBuffer.length === 0) {
      console.error('❌ Error: videoBuffer está vacío o undefined');
      return;
    }
    
    console.log('✅ Video descargado exitosamente');
    console.log('🎉 Prueba completada exitosamente');
    
  } catch (error) {
    console.error('❌ Error en testVideoGeneration:', error.message);
    console.error('🔍 Stack trace:', error.stack);
  }
}

testVideoGeneration();

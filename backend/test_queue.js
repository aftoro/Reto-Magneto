require('dotenv').config();

// Simular la función de generación de video con cola
let videoGenerationQueue = [];
let activeVideoGenerations = 0;
const MAX_CONCURRENT_VIDEOS = 2;

async function processVideoQueue() {
  if (activeVideoGenerations >= MAX_CONCURRENT_VIDEOS || videoGenerationQueue.length === 0) {
    return;
  }

  const { resolve, reject, prompt, accent, style, duration } = videoGenerationQueue.shift();
  activeVideoGenerations++;

  try {
    console.log(`🎬 Procesando video en cola (${activeVideoGenerations}/${MAX_CONCURRENT_VIDEOS})`);
    console.log(`📝 Prompt: ${prompt}`);
    
    // Simular tiempo de generación
    await new Promise(resolve => setTimeout(resolve, 2000));
    
    console.log(`✅ Video procesado: ${prompt}`);
    resolve(`video-url-${Date.now()}`);
  } catch (error) {
    reject(error);
  } finally {
    activeVideoGenerations--;
    console.log(`📊 Generaciones activas después: ${activeVideoGenerations}/${MAX_CONCURRENT_VIDEOS}`);
    // Procesar siguiente en la cola
    processVideoQueue();
  }
}

async function generateVideoWithQueue(prompt, accent = 'neutral', style = 'realista', duration = 8) {
  return new Promise((resolve, reject) => {
    console.log('🎬 Agregando video a la cola...');
    console.log(`📊 Cola actual: ${videoGenerationQueue.length} videos en espera`);
    console.log(`📊 Generaciones activas: ${activeVideoGenerations}/${MAX_CONCURRENT_VIDEOS}`);
    
    videoGenerationQueue.push({
      resolve,
      reject,
      prompt,
      accent,
      style,
      duration
    });
    
    // Procesar la cola
    processVideoQueue();
  });
}

async function testQueue() {
  console.log('🧪 Probando sistema de cola de videos...');
  
  // Crear múltiples peticiones para probar la cola
  const promises = [];
  
  for (let i = 1; i <= 5; i++) {
    console.log(`\n📤 Enviando petición ${i}...`);
    const promise = generateVideoWithQueue(`Video de prueba ${i}`, 'colombiano', 'caricaturesco', 6);
    promises.push(promise);
    
    // Pequeña pausa entre peticiones
    await new Promise(resolve => setTimeout(resolve, 100));
  }
  
  console.log('\n⏳ Esperando que todas las peticiones se procesen...');
  
  try {
    const results = await Promise.all(promises);
    console.log('\n✅ Todas las peticiones completadas:');
    results.forEach((result, index) => {
      console.log(`   ${index + 1}: ${result}`);
    });
  } catch (error) {
    console.error('❌ Error en las peticiones:', error);
  }
}

testQueue();

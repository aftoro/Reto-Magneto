// Asegúrate de tener instalado el paquete: npm install @google/genai
require('dotenv').config();
const { GoogleGenAI } = require("@google/genai");

// Carga tu API key desde las variables de entorno o ponla directamente (menos seguro)
const API_KEY = process.env.GEMINI_API_KEY; // OJO: Asegúrate de tener configurada esta variable de entorno

if (!API_KEY) {
  console.error("Error: La variable de entorno GEMINI_API_KEY no está definida.");
  process.exit(1);
}

const ai = new GoogleGenAI({ apiKey: API_KEY });

async function testAvailableModels() {
  console.log("Probando modelos conocidos de Google Generative AI...");
  
  const modelsToTest = [
    "gemini-1.5-flash",
    "gemini-1.5-pro", 
    "gemini-2.5-flash",
    "gemini-2.5-flash-image-preview",
    "gemini-2.5-pro",
    "gemini-1.0-pro",
    "gemini-1.5-flash-8b",
    "gemini-1.5-pro-001",
    "gemini-1.5-flash-001",
    "veo-3.0-fast-generate-001",
    "imagen-3.0-generate-001"
  ];
  
  console.log("-----------------------------------------");
  console.log("Probando modelos disponibles:");
  
  for (const modelName of modelsToTest) {
    try {
      console.log(`\nProbando: ${modelName}`);
      
      // Usar la nueva API de @google/genai
      const response = await ai.models.generateContent({
        model: modelName,
        contents: "Hola"
      });
      
      // Buscar texto en las partes de la respuesta
      let text = "";
      for (const part of response.parts) {
        if (part.text) {
          text = part.text;
          break;
        }
      }
      
      console.log(`✅ ${modelName} - FUNCIONA`);
      console.log(`   Respuesta de prueba: ${text.substring(0, 50)}...`);
      
    } catch (error) {
      if (error.message.includes("not found") || error.message.includes("not available")) {
        console.log(`❌ ${modelName} - NO DISPONIBLE`);
      } else {
        console.log(`⚠️  ${modelName} - ERROR: ${error.message.substring(0, 100)}...`);
      }
    }
  }
  
  console.log("\n-----------------------------------------");
  console.log("Prueba completada.");
}

// Ejecución automática deshabilitada - usar solo cuando se necesite probar modelos
// testAvailableModels();

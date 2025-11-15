require('dotenv').config();

/**
 * Configuración de variables de entorno
 * Centraliza todas las configuraciones del sistema
 */
const config = {
  // Servidor
  port: process.env.PORT || 3000,
  nodeEnv: process.env.NODE_ENV || 'development',
  
  // Base de datos
  supabase: {
    url: process.env.SUPABASE_URL,
    anonKey: process.env.SUPABASE_ANON_KEY,
    serviceKey: process.env.SUPABASE_SERVICE_KEY
  },
  
  // Instagram
  instagram: {
    verifyToken: process.env.INSTAGRAM_VERIFY_TOKEN,
    accessToken: process.env.INSTAGRAM_ACCESS_TOKEN,
    appId: process.env.INSTAGRAM_APP_ID,
    appSecret: process.env.INSTAGRAM_APP_SECRET
  },
  
  // Google AI
  googleAI: {
    apiKey: process.env.GOOGLE_AI_API_KEY,
    model: process.env.GOOGLE_AI_MODEL || 'gemini-pro'
  },
  
  // CORS
  cors: {
    allowedOrigins: process.env.ALLOWED_ORIGINS?.split(',') || ['*'],
    credentials: true
  },
  
  // Rate Limiting
  rateLimit: {
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 15 * 60 * 1000, // 15 minutos
    maxRequests: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS) || 1000,
    webhookMaxRequests: parseInt(process.env.WEBHOOK_RATE_LIMIT_MAX_REQUESTS) || 10,
    webhookWindowMs: parseInt(process.env.WEBHOOK_RATE_LIMIT_WINDOW_MS) || 60 * 1000 // 1 minuto
  },
  
  // Logging
  logging: {
    level: process.env.LOG_LEVEL || 'info',
    enableFileLogging: process.env.ENABLE_FILE_LOGGING === 'true',
    logDirectory: process.env.LOG_DIRECTORY || './logs'
  },
  
  // Archivos
  upload: {
    maxFileSize: parseInt(process.env.MAX_FILE_SIZE) || 10 * 1024 * 1024, // 10MB
    allowedTypes: process.env.ALLOWED_FILE_TYPES?.split(',') || [
      'image/jpeg',
      'image/png',
      'image/gif',
      'video/mp4'
    ]
  },
  
  // Seguridad
  security: {
    jwtSecret: process.env.JWT_SECRET,
    bcryptRounds: parseInt(process.env.BCRYPT_ROUNDS) || 12,
    sessionSecret: process.env.SESSION_SECRET
  }
};

/**
 * Valida que las variables de entorno requeridas estén presentes
 */
function validateConfig() {
  const required = [
    'SUPABASE_URL',
    'SUPABASE_ANON_KEY'
  ];
  
  const missing = required.filter(key => !process.env[key]);
  
  if (missing.length > 0) {
    throw new Error(`Faltan variables de entorno requeridas: ${missing.join(', ')}`);
  }
  
  console.log('✅ Configuración validada correctamente');
}

/**
 * Obtiene la configuración para un entorno específico
 */
function getConfig(environment = process.env.NODE_ENV || 'development') {
  const baseConfig = { ...config };
  
  switch (environment) {
    case 'production':
      return {
        ...baseConfig,
        logging: {
          ...baseConfig.logging,
          level: 'warn',
          enableFileLogging: true
        },
        rateLimit: {
          ...baseConfig.rateLimit,
          maxRequests: 500 // Más restrictivo en producción
        }
      };
      
    case 'test':
      return {
        ...baseConfig,
        port: 0, // Puerto aleatorio para tests
        logging: {
          ...baseConfig.logging,
          level: 'error',
          enableFileLogging: false
        }
      };
      
    default: // development
      return baseConfig;
  }
}

module.exports = {
  config: getConfig(),
  validateConfig,
  getConfig
};

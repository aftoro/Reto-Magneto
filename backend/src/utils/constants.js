/**
 * Constantes de la aplicación
 * Centraliza todas las constantes utilizadas en el sistema
 */

// Constantes de la aplicación
const APP_CONSTANTS = {
  NAME: 'Magneto Empleos API',
  VERSION: '2.0.0',
  DESCRIPTION: 'API para gestión de empleos y contenido de Instagram',
  ARCHITECTURE: 'Layered Architecture with Middlewares'
};

// Constantes de base de datos
const DATABASE_CONSTANTS = {
  TABLES: {
    PROFILES: 'profiles',
    MESSAGES: 'messages',
    CONVERSATIONS: 'conversations',
    INSTAGRAM_POSTS: 'instagram_posts',
    INSTAGRAM_COMMENTS: 'instagram_comments'
  },
  ROLES: {
    USER: 'user',
    ADMIN: 'admin',
    MODERATOR: 'moderator'
  }
};

// Constantes de Instagram
const INSTAGRAM_CONSTANTS = {
  WEBHOOK_TYPES: {
    COMMENT: 'comment',
    MENTION: 'mention',
    MESSAGE: 'message'
  },
  MEDIA_TYPES: {
    IMAGE: 'image',
    VIDEO: 'video',
    CAROUSEL: 'carousel'
  },
  POST_TYPES: {
    POST: 'post',
    STORY: 'story',
    REEL: 'reel'
  }
};

// Constantes de mensajes
const MESSAGE_CONSTANTS = {
  TYPES: {
    TEXT: 'text',
    IMAGE: 'image',
    VIDEO: 'video',
    AUDIO: 'audio',
    FILE: 'file'
  },
  STATUS: {
    PENDING: 'pending',
    PROCESSED: 'processed',
    FAILED: 'failed'
  }
};

// Constantes de validación
const VALIDATION_CONSTANTS = {
  EMAIL_REGEX: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
  PASSWORD_MIN_LENGTH: 6,
  NAME_MIN_LENGTH: 2,
  MAX_FILE_SIZE: 10 * 1024 * 1024, // 10MB
  ALLOWED_FILE_TYPES: [
    'image/jpeg',
    'image/png',
    'image/gif',
    'video/mp4'
  ]
};

// Constantes de rate limiting
const RATE_LIMIT_CONSTANTS = {
  WINDOW_MS: 15 * 60 * 1000, // 15 minutos
  MAX_REQUESTS: 1000,
  WEBHOOK_WINDOW_MS: 60 * 1000, // 1 minuto
  WEBHOOK_MAX_REQUESTS: 10,
  AUTH_WINDOW_MS: 15 * 60 * 1000, // 15 minutos
  AUTH_MAX_REQUESTS: 5
};

// Constantes de logging
const LOGGING_CONSTANTS = {
  LEVELS: {
    ERROR: 'error',
    WARN: 'warn',
    INFO: 'info',
    DEBUG: 'debug'
  },
  DIRECTORY: './logs'
};

// Constantes de respuesta HTTP
const HTTP_CONSTANTS = {
  STATUS: {
    OK: 200,
    CREATED: 201,
    BAD_REQUEST: 400,
    UNAUTHORIZED: 401,
    FORBIDDEN: 403,
    NOT_FOUND: 404,
    TOO_MANY_REQUESTS: 429,
    INTERNAL_SERVER_ERROR: 500
  },
  MESSAGES: {
    SUCCESS: 'Operación exitosa',
    CREATED: 'Recurso creado exitosamente',
    UPDATED: 'Recurso actualizado exitosamente',
    DELETED: 'Recurso eliminado exitosamente',
    NOT_FOUND: 'Recurso no encontrado',
    UNAUTHORIZED: 'No autorizado',
    FORBIDDEN: 'Acceso denegado',
    BAD_REQUEST: 'Solicitud inválida',
    INTERNAL_ERROR: 'Error interno del servidor',
    TOO_MANY_REQUESTS: 'Demasiadas peticiones'
  }
};

// Constantes de AI
const AI_CONSTANTS = {
  MODELS: {
    GEMINI_PRO: 'gemini-pro',
    GEMINI_PRO_VISION: 'gemini-pro-vision'
  },
  MAX_TOKENS: 4096,
  TEMPERATURE: 0.7
};

// ============================================
// CONSTANTES DE IDENTIDAD DE MARCA
// ============================================

const BRAND_IDENTITY = {
  // Tono de comunicación
  TONE: {
    description: 'Magneto es una marca cercana y humana, por eso se comunica de manera amigable, accesible y empática.',
    characteristics: [
      'Positivo y motivador',
      'Directo pero cálido',
      'Equilibrio entre profesionalismo, confianza y calidez',
      'Términos sencillos, concisos e inclusivos',
      'Evita tecnicismos o lenguaje excesivamente formal',
      'Se expresa con energía y dinamismo'
    ],
    purpose: 'Reflejar su propósito de impulsar carreras'
  },
  
  // Eslogan principal
  MAIN_SLOGAN: 'Oportunidades que transforman',
  
  // Eslóganes secundarios
  SECONDARY_SLOGANS: [
    'Impulsamos. Conectamos. Transformamos',
    'Trabajos que transforman',
    'El trabajo que mereces'
  ],
  
  // Mensajes clave
  KEY_MESSAGES: [
    'Estamos aquí para ayudarte a encontrar la oportunidad que estabas buscando',
    'Tu próxima postulación puede cambiar tu vida ¿qué estás esperando?',
    'No es otro empleo, es avanzar hacía tus sueños',
    'No esperes, elige el lugar donde quieres estar'
  ],
  
  // Beneficios para candidatos
  CANDIDATE_BENEFITS: [
    'Acceso a miles de vacantes y empresas de todos los tamaños en Latinoamérica',
    'Filtros para la personalización y efectividad de la búsqueda',
    'Postulaciones sin límite y gratuitas',
    'Historial de aplicaciones y seguimiento a procesos',
    'Notificaciones de nuevas oportunidades',
    'Acceso gratuito e ilimitado a formación en empleabilidad'
  ]
};

module.exports = {
  APP_CONSTANTS,
  DATABASE_CONSTANTS,
  INSTAGRAM_CONSTANTS,
  MESSAGE_CONSTANTS,
  VALIDATION_CONSTANTS,
  RATE_LIMIT_CONSTANTS,
  LOGGING_CONSTANTS,
  HTTP_CONSTANTS,
  AI_CONSTANTS,
  BRAND_IDENTITY
};

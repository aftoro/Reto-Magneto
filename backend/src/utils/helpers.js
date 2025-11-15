/**
 * Funciones auxiliares y helpers
 * Contiene funciones utilitarias reutilizables
 */

const { VALIDATION_CONSTANTS, HTTP_CONSTANTS } = require('./constants');

/**
 * Valida formato de email
 */
const isValidEmail = (email) => {
  return VALIDATION_CONSTANTS.EMAIL_REGEX.test(email);
};

/**
 * Valida formato de URL
 */
const isValidUrl = (url) => {
  try {
    new URL(url);
    return true;
  } catch {
    return false;
  }
};

/**
 * Genera un ID único
 */
const generateId = () => {
  return Math.random().toString(36).substr(2, 9) + Date.now().toString(36);
};

/**
 * Formatea fecha para mostrar
 */
const formatDate = (date, options = {}) => {
  const defaultOptions = {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    timeZone: 'America/Mexico_City'
  };
  
  return new Date(date).toLocaleString('es-MX', { ...defaultOptions, ...options });
};

// Función eliminada - no se usa en el proyecto

/**
 * Sanitiza texto removiendo caracteres peligrosos
 */
const sanitizeText = (text) => {
  if (typeof text !== 'string') return text;
  return text
    .trim()
    .replace(/[<>]/g, '')
    .replace(/javascript:/gi, '')
    .replace(/on\w+=/gi, '');
};

// Funciones eliminadas - no se usan en el proyecto

/**
 * Valida tamaño de archivo
 */
const validateFileSize = (fileSize, maxSize = VALIDATION_CONSTANTS.MAX_FILE_SIZE) => {
  return fileSize <= maxSize;
};

/**
 * Valida tipo de archivo
 */
const validateFileType = (mimeType, allowedTypes = VALIDATION_CONSTANTS.ALLOWED_FILE_TYPES) => {
  return allowedTypes.includes(mimeType);
};

/**
 * Genera respuesta HTTP estandarizada
 */
const createResponse = (success, message, data = null, statusCode = HTTP_CONSTANTS.STATUS.OK) => {
  const response = {
    success,
    message,
    timestamp: new Date().toISOString()
  };
  
  if (data !== null) {
    response.data = data;
  }
  
  return { response, statusCode };
};

/**
 * Genera respuesta de éxito
 */
const createSuccessResponse = (message, data = null, statusCode = HTTP_CONSTANTS.STATUS.OK) => {
  return createResponse(true, message, data, statusCode);
};

/**
 * Genera respuesta de error
 */
const createErrorResponse = (message, statusCode = HTTP_CONSTANTS.STATUS.INTERNAL_SERVER_ERROR) => {
  return createResponse(false, message, null, statusCode);
};

/**
 * Genera respuesta de validación
 */
const createValidationResponse = (errors) => {
  return createResponse(
    false,
    'Datos de validación incorrectos',
    { errors },
    HTTP_CONSTANTS.STATUS.BAD_REQUEST
  );
};

// Funciones eliminadas - no se usan en el proyecto

module.exports = {
  isValidEmail,
  isValidUrl,
  generateId,
  formatDate,
  sanitizeText,
  validateFileSize,
  validateFileType,
  createResponse,
  createSuccessResponse,
  createErrorResponse,
  createValidationResponse
};

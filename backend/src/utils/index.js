/**
 * Índice de utilidades
 * Exporta todas las funciones y constantes utilitarias
 */

// Exportar constantes
const {
  APP_CONSTANTS,
  DATABASE_CONSTANTS,
  INSTAGRAM_CONSTANTS,
  MESSAGE_CONSTANTS,
  VALIDATION_CONSTANTS,
  RATE_LIMIT_CONSTANTS,
  LOGGING_CONSTANTS,
  HTTP_CONSTANTS,
  AI_CONSTANTS
} = require('./constants');

// Exportar helpers
const {
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
} = require('./helpers');

// Re-exportar funciones existentes
const functions = require('./functions');
const handlers = require('./handlers');
// listModels removido - no se necesita en el servidor principal

module.exports = {
  // Constantes
  APP_CONSTANTS,
  DATABASE_CONSTANTS,
  INSTAGRAM_CONSTANTS,
  MESSAGE_CONSTANTS,
  VALIDATION_CONSTANTS,
  RATE_LIMIT_CONSTANTS,
  LOGGING_CONSTANTS,
  HTTP_CONSTANTS,
  AI_CONSTANTS,
  
  // Helpers
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
  createValidationResponse,
  
  // Funciones existentes
  ...functions,
  ...handlers
};

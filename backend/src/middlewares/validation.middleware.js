const { VALIDATION_CONSTANTS, HTTP_CONSTANTS } = require('../utils/constants');
const { isValidEmail, isValidUrl, validateFileSize, validateFileType } = require('../utils/helpers');

/**
 * Middleware de validación de datos
 * Valida el formato y contenido de los datos de entrada
 */

/**
 * Valida que el body de la petición no esté vacío
 */
const validateBody = (req, res, next) => {
  if (req.method === 'POST' || req.method === 'PUT' || req.method === 'PATCH') {
    if (!req.body || Object.keys(req.body).length === 0) {
      return res.status(400).json({
        success: false,
        message: 'El cuerpo de la petición no puede estar vacío'
      });
    }
  }
  next();
};

// Usar helpers importados - no duplicar funciones

/**
 * Middleware para validar datos de usuario
 */
const validateUserData = (req, res, next) => {
  const { email, password, fullName } = req.body;
  const errors = [];

  if (email && !isValidEmail(email)) {
    errors.push('Formato de email inválido');
  }

  if (password && password.length < VALIDATION_CONSTANTS.PASSWORD_MIN_LENGTH) {
    errors.push(`La contraseña debe tener al menos ${VALIDATION_CONSTANTS.PASSWORD_MIN_LENGTH} caracteres`);
  }

  if (fullName && fullName.trim().length < VALIDATION_CONSTANTS.NAME_MIN_LENGTH) {
    errors.push(`El nombre debe tener al menos ${VALIDATION_CONSTANTS.NAME_MIN_LENGTH} caracteres`);
  }

  if (errors.length > 0) {
    return res.status(HTTP_CONSTANTS.STATUS.BAD_REQUEST).json({
      success: false,
      message: HTTP_CONSTANTS.MESSAGES.BAD_REQUEST,
      errors
    });
  }

  next();
};

/**
 * Middleware para validar datos de Instagram
 */
const validateInstagramData = (req, res, next) => {
  const { message, mediaUrl, userId } = req.body;
  const errors = [];

  if (message && message.trim().length === 0) {
    errors.push('El mensaje no puede estar vacío');
  }

  if (mediaUrl && !isValidUrl(mediaUrl)) {
    errors.push('URL de media inválida');
  }

  if (userId && typeof userId !== 'string') {
    errors.push('ID de usuario inválido');
  }

  if (errors.length > 0) {
    return res.status(400).json({
      success: false,
      message: 'Datos de Instagram inválidos',
      errors
    });
  }

  next();
};

/**
 * Middleware para validar límites de tamaño de archivo
 * Usa la función de helpers
 */
const validateFileSizeMiddleware = (maxSizeInMB = 10) => {
  return (req, res, next) => {
    if (req.file && !validateFileSize(req.file.size, maxSizeInMB * 1024 * 1024)) {
      return res.status(HTTP_CONSTANTS.STATUS.BAD_REQUEST).json({
        success: false,
        message: `El archivo excede el tamaño máximo de ${maxSizeInMB}MB`
      });
    }
    next();
  };
};

/**
 * Middleware para validar tipos de archivo
 * Usa la función de helpers
 */
const validateFileTypeMiddleware = (allowedTypes = VALIDATION_CONSTANTS.ALLOWED_FILE_TYPES) => {
  return (req, res, next) => {
    if (req.file && !validateFileType(req.file.mimetype, allowedTypes)) {
      return res.status(HTTP_CONSTANTS.STATUS.BAD_REQUEST).json({
        success: false,
        message: `Tipo de archivo no permitido. Tipos permitidos: ${allowedTypes.join(', ')}`
      });
    }
    next();
  };
};

/**
 * Middleware para sanitizar datos de entrada
 */
const sanitizeInput = (req, res, next) => {
  const sanitizeString = (str) => {
    if (typeof str !== 'string') return str;
    return str.trim().replace(/[<>]/g, '');
  };

  const sanitizeObject = (obj) => {
    if (typeof obj !== 'object' || obj === null) return obj;
    
    const sanitized = {};
    for (const [key, value] of Object.entries(obj)) {
      if (typeof value === 'string') {
        sanitized[key] = sanitizeString(value);
      } else if (typeof value === 'object') {
        sanitized[key] = sanitizeObject(value);
      } else {
        sanitized[key] = value;
      }
    }
    return sanitized;
  };

  if (req.body) {
    req.body = sanitizeObject(req.body);
  }

  next();
};

module.exports = {
  validateBody,
  validateUserData,
  validateInstagramData,
  validateFileSizeMiddleware,
  validateFileTypeMiddleware,
  sanitizeInput
};

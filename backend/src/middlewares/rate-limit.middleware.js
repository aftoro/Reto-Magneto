const { RATE_LIMIT_CONSTANTS, HTTP_CONSTANTS } = require('../utils/constants');

/**
 * Middleware de rate limiting
 * Limita el número de peticiones por IP y usuario
 */

const rateLimitMap = new Map();

/**
 * Limpia las entradas expiradas del mapa de rate limiting
 */
const cleanupExpiredEntries = () => {
  const now = Date.now();
  for (const [key, data] of rateLimitMap.entries()) {
    if (now - data.firstRequest > data.windowMs) {
      rateLimitMap.delete(key);
    }
  }
};

/**
 * Middleware de rate limiting por IP
 */
const rateLimitByIP = (options = {}) => {
  const {
    windowMs = RATE_LIMIT_CONSTANTS.WINDOW_MS,
    maxRequests = RATE_LIMIT_CONSTANTS.MAX_REQUESTS,
    message = HTTP_CONSTANTS.MESSAGES.TOO_MANY_REQUESTS
  } = options;

  return (req, res, next) => {
    const ip = req.ip || req.connection.remoteAddress;
    const now = Date.now();
    const key = `ip:${ip}`;

    // Limpiar entradas expiradas
    cleanupExpiredEntries();

    const existing = rateLimitMap.get(key);
    
    if (!existing) {
      rateLimitMap.set(key, {
        count: 1,
        firstRequest: now,
        windowMs
      });
      return next();
    }

    // Si la ventana ha expirado, reiniciar contador
    if (now - existing.firstRequest > windowMs) {
      rateLimitMap.set(key, {
        count: 1,
        firstRequest: now,
        windowMs
      });
      return next();
    }

    // Si excede el límite
    if (existing.count >= maxRequests) {
      return res.status(HTTP_CONSTANTS.STATUS.TOO_MANY_REQUESTS).json({
        success: false,
        message,
        retryAfter: Math.ceil((existing.firstRequest + windowMs - now) / 1000)
      });
    }

    // Incrementar contador
    existing.count++;
    rateLimitMap.set(key, existing);
    next();
  };
};

/**
 * Middleware de rate limiting por usuario autenticado
 */
const rateLimitByUser = (options = {}) => {
  const {
    windowMs = 15 * 60 * 1000, // 15 minutos
    maxRequests = 200, // 200 peticiones por ventana
    message = 'Demasiadas peticiones desde este usuario'
  } = options;

  return (req, res, next) => {
    if (!req.user) {
      return next(); // No aplicar rate limiting si no hay usuario
    }

    const userId = req.user.id;
    const now = Date.now();
    const key = `user:${userId}`;

    // Limpiar entradas expiradas
    cleanupExpiredEntries();

    const existing = rateLimitMap.get(key);
    
    if (!existing) {
      rateLimitMap.set(key, {
        count: 1,
        firstRequest: now,
        windowMs
      });
      return next();
    }

    // Si la ventana ha expirado, reiniciar contador
    if (now - existing.firstRequest > windowMs) {
      rateLimitMap.set(key, {
        count: 1,
        firstRequest: now,
        windowMs
      });
      return next();
    }

    // Si excede el límite
    if (existing.count >= maxRequests) {
      return res.status(HTTP_CONSTANTS.STATUS.TOO_MANY_REQUESTS).json({
        success: false,
        message,
        retryAfter: Math.ceil((existing.firstRequest + windowMs - now) / 1000)
      });
    }

    // Incrementar contador
    existing.count++;
    rateLimitMap.set(key, existing);
    next();
  };
};

/**
 * Middleware de rate limiting específico para webhooks
 */
const rateLimitWebhooks = (options = {}) => {
  const {
    windowMs = 60 * 1000, // 1 minuto
    maxRequests = 10, // 10 webhooks por minuto
    message = 'Demasiados webhooks recibidos'
  } = options;

  return (req, res, next) => {
    const ip = req.ip || req.connection.remoteAddress;
    const now = Date.now();
    const key = `webhook:${ip}`;

    cleanupExpiredEntries();

    const existing = rateLimitMap.get(key);
    
    if (!existing) {
      rateLimitMap.set(key, {
        count: 1,
        firstRequest: now,
        windowMs
      });
      return next();
    }

    if (now - existing.firstRequest > windowMs) {
      rateLimitMap.set(key, {
        count: 1,
        firstRequest: now,
        windowMs
      });
      return next();
    }

    if (existing.count >= maxRequests) {
      return res.status(HTTP_CONSTANTS.STATUS.TOO_MANY_REQUESTS).json({
        success: false,
        message,
        retryAfter: Math.ceil((existing.firstRequest + windowMs - now) / 1000)
      });
    }

    existing.count++;
    rateLimitMap.set(key, existing);
    next();
  };
};

module.exports = {
  rateLimitByIP,
  rateLimitByUser,
  rateLimitWebhooks
};

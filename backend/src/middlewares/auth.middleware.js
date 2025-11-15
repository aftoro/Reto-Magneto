const { supabase } = require('../config/database');
const { HTTP_CONSTANTS } = require('../utils/constants');

/**
 * Middleware de autenticación
 * Verifica el token JWT en el header Authorization
 */
const authMiddleware = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(HTTP_CONSTANTS.STATUS.UNAUTHORIZED).json({
        success: false,
        message: 'Token de autorización requerido'
      });
    }

    const token = authHeader.substring(7); // Remover 'Bearer '
    
    // Verificar token con Supabase
    const { data: { user }, error } = await supabase.auth.getUser(token);
    
    if (error || !user) {
      return res.status(HTTP_CONSTANTS.STATUS.UNAUTHORIZED).json({
        success: false,
        message: 'Token inválido o expirado'
      });
    }

    // Agregar usuario al request
    req.user = user;
    next();
  } catch (error) {
    console.error('Error en authMiddleware:', error);
    res.status(HTTP_CONSTANTS.STATUS.INTERNAL_SERVER_ERROR).json({
      success: false,
      message: HTTP_CONSTANTS.MESSAGES.INTERNAL_ERROR
    });
  }
};

/**
 * Middleware de autenticación opcional
 * No falla si no hay token, pero agrega usuario si existe
 */
const optionalAuthMiddleware = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    
    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = authHeader.substring(7);
      const { data: { user }, error } = await supabase.auth.getUser(token);
      
      if (!error && user) {
        req.user = user;
      }
    }
    
    next();
  } catch (error) {
    console.error('Error en optionalAuthMiddleware:', error);
    next(); // Continuar sin autenticación
  }
};

module.exports = {
  authMiddleware,
  optionalAuthMiddleware
};

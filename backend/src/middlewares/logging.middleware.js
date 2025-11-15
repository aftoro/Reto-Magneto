const fs = require('fs');
const path = require('path');

/**
 * Middleware de logging
 * Registra todas las peticiones HTTP con timestamp, método, URL, IP y user agent
 */
const loggingMiddleware = (req, res, next) => {
  const timestamp = new Date().toISOString();
  const method = req.method;
  const url = req.url;
  const ip = req.ip || req.connection.remoteAddress;
  const userAgent = req.get('User-Agent') || 'Unknown';
  const userId = req.user?.id || 'anonymous';

  // Log a archivo (opcional)
  const logDir = path.join(__dirname, '../../logs');
  if (!fs.existsSync(logDir)) {
    fs.mkdirSync(logDir, { recursive: true });
  }

  const logFile = path.join(logDir, `access-${new Date().toISOString().split('T')[0]}.log`);

  // Interceptar el evento 'finish' para capturar el status code real
  res.on('finish', () => {
    const logEntry = {
      timestamp,
      method,
      url,
      ip,
      userAgent,
      userId,
      statusCode: res.statusCode
    };

    // Log a consola solo cuando la respuesta se completa
    console.log(`[${timestamp}] ${method} ${url} - ${ip} - User: ${userId} - Status: ${res.statusCode}`);
    
    // Log a archivo
    fs.appendFileSync(logFile, JSON.stringify(logEntry) + '\n');
  });

  next();
};

/**
 * Middleware de logging de errores
 * Captura y registra errores no manejados
 */
const errorLoggingMiddleware = (err, req, res, next) => {
  const timestamp = new Date().toISOString();
  const errorLog = {
    timestamp,
    error: err.message,
    stack: err.stack,
    method: req.method,
    url: req.url,
    ip: req.ip || req.connection.remoteAddress,
    userId: req.user?.id || 'anonymous'
  };

  console.error(`[${timestamp}] ERROR:`, errorLog);

  // Log a archivo de errores
  const logDir = path.join(__dirname, '../../logs');
  if (!fs.existsSync(logDir)) {
    fs.mkdirSync(logDir, { recursive: true });
  }

  const errorLogFile = path.join(logDir, `error-${new Date().toISOString().split('T')[0]}.log`);
  fs.appendFileSync(errorLogFile, JSON.stringify(errorLog) + '\n');

  res.status(500).json({
    success: false,
    message: 'Error interno del servidor',
    ...(process.env.NODE_ENV === 'development' && { error: err.message })
  });
};

module.exports = {
  loggingMiddleware,
  errorLoggingMiddleware
};

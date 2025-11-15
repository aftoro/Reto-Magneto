const express = require('express');
const { optionalAuthMiddleware } = require('../middlewares/auth.middleware');
const { rateLimitByIP } = require('../middlewares/rate-limit.middleware');
const { sendNotificationToClients, clients } = require('../utils/functions');
const { HTTP_CONSTANTS } = require('../utils/constants');

const router = express.Router();

/**
 * Endpoint SSE para notificaciones en tiempo real
 * GET /api/notifications/stream
 * 
 * Este endpoint mantiene una conexión SSE abierta para enviar notificaciones
 * en tiempo real al cliente. La autenticación es opcional pero recomendada.
 */
router.get('/stream', 
  rateLimitByIP({ maxRequests: 10, windowMs: 60 * 1000 }), // 10 conexiones por minuto por IP
  optionalAuthMiddleware,
  async (req, res) => {
    try {
      // Configurar headers para SSE
      res.setHeader('Content-Type', 'text/event-stream');
      res.setHeader('Cache-Control', 'no-cache');
      res.setHeader('Connection', 'keep-alive');
      res.setHeader('X-Accel-Buffering', 'no'); // Deshabilitar buffering en nginx
      
      // Agregar headers CORS si es necesario
      res.setHeader('Access-Control-Allow-Origin', '*');
      res.setHeader('Access-Control-Allow-Credentials', 'true');
      
      clients.add(res);
      
      // Enviar mensaje inicial de conexión
      const welcomeMessage = {
        type: 'connected',
        message: 'Conectado a notificaciones en tiempo real',
        timestamp: new Date().toISOString(),
        authenticated: !!req.user,
        userId: req.user?.id || null
      };
      
      res.write(`data: ${JSON.stringify(welcomeMessage)}\n\n`);
      
      // Enviar ping periódico para mantener la conexión viva
      const pingInterval = setInterval(() => {
        try {
          const pingMessage = {
            type: 'ping',
            timestamp: new Date().toISOString()
          };
          res.write(`data: ${JSON.stringify(pingMessage)}\n\n`);
        } catch (error) {
          console.error('Error enviando ping SSE:', error);
          clearInterval(pingInterval);
          clients.delete(res);
        }
      }, 30000); // Ping cada 30 segundos
      
      req.on('close', () => {
        clearInterval(pingInterval);
        clients.delete(res);
        res.end();
      });
      
      res.on('error', (error) => {
        console.error('Error en conexión SSE:', error);
        clearInterval(pingInterval);
        clients.delete(res);
        res.end();
      });
      
    } catch (error) {
      console.error('Error al establecer conexión SSE:', error);
      if (!res.headersSent) {
        res.status(HTTP_CONSTANTS.STATUS.INTERNAL_SERVER_ERROR).json({
          success: false,
          message: 'Error al establecer conexión SSE',
          error: error.message
        });
      }
    }
  }
);

module.exports = router;


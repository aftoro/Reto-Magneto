const express = require('express');

// Importar rutas
const userRoutes = require('./user.routes');
const messageRoutes = require('./message.routes');
const instagramRoutes = require('./instagram.routes');
const storiesRoutes = require('./stories.routes');
const analyticsRoutes = require('./analytics.routes');
const notificationsRoutes = require('./notifications.routes');
const previewRoutes = require('./preview.routes');

const router = express.Router();

// Health check
router.get('/health', (req, res) => {
  res.json({
    success: true,
    message: 'API funcionando correctamente',
    timestamp: new Date().toISOString(),
    version: '2.0.0',
    architecture: 'Layered Architecture with Middlewares'
  });
});

// API Info
router.get('/info', (req, res) => {
  res.json({
    success: true,
    data: {
      name: 'Magneto Empleos API',
      version: '2.0.0',
      description: 'API para gestión de empleos y contenido de Instagram',
      architecture: 'Layered Architecture',
      layers: [
        'Controllers - Manejo de peticiones HTTP',
        'Services - Lógica de negocio',
        'Repositories - Acceso a datos',
        'Models - Entidades de dominio',
        'Middlewares - Autenticación, validación, logging, rate limiting'
      ],
      endpoints: {
        users: '/api/users',
        messages: '/api/messages',
        instagram: '/api/instagram'
      }
    }
  });
});

// Configurar rutas
router.use('/users', userRoutes);
router.use('/messages', messageRoutes);
router.use('/instagram', instagramRoutes);
router.use('/stories', storiesRoutes);
router.use('/analytics', analyticsRoutes);
router.use('/notifications', notificationsRoutes);
router.use('/preview', previewRoutes);

// Ruta 404 - Catch-all para rutas no encontradas
// En Express 5.x, no se puede usar '*', se usa un middleware sin patrón
// IMPORTANTE: Este middleware solo se ejecuta si ninguna ruta anterior coincidió
router.use((req, res, next) => {
  // Solo responder si la respuesta no ha sido enviada
  if (!res.headersSent) {
    res.status(404).json({
      success: false,
      message: 'Endpoint no encontrado',
      path: req.path,
      method: req.method,
      availableEndpoints: [
        'GET /api/health',
        'GET /api/info',
        'POST /api/users/register',
        'POST /api/users/login',
        'GET /api/users/profile',
        'GET /api/messages/list (requiere auth)',
        'POST /api/messages (requiere auth)',
        'GET /api/messages/conversation/:id (requiere auth)',
        'GET /api/stories',
        'GET /api/analytics/basic',
        'GET /api/analytics/ai-insights',
        'GET /api/instagram/posts',
        'GET /api/notifications/stream (SSE)',
        'POST /api/instagram/webhook/comment',
        'POST /api/instagram/webhook/message',
        'POST /api/instagram/webhook/like',
        'GET /api/preview/:id (requiere auth)',
        'GET /api/preview/:id/status (requiere auth)',
        'POST /api/preview/:id/publish (requiere auth)'
      ]
    });
  } else {
    // Si la respuesta ya fue enviada, solo pasar al siguiente middleware
    next();
  }
});

module.exports = router;

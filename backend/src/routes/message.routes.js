const express = require('express');
const MessageController = require('../controllers/MessageController');
const { authMiddleware } = require('../middlewares/auth.middleware');
const { 
  validateBody, 
  validateInstagramData, 
  sanitizeInput 
} = require('../middlewares/validation.middleware');
const { rateLimitByUser, rateLimitByIP } = require('../middlewares/rate-limit.middleware');
const { supabase } = require('../utils/functions');

const router = express.Router();
const messageController = new MessageController();

// ============================================
// RUTAS PROTEGIDAS (requieren autenticación)
// ============================================

// Aplicar middlewares globales a todas las rutas
router.use(authMiddleware);
router.use(validateBody);
router.use(sanitizeInput);

// Rate limiting por usuario
router.use(rateLimitByUser({ maxRequests: 100, windowMs: 15 * 60 * 1000 })); // 100 requests por 15 min

/**
 * Obtener conversaciones (requiere autenticación)
 * GET /api/messages/list?page=1&limit=20&platform=instagram&conversation_type=dm&status=active
 */
router.get('/list', async (req, res) => {
  try {
    const {
      page = 1,
      limit = 20,
      platform = 'instagram',
      conversation_type = 'dm',
      status = 'active',
      search
    } = req.query;

    let query = supabase
      .from('conversaciones')
      .select(`
        id,
        platform,
        conversation_type,
        external_conversation_id,
        user_id,
        username,
        status,
        user_full_name,
        user_profession,
        user_location,
        user_current_emotion,
        created_at,
        updated_at,
        last_profile_update
      `)
      .eq('platform', platform)
      .eq('conversation_type', conversation_type);

    // Filtrar por status si se proporciona
    if (status) {
      query = query.eq('status', status);
    }

    // Búsqueda por username o user_id
    if (search) {
      query = query.or(`username.ilike.%${search}%,user_id.ilike.%${search}%`);
    }

    // Paginación
    const offset = (parseInt(page) - 1) * parseInt(limit);
    query = query
      .order('updated_at', { ascending: false })
      .range(offset, offset + parseInt(limit) - 1);

    const { data: conversations, error } = await query;

    if (error) {
      console.error('Error obteniendo conversaciones:', error);
      return res.status(500).json({
        success: false,
        message: 'Error al obtener conversaciones',
        error: error.message
      });
    }


    // Obtener total para paginación
    let countQuery = supabase
      .from('conversaciones')
      .select('*', { count: 'exact', head: true })
      .eq('platform', platform)
      .eq('conversation_type', conversation_type);

    if (status) {
      countQuery = countQuery.eq('status', status);
    }

    if (search) {
      countQuery = countQuery.or(`username.ilike.%${search}%,user_id.ilike.%${search}%`);
    }

    const { count } = await countQuery;

    // Obtener último mensaje para cada conversación
    const conversationsWithLastMessage = await Promise.all(
      (conversations || []).map(async (conv) => {
        const { data: lastMessage } = await supabase
          .from('mensajes')
          .select('content, created_at, message_type, is_ai_generated')
          .eq('conversacion_id', conv.id)
          .order('created_at', { ascending: false })
          .limit(1)
          .single();

        return {
          ...conv,
          lastMessage: lastMessage || null
        };
      })
    );

    res.json({
      success: true,
      data: {
        chats: conversationsWithLastMessage,
        total: count || 0,
        page: parseInt(page),
        limit: parseInt(limit),
        has_more: (count || 0) > offset + parseInt(limit)
      }
    });
  } catch (error) {
    console.error('Error en GET /api/messages:', error);
    res.status(500).json({
      success: false,
      message: 'Error al obtener conversaciones',
      error: error.message
    });
  }
});

// Rutas de mensajes protegidas adicionales
router.post('/', 
  validateInstagramData,
  messageController.createMessage.bind(messageController)
);

router.get('/conversation/:conversationId', 
  messageController.getMessagesByConversation.bind(messageController)
);

router.get('/my-messages', 
  messageController.getMyMessages.bind(messageController)
);

router.get('/search', 
  messageController.searchMessages.bind(messageController)
);

router.get('/type/:type', 
  messageController.getMessagesByType.bind(messageController)
);

router.get('/unprocessed', 
  messageController.getUnprocessedMessages.bind(messageController)
);

router.get('/stats', 
  messageController.getMessageStats.bind(messageController)
);

router.get('/ai-history/:conversationId', 
  messageController.getMessageHistoryForAI.bind(messageController)
);

router.post('/ai-response', 
  validateInstagramData,
  messageController.createAIResponse.bind(messageController)
);

router.post('/batch-process', 
  messageController.processBatchMessages.bind(messageController)
);

router.get('/:id', 
  messageController.getMessageById.bind(messageController)
);

router.put('/:id', 
  validateInstagramData,
  messageController.updateMessage.bind(messageController)
);

router.patch('/:id/process', 
  messageController.markAsProcessed.bind(messageController)
);

router.delete('/:id', 
  messageController.deleteMessage.bind(messageController)
);

module.exports = router;

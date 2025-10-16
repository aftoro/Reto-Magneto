const express = require('express');
const cors = require('cors');
const crypto = require('crypto');
const multer = require('multer');
require('dotenv').config();

// Importar funciones y handlers
const {
  supabase,
  getGeminiClient,
  convertMessagesForGemini,
  clients,
  sendNotificationToClients,
  notifyNewMessage,
  notifyNewConversation,
  getInstagramUserInfo,
  getInstagramUsername,
  detectUserEmotion,
  updateUserProfileInfo,
  getUserMessageHistory,
  buildMessages,
  buildMessagesWithContent,
  getRecentContentForAI,
  getRelevantContentForUser,
  getPostsAnalytics,
  getDMAnalytics,
  generateAIAnalytics,
  generateImproveSuggestions,
  generateCaptionOptions,
  generateCompletePreview,
  generateCompleteReelPreview,
  generateResponseWithFunctionCalling,
  videoProcessingQueue,
  saveConversationToSupabase,
  saveMessageToSupabase,
  isMessageAlreadyProcessed,
  generateDMConversationId,
  getOrCreateDMConversation,
  uploadImageToStorage,
  generateImageWithGemini,
  createVacancyImageTemplate,
  splitLongMessage,
  convertToInstagramFormat,
  fuzzySearchMessages,
  fuzzySearchConversations,
  hybridSearch,
  exactSearch,
  getUserMissingData,
  getNextDataCollectionQuestion,
  extractUserDataFromMessage,
  updateUserData,
  getPostComments,
  getAllInstagramPosts,
  generateAIContent,
  generateVideo,
  publishInstagramPost,
  publishInstagramStory,
  publishInstagramReel,
  sendInstagramDMReply
} = require('./functions');

const {
  handleInstagramComment,
  handleInstagramMention,
  handleInstagramMessage
} = require('./handlers');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Configuración de multer para subida de archivos
const storage = multer.memoryStorage();
const upload = multer({ 
  storage: storage,
  limits: {
    fileSize: 10 * 1024 * 1024 // 10MB
  }
});

// =============================================
// ENDPOINTS DE SALUD Y VERIFICACIÓN
// =============================================

// Health check
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

// Verificación de webhook de Instagram
app.get('/webhook/instagram', (req, res) => {
  const mode = req.query['hub.mode'];
  const token = req.query['hub.verify_token'];
  const challenge = req.query['hub.challenge'];

  console.log('🔍 Verificando webhook:', { mode, token: token ? 'Presente' : 'Ausente', challenge: challenge ? 'Presente' : 'Ausente' });
  console.log('🔑 Token esperado:', process.env.INSTAGRAM_ACCESS_TOKEN ? 'Presente' : 'Ausente');

  if (mode === 'subscribe' && token === process.env.INSTAGRAM_ACCESS_TOKEN) {
    console.log('✅ Webhook verificado exitosamente');
    res.status(200).send(challenge);
  } else {
    console.log('❌ Error verificando webhook - Token no coincide');
    res.status(403).json({ error: 'Forbidden' });
  }
});

// =============================================
// WEBHOOK DE INSTAGRAM
// =============================================

// Webhook de Instagram
app.post('/webhook/instagram', (req, res) => {
  try {
    const body = req.body;
    console.log('Webhook recibido:', JSON.stringify(body, null, 2));

    // Verificar firma del webhook (opcional)
    const signature = req.headers['x-hub-signature-256'];
    if (signature && process.env.INSTAGRAM_WEBHOOK_SECRET) {
      try {
        const expectedSignature = crypto
          .createHmac('sha256', process.env.INSTAGRAM_WEBHOOK_SECRET)
          .update(JSON.stringify(body))
          .digest('hex');
        
        const receivedSignature = signature.replace('sha256=', '');
        
        if (expectedSignature !== receivedSignature) {
          console.error('Firma del webhook inválida');
          return res.status(401).json({ error: 'Invalid signature' });
        }
      } catch (error) {
        console.warn('Error verificando firma del webhook:', error.message);
      }
    }

    // Procesar eventos
    if (body.object === 'instagram') {
      body.entry?.forEach(entry => {
        // Procesar mensajes directos (messaging)
        if (entry.messaging) {
          entry.messaging.forEach(messaging => {
            if (messaging.message) {
              const messageData = {
                id: messaging.message.mid,
                text: messaging.message.text,
                sender: messaging.sender,
                recipient: messaging.recipient,
                timestamp: messaging.timestamp
              };
              console.log('Procesando mensaje DM:', messageData);
              handleInstagramMessage(messageData);
            }
          });
        }
        
        // Procesar cambios (comments, mentions)
        entry.changes?.forEach(change => {
          if (change.field === 'comments') {
            const commentData = change.value;
            if (commentData.parent_id) {
              // Es una respuesta a comentario, procesar como comentario
              handleInstagramComment(commentData);
            } else {
              // Es un comentario nuevo
              handleInstagramComment(commentData);
            }
          } else if (change.field === 'mentions') {
            const mentionData = change.value;
            handleInstagramMention(mentionData);
          } else if (change.field === 'messages') {
            const messageData = change.value;
            handleInstagramMessage(messageData);
          }
        });
      });
    }

    res.status(200).json({ status: 'OK' });
  } catch (error) {
    console.error('Error procesando webhook:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// =============================================
// ENDPOINTS DE IA AGENT
// =============================================

// Endpoint para respuesta del agente IA
app.post('/api/agent/reply', async (req, res) => {
  try {
    const { userText, context, mediaInfo, messageHistory } = req.body;
    
    if (!userText) {
      return res.status(400).json({ error: 'userText es requerido' });
    }

    const geminiClient = getGeminiClient();
    if (!geminiClient) {
      return res.status(500).json({ error: 'Cliente IA no disponible' });
    }

    // Usar function calling para actualización automática de datos
    const { reply, functionCalls } = await generateResponseWithFunctionCalling(
      userText, 
      context, 
      mediaInfo, 
      messageHistory, 
      null, // userData
      null  // userId (no disponible en este endpoint)
    );
    
    res.json({
      reply: reply,
      functionCalls: functionCalls,
      model: 'gemini-2.5-flash-lite',
      timestamp: new Date().toISOString()
    });
    
  } catch (error) {
    console.error('Error en agent/reply:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint para streaming del agente IA
app.get('/api/agent/stream', async (req, res) => {
  try {
    const { userText, context, mediaInfo, messageHistory } = req.query;
    
    if (!userText) {
      return res.status(400).json({ error: 'userText es requerido' });
    }

    const geminiClient = getGeminiClient();
    if (!geminiClient) {
      return res.status(500).json({ error: 'Cliente IA no disponible' });
    }

    res.setHeader('Content-Type', 'text/plain');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');

    // Usar function calling para actualización automática de datos
    const { reply, functionCalls } = await generateResponseWithFunctionCalling(
      userText, 
      context, 
      mediaInfo, 
      messageHistory ? JSON.parse(messageHistory) : [], 
      null, // userData
      null  // userId (no disponible en este endpoint)
    );
    
    // Simular streaming enviando la respuesta completa
    res.write(reply);
    res.end();
    
  } catch (error) {
    console.error('Error en agent/stream:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// =============================================
// ENDPOINTS DE CONVERSACIONES Y CHATS
// =============================================

// Endpoint para obtener conversaciones
app.get('/api/conversations', async (req, res) => {
  try {
    const { platform = 'instagram', conversation_type = 'dm', status = 'active' } = req.query;
    
    const { data: conversations, error } = await supabase
      .from('conversaciones')
      .select(`
        *,
        mensajes (
          id,
          content,
          message_type,
          is_ai_generated,
          author_name,
          author_type,
          ai_model,
          created_at,
          sent_at,
          delivery_status
        )
      `)
      .eq('platform', platform)
      .eq('conversation_type', conversation_type)
      .eq('status', status)
      .order('updated_at', { ascending: false });

    if (error) {
      console.error('Error obteniendo conversaciones:', error);
      return res.status(500).json({ error: 'Error obteniendo conversaciones' });
    }

    // Ordenar mensajes dentro de cada conversación por fecha ascendente
    const conversationsWithOrderedMessages = conversations?.map(conv => ({
      ...conv,
      mensajes: conv.mensajes?.sort((a, b) => new Date(a.created_at) - new Date(b.created_at))
    })) || [];

    res.json({
      conversations: conversationsWithOrderedMessages,
      total: conversationsWithOrderedMessages.length,
      platform,
      conversation_type,
      status
    });
    
  } catch (error) {
    console.error('Error en conversations endpoint:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint para obtener mensajes de una conversación específica
app.get('/api/conversations/:conversationId/messages', async (req, res) => {
  try {
    const { conversationId } = req.params;
    const { limit = 50, offset = 0 } = req.query;
    
    console.log(`🔍 Obteniendo mensajes de conversación ${conversationId}:`, { limit, offset });
    
    const { data: messages, error } = await supabase
      .from('mensajes')
      .select(`
        id,
        content,
        message_type,
        is_ai_generated,
        author_name,
        author_type,
        ai_model,
        created_at,
        sent_at,
        delivery_status
      `)
      .eq('conversacion_id', conversationId)
      .order('created_at', { ascending: true })
      .range(offset, offset + parseInt(limit) - 1);

    if (error) {
      console.error('❌ Error obteniendo mensajes:', error);
      return res.status(500).json({ error: 'Error obteniendo mensajes' });
    }

    console.log(`📨 Encontrados ${messages?.length || 0} mensajes para conversación ${conversationId}`);
    
    if (messages && messages.length > 0) {
      console.log('📝 Primeros mensajes:', messages.slice(0, 3).map(msg => ({
        id: msg.id,
        content: msg.content.substring(0, 30) + '...',
        author: msg.author_name,
        is_ai: msg.is_ai_generated,
        created_at: msg.created_at
      })));
    }

    const response = {
      conversation_id: conversationId,
      messages: messages || [],
      total: messages?.length || 0,
      limit: parseInt(limit),
      offset: parseInt(offset)
    };

    console.log('✅ Respuesta de /api/conversations/:id/messages enviada');

    res.json(response);
    
  } catch (error) {
    console.error('Error en messages endpoint:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint para obtener una conversación específica con todos sus mensajes
app.get('/api/conversations/:conversationId', async (req, res) => {
  try {
    const { conversationId } = req.params;
    
    console.log(`🔍 Obteniendo conversación específica: ${conversationId}`);
    
    const { data: conversation, error } = await supabase
      .from('conversaciones')
      .select(`
        *,
        mensajes (
          id,
          content,
          message_type,
          is_ai_generated,
          author_name,
          author_type,
          ai_model,
          created_at,
          sent_at,
          delivery_status
        )
      `)
      .eq('id', conversationId)
      .single();

    if (error) {
      console.error('❌ Error obteniendo conversación:', error);
      return res.status(404).json({ error: 'Conversación no encontrada' });
    }

    // Ordenar mensajes por fecha ascendente
    conversation.mensajes = conversation.mensajes?.sort((a, b) => new Date(a.created_at) - new Date(b.created_at)) || [];

    console.log(`💬 Conversación ${conversationId}:`, {
      username: conversation.username,
      conversation_type: conversation.conversation_type,
      message_count: conversation.mensajes.length,
      user_profile: {
        full_name: conversation.user_full_name,
        profession: conversation.user_profession,
        emotion: conversation.user_current_emotion,
        data_completion: conversation.user_data_completion_percentage + '%'
      },
      messages: conversation.mensajes.map(msg => ({
        id: msg.id,
        content: msg.content.substring(0, 50) + '...',
        author: msg.author_name,
        is_ai: msg.is_ai_generated,
        created_at: msg.created_at
      }))
    });

    console.log('✅ Respuesta de /api/conversations/:id enviada');

    res.json(conversation);
    
  } catch (error) {
    console.error('Error en conversation endpoint:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint para obtener chats con paginación y filtros
app.get('/api/chats', async (req, res) => {
  try {
    const { 
      platform = 'instagram', 
      conversation_type = 'dm', 
      status = 'active',
      search = '',
      limit = 20, 
      offset = 0 
    } = req.query;
    
    console.log('🔍 Obteniendo chats con parámetros:', { 
      platform, 
      conversation_type, 
      status, 
      search, 
      limit, 
      offset 
    });
    
    // Construir query base
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
        created_at,
        updated_at,
        user_current_emotion,
        last_profile_update,
        user_full_name,
        user_profession,
        user_studies,
        user_experience_years,
        user_skills,
        user_location,
        user_languages,
        user_salary_expectation,
        user_availability,
        user_interests,
        user_company_size_preference,
        user_industry_preference,
        user_work_mode_preference,
        user_career_level,
        user_portfolio_url,
        user_linkedin_url,
        user_github_url,
        user_data_completion_percentage,
        last_data_collection,
        mensajes!inner(
          id,
          content,
          message_type,
          is_ai_generated,
          author_name,
          author_type,
          ai_model,
          created_at,
          sent_at,
          delivery_status
        )
      `)
      .eq('platform', platform)
      .eq('conversation_type', conversation_type)
      .eq('status', status);
    
    // Aplicar filtro de búsqueda si existe
    if (search) {
      query = query.or(`username.ilike.%${search}%,external_conversation_id.ilike.%${search}%`);
    }
    
    // Aplicar paginación
    query = query
      .order('updated_at', { ascending: false })
      .range(offset, offset + parseInt(limit) - 1);
    
    const { data: conversations, error } = await query;

    if (error) {
      console.error('❌ Error obteniendo chats:', error);
      return res.status(500).json({ error: 'Error obteniendo chats' });
    }

    console.log(`📊 Encontradas ${conversations?.length || 0} conversaciones`);

    // Ordenar mensajes dentro de cada conversación por fecha ascendente
    const chatsWithOrderedMessages = conversations?.map(conv => {
      const orderedMessages = conv.mensajes?.sort((a, b) => new Date(a.created_at) - new Date(b.created_at)) || [];
      
      console.log(`💬 Chat ${conv.id}:`, {
        username: conv.username,
        conversation_type: conv.conversation_type,
        message_count: orderedMessages.length,
        last_message: orderedMessages.length > 0 ? {
          content: orderedMessages[orderedMessages.length - 1].content.substring(0, 50) + '...',
          author: orderedMessages[orderedMessages.length - 1].author_name,
          is_ai: orderedMessages[orderedMessages.length - 1].is_ai_generated,
          created_at: orderedMessages[orderedMessages.length - 1].created_at
        } : 'Sin mensajes',
        user_data_completion: conv.user_data_completion_percentage + '%'
      });

      const result = {
        ...conv,
        mensajes: orderedMessages,
        user_profile: {
          full_name: conv.user_full_name,
          profession: conv.user_profession,
          emotion: conv.user_current_emotion
        }
      };
      
      console.log('🔍 Debug user_profile:', {
        user_full_name: conv.user_full_name,
        user_profession: conv.user_profession,
        user_current_emotion: conv.user_current_emotion,
        user_profile: result.user_profile
      });
      
      return result;
    }) || [];

    // Contar total para paginación
    let countQuery = supabase
      .from('conversaciones')
      .select('*', { count: 'exact', head: true })
      .eq('platform', platform)
      .eq('conversation_type', conversation_type)
      .eq('status', status);
    
    if (search) {
      countQuery = countQuery.or(`username.ilike.%${search}%,external_conversation_id.ilike.%${search}%`);
    }
    
    const { count } = await countQuery;

    const response = {
      chats: chatsWithOrderedMessages,
      total: count || 0,
      limit: parseInt(limit),
      offset: parseInt(offset),
      has_more: (offset + parseInt(limit)) < (count || 0),
      platform,
      conversation_type,
      status,
      search
    };

    console.log('✅ Respuesta de /api/chats:', {
      total_chats: chatsWithOrderedMessages.length,
      total_count: count || 0,
      has_more: response.has_more,
      platform,
      conversation_type
    });

    res.json(response);
    
  } catch (error) {
    console.error('Error en chats endpoint:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// =============================================
// ENDPOINTS DE PERFILES Y EMOCIONES
// =============================================

// Endpoint para actualizar perfil de usuario específico
app.post('/api/users/:userId/update-profile', async (req, res) => {
  try {
    const { userId } = req.params;
    
    // Buscar conversación del usuario
    const { data: conversation, error: convError } = await supabase
      .from('conversaciones')
      .select('id')
      .eq('user_id', userId)
      .eq('platform', 'instagram')
      .eq('conversation_type', 'dm')
      .single();
    
    if (convError || !conversation) {
      return res.status(404).json({ error: 'Conversación no encontrada' });
    }
    
    // Actualizar perfil
    const updatedProfile = await updateUserProfileInfo(conversation.id, userId);
    
    if (!updatedProfile) {
      return res.status(500).json({ error: 'Error actualizando perfil' });
    }
    
    res.json({
      success: true,
      message: 'Perfil actualizado exitosamente',
      profile: updatedProfile
    });
    
  } catch (error) {
    console.error('Error en update-profile:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint para obtener historial de emociones de un usuario
app.get('/api/users/:userId/emotions', async (req, res) => {
  try {
    const { userId } = req.params;
    const { limit = 20, offset = 0 } = req.query;
    
    const { data: emotions, error } = await supabase
      .from('user_emotions')
      .select('*')
      .eq('user_id', userId)
      .order('created_at', { ascending: false })
      .range(offset, offset + parseInt(limit) - 1);
    
    if (error) {
      console.error('Error obteniendo emociones:', error);
      return res.status(500).json({ error: 'Error obteniendo emociones' });
    }
    
    res.json({
      user_id: userId,
      emotions: emotions || [],
      total: emotions?.length || 0
    });
    
  } catch (error) {
    console.error('Error en emotions endpoint:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});


// Endpoint para obtener estadísticas de emociones
app.get('/api/emotions/stats', async (req, res) => {
  try {
    const { platform = 'instagram' } = req.query;
    
    // Estadísticas generales de emociones
    const { data: emotionStats, error: emotionError } = await supabase
      .from('user_emotions')
      .select('emotion')
      .gte('created_at', new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString()); // Últimos 7 días
    
    if (emotionError) {
      console.error('Error obteniendo estadísticas de emociones:', emotionError);
      return res.status(500).json({ error: 'Error obteniendo estadísticas' });
    }
    
    // Contar emociones
    const emotionCounts = {};
    emotionStats?.forEach(item => {
      emotionCounts[item.emotion] = (emotionCounts[item.emotion] || 0) + 1;
    });
    
    // Estadísticas de usuarios con emociones actuales
    const { data: currentEmotions, error: currentError } = await supabase
      .from('conversaciones')
      .select('user_current_emotion')
      .eq('platform', platform)
      .not('user_current_emotion', 'is', null);
    
    if (currentError) {
      console.error('Error obteniendo emociones actuales:', currentError);
      return res.status(500).json({ error: 'Error obteniendo estadísticas' });
    }
    
    const currentEmotionCounts = {};
    currentEmotions?.forEach(item => {
      currentEmotionCounts[item.user_current_emotion] = (currentEmotionCounts[item.user_current_emotion] || 0) + 1;
    });
    
    res.json({
      last_7_days: emotionCounts,
      current_emotions: currentEmotionCounts,
      total_emotion_detections: emotionStats?.length || 0,
      users_with_current_emotion: currentEmotions?.length || 0
    });
    
  } catch (error) {
    console.error('Error en emotions/stats:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// =============================================
// ENDPOINTS DE RECOLECCIÓN DE DATOS
// =============================================

// Endpoint para obtener datos faltantes de un usuario
app.get('/api/users/:userId/missing-data', async (req, res) => {
  try {
    const { userId } = req.params;
    
    const userData = await getUserMissingData(userId);
    
    if (!userData) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }
    
    res.json({
      user_id: userId,
      missing_data: userData.missingData,
      completion_percentage: userData.completionPercentage,
      conversation: userData.conversation
    });
    
  } catch (error) {
    console.error('Error en missing-data endpoint:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint para obtener siguiente pregunta de recolección
app.get('/api/users/:userId/next-question', async (req, res) => {
  try {
    const { userId } = req.params;
    
    const nextQuestion = await getNextDataCollectionQuestion(userId);
    
    if (!nextQuestion) {
      return res.json({
        has_questions: false,
        message: 'Usuario tiene todos los datos completos'
      });
    }
    
    res.json({
      has_questions: true,
      question: nextQuestion
    });
    
  } catch (error) {
    console.error('Error en next-question endpoint:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint para actualizar datos del usuario manualmente
app.post('/api/users/:userId/update-data', async (req, res) => {
  try {
    const { userId } = req.params;
    const { data_type, data_value } = req.body;
    
    if (!data_type || !data_value) {
      return res.status(400).json({ error: 'data_type y data_value son requeridos' });
    }
    
    const updatedData = await updateUserData(userId, data_type, data_value);
    
    if (!updatedData) {
      return res.status(500).json({ error: 'Error actualizando datos' });
    }
    
    res.json({
      success: true,
      message: 'Datos actualizados exitosamente',
      data: updatedData
    });
    
  } catch (error) {
    console.error('Error en update-data endpoint:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// =============================================
// ENDPOINTS DE ESTADÍSTICAS
// =============================================

// Endpoint para estadísticas de conversaciones
app.get('/api/conversations/stats', async (req, res) => {
  try {
    const { platform = 'instagram' } = req.query;
    
    const { data: stats, error } = await supabase
      .from('conversaciones')
      .select('platform, conversation_type, status')
      .eq('platform', platform);

    if (error) {
      console.error('Error obteniendo estadísticas:', error);
      return res.status(500).json({ error: 'Error obteniendo estadísticas' });
    }

    // Procesar estadísticas
    const statsByType = {};
    const statsByStatus = {};
    
    stats?.forEach(stat => {
      // Por tipo de conversación
      if (!statsByType[stat.conversation_type]) {
        statsByType[stat.conversation_type] = 0;
      }
      statsByType[stat.conversation_type]++;
      
      // Por estado
      if (!statsByStatus[stat.status]) {
        statsByStatus[stat.status] = 0;
      }
      statsByStatus[stat.status]++;
    });

    res.json({
      platform,
      total_conversations: stats?.length || 0,
      by_type: statsByType,
      by_status: statsByStatus,
      timestamp: new Date().toISOString()
    });
    
  } catch (error) {
    console.error('Error en conversations/stats:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint para estadísticas de mensajes
app.get('/api/messages/stats', async (req, res) => {
  try {
    const { platform = 'instagram', days = 7 } = req.query;
    
    const dateFrom = new Date(Date.now() - parseInt(days) * 24 * 60 * 60 * 1000).toISOString();
    
    const { data: stats, error } = await supabase
      .from('mensajes')
      .select('message_type, is_ai_generated, author_type, created_at, conversaciones!inner(platform)')
      .eq('conversaciones.platform', platform)
      .gte('created_at', dateFrom);

    if (error) {
      console.error('Error obteniendo estadísticas de mensajes:', error);
      return res.status(500).json({ error: 'Error obteniendo estadísticas' });
    }

    // Procesar estadísticas
    const statsByType = {};
    const statsByAuthor = {};
    const aiStats = { total: 0, models: {} };
    
    stats?.forEach(stat => {
      // Por tipo de mensaje
      if (!statsByType[stat.message_type]) {
        statsByType[stat.message_type] = 0;
      }
      statsByType[stat.message_type]++;
      
      // Por autor
      if (!statsByAuthor[stat.author_type]) {
        statsByAuthor[stat.author_type] = 0;
      }
      statsByAuthor[stat.author_type]++;
      
      // Estadísticas de IA
      if (stat.is_ai_generated) {
        aiStats.total++;
        if (stat.ai_model) {
          if (!aiStats.models[stat.ai_model]) {
            aiStats.models[stat.ai_model] = 0;
          }
          aiStats.models[stat.ai_model]++;
        }
      }
    });

    res.json({
      platform,
      period_days: parseInt(days),
      total_messages: stats?.length || 0,
      by_type: statsByType,
      by_author: statsByAuthor,
      ai_stats: aiStats,
      timestamp: new Date().toISOString()
    });
    
  } catch (error) {
    console.error('Error en messages/stats:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// =============================================
// ENDPOINTS DE BÚSQUEDA
// =============================================

// Endpoint principal de búsqueda
app.get('/api/search', async (req, res) => {
  try {
    const { 
      q: query, 
      type = 'all', 
      fuzzy = 'true',
      platform = 'instagram',
      conversation_type = 'dm',
      author_type,
      limit = 50,
      offset = 0,
      date_from,
      date_to
    } = req.query;
    
    if (!query || query.trim().length < 2) {
      return res.status(400).json({ error: 'Query debe tener al menos 2 caracteres' });
    }
    
    const filters = {
      platform,
      conversation_type,
      author_type,
      limit: parseInt(limit),
      offset: parseInt(offset),
      date_from,
      date_to
    };
    
    let results;
    
    if (fuzzy === 'true') {
      results = await hybridSearch(query, type, filters);
    } else {
      results = await exactSearch(query, type, filters);
    }
    
    res.json(results);
    
  } catch (error) {
    console.error('Error en search endpoint:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint de búsqueda rápida
app.get('/api/search/quick', async (req, res) => {
  try {
    const { q: query, limit = 10 } = req.query;
    
    if (!query || query.trim().length < 2) {
      return res.status(400).json({ error: 'Query debe tener al menos 2 caracteres' });
    }
    
    const filters = { limit: parseInt(limit) };
    const results = await hybridSearch(query, 'all', filters);
    
    // Retornar solo los primeros resultados más relevantes
    res.json({
      query,
      conversations: results.conversations.slice(0, 5),
      messages: results.messages.slice(0, 5),
      total_results: Math.min(results.total_results, 10),
      search_type: 'quick'
    });
    
  } catch (error) {
    console.error('Error en search/quick endpoint:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint de búsqueda fuzzy avanzada
app.get('/api/search/fuzzy', async (req, res) => {
  try {
    const { 
      q: query, 
      type = 'all',
      threshold = 0.4,
      platform = 'instagram',
      conversation_type = 'dm',
      limit = 50,
      offset = 0
    } = req.query;
    
    if (!query || query.trim().length < 2) {
      return res.status(400).json({ error: 'Query debe tener al menos 2 caracteres' });
    }
    
    const filters = {
      platform,
      conversation_type,
      limit: parseInt(limit),
      offset: parseInt(offset)
    };
    
    const results = await hybridSearch(query, type, filters);
    
    res.json({
      ...results,
      threshold: parseFloat(threshold),
      search_type: 'fuzzy_advanced'
    });
    
  } catch (error) {
    console.error('Error en search/fuzzy endpoint:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint de búsqueda por usuario específico
app.get('/api/search/user/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    const { q: query, limit = 20, offset = 0 } = req.query;
    
    if (!query || query.trim().length < 2) {
      return res.status(400).json({ error: 'Query debe tener al menos 2 caracteres' });
    }
    
    const { data: messages, error } = await supabase
      .from('mensajes')
      .select(`
        id,
        content,
        message_type,
        is_ai_generated,
        author_name,
        author_type,
        ai_model,
        created_at,
        sent_at,
        delivery_status,
        conversacion_id,
        conversaciones!inner(
          id,
          platform,
          conversation_type,
          user_id,
          username,
          status
        )
      `)
      .eq('conversaciones.user_id', userId)
      .eq('conversaciones.platform', 'instagram')
      .ilike('content', `%${query}%`)
      .order('created_at', { ascending: false })
      .range(offset, offset + parseInt(limit) - 1);
    
    if (error) {
      console.error('Error buscando mensajes del usuario:', error);
      return res.status(500).json({ error: 'Error buscando mensajes' });
    }
    
    res.json({
      user_id: userId,
      query,
      messages: messages || [],
      total: messages?.length || 0,
      limit: parseInt(limit),
      offset: parseInt(offset)
    });
    
  } catch (error) {
    console.error('Error en search/user endpoint:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// =============================================
// ENDPOINTS DE NOTIFICACIONES SSE
// =============================================

// Endpoint para notificaciones en tiempo real (SSE)
app.get('/api/notifications/stream', (req, res) => {
  // Configurar headers para SSE
  res.writeHead(200, {
    'Content-Type': 'text/event-stream',
    'Cache-Control': 'no-cache',
    'Connection': 'keep-alive',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Cache-Control'
  });

  // Agregar cliente a la lista
  clients.add(res);
  
  console.log(`Cliente SSE conectado. Total clientes: ${clients.size}`);

  // Enviar mensaje de conexión
  res.write(`data: ${JSON.stringify({
    type: 'connection',
    message: 'Conectado a notificaciones en tiempo real',
    timestamp: new Date().toISOString()
  })}\n\n`);

  // Función para enviar ping periódico
  const pingInterval = setInterval(() => {
    try {
      res.write(`data: ${JSON.stringify({
        type: 'ping',
        timestamp: new Date().toISOString()
      })}\n\n`);
    } catch (error) {
      console.error('Error enviando ping SSE:', error);
      clearInterval(pingInterval);
      clients.delete(res);
    }
  }, 30000); // Ping cada 30 segundos

  // Manejar desconexión
  req.on('close', () => {
    console.log('Cliente SSE desconectado');
    clearInterval(pingInterval);
    clients.delete(res);
  });

  req.on('error', (error) => {
    console.error('Error en conexión SSE:', error);
    clearInterval(pingInterval);
    clients.delete(res);
  });
});

// =============================================
// ENDPOINTS DE ENVÍO MANUAL
// =============================================

// Endpoint para enviar DM manual
app.post('/api/send-dm', async (req, res) => {
  try {
    const { recipient_id, message, sender_name = 'Agente', author_type = 'agent' } = req.body;
    
    if (!recipient_id || !message) {
      return res.status(400).json({ error: 'recipient_id y message son requeridos' });
    }

    // Obtener o crear conversación
    const conversation = await getOrCreateDMConversation(
      recipient_id, 
      '17841477544945260', // Bot ID
      null
    );

    if (!conversation) {
      return res.status(500).json({ error: 'Error creando/obteniendo conversación' });
    }

    // Dividir mensaje si es muy largo
    const messageParts = splitLongMessage(message);
    const results = [];

    // Enviar cada parte
    for (let i = 0; i < messageParts.length; i++) {
      const part = messageParts[i];
      
      const sendResult = await sendInstagramDMReply(recipient_id, part);
      
      if (sendResult.success) {
        // Guardar mensaje enviado
        const messageData = {
          conversacion_id: conversation.id,
          platform_message_id: `manual_dm_${Date.now()}_${i}`,
          content: part,
          message_type: 'outgoing',
          is_ai_generated: false,
          author_name: sender_name,
          author_type: author_type
        };

        await saveMessageToSupabase(messageData);
        results.push({ part: i + 1, success: true });
      } else {
        results.push({ part: i + 1, success: false, error: sendResult.error });
        break;
      }
      
      // Delay entre mensajes
      if (i < messageParts.length - 1) {
        await new Promise(resolve => setTimeout(resolve, 1000));
      }
    }

    const allSuccessful = results.every(r => r.success);
    
    res.json({
      success: allSuccessful,
      conversation_id: conversation.id,
      recipient_id,
      message_parts: results,
      total_parts: messageParts.length
    });
    
  } catch (error) {
    console.error('Error en send-dm:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// =============================================
// ENDPOINTS DE USUARIOS
// =============================================

// Endpoint para listar usuarios
app.get('/api/users', async (req, res) => {
  try {
    const { platform = 'instagram', limit = 50, offset = 0 } = req.query;
    
    const { data: users, error } = await supabase
      .from('conversaciones')
      .select(`
        user_id,
        username,
        user_current_emotion,
        user_full_name,
        user_profession,
        user_data_completion_percentage,
        created_at,
        updated_at
      `)
      .eq('platform', platform)
      .eq('conversation_type', 'dm')
      .not('user_id', 'is', null)
      .order('updated_at', { ascending: false })
      .range(offset, offset + parseInt(limit) - 1);

    if (error) {
      console.error('Error obteniendo usuarios:', error);
      return res.status(500).json({ error: 'Error obteniendo usuarios' });
    }

    res.json({
      users: users || [],
      total: users?.length || 0,
      limit: parseInt(limit),
      offset: parseInt(offset),
      platform
    });
    
  } catch (error) {
    console.error('Error en users endpoint:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// =============================================
// ENDPOINTS DE CONTENIDO DE INSTAGRAM
// =============================================

// Endpoint para crear post de Instagram con IA
app.post('/api/create-post', upload.fields([
  { name: 'reference_image', maxCount: 1 }
]), async (req, res) => {
  try {
    const { topic, style = 'professional', target_audience = 'job_seekers' } = req.body;
    const files = req.files;
    
    if (!topic) {
      return res.status(400).json({ error: 'Topic es requerido para generar el post' });
    }

    console.log('🎨 Generando post de Instagram con IA...', { topic, style, target_audience });

    // Generar contenido del post con IA
    const contentPrompt = `Crea un post de Instagram para Magneto Empleos sobre: "${topic}"

REQUISITOS:
- Estilo: ${style}
- Audiencia: ${target_audience}
- Formato optimizado para Instagram
- Usa emojis relevantes
- Incluye hashtags estratégicos
- Máximo 2200 caracteres
- Tono profesional pero cercano
- Incluye call-to-action

FORMATO:
- Título atractivo
- Contenido estructurado con puntos clave
- Hashtags al final
- Emojis estratégicos

RESPUESTA SOLO EL CONTENIDO DEL POST, sin explicaciones adicionales.`;

    const aiContent = await generateAIContent(contentPrompt);
    
    if (!aiContent) {
      return res.status(500).json({ error: 'No se pudo generar el contenido' });
    }
    
    console.log('📝 Contenido generado:', aiContent.substring(0, 100) + '...');

    // Generar imagen con IA
    const imagePrompt = `Create an illustrative, cartoon-style Instagram post image for Magneto Empleos about: "${topic}"

STYLE: ${style}
AUDIENCE: ${target_audience}

DESIGN REQUIREMENTS:
- High quality, professional illustration
- Instagram post dimensions (1080x1080px - square)
- Cartoon/caricature style with friendly characters
- Clean, modern layout with balanced composition
- Brand colors: blue (#4A90E2), white (#FFFFFF), orange (#FF6B6B)
- Illustrative and engaging visual style

TEXT TO INCLUDE IN IMAGE:
- Main title: Based on the topic "${topic}" - create an appropriate title (in white, large and visible)
- Subtitle: "${topic}" (in blue, medium size)
- Call to action: Create an appropriate call to action based on the content (in orange, highlighted)
- Minimal but effective text
- Professional, readable fonts

BRANDING REQUIREMENTS (MANDATORY):
- Watermark: "MAGNETO EMPLEOS" (in small, elegant font, bottom right corner)
- Instagram handle: "@magneto_empleos" (in small font, bottom left corner)
- Both branding elements should be subtle but visible
- Use brand colors for branding elements

VISUAL ELEMENTS:
- Cartoon characters and caricatures
- Illustrative tech/programming elements
- Friendly, approachable character designs
- Modern professional graphics with personality
- Clean and engaging design
- Attractive to developers and tech professionals
- Illustrations that complement the text
- Well-distributed spaces with character interactions

STYLE REQUIRED:
- Illustrative cartoon style
- Friendly, approachable characters
- Professional but fun composition
- Well-distributed brand colors
- Visual elements that support the message
- Style that attracts tech professionals
- Complete image ready to publish
- Character-driven storytelling

${files?.reference_image?.[0] ? 'Use the reference image as inspiration for style and composition.' : ''}`;

    const referenceImage = files?.reference_image?.[0];
    const imageUrl = await generateImageWithGemini(imagePrompt, referenceImage);
    
    if (!imageUrl) {
      console.error('❌ No se pudo generar imagen con IA');
      return res.status(500).json({ 
        error: 'No se pudo generar la imagen con IA. Por favor, inténtalo de nuevo.' 
      });
    }

    console.log('🖼️ Imagen generada:', imageUrl);

    // Publicar en Instagram usando Graph API
    console.log('📱 Publicando post en Instagram...');
    const publishResult = await publishInstagramPost(imageUrl, aiContent);
    
    let postData = {
      image_url: imageUrl,
      caption: aiContent,
      ai_generated: true,
      ai_prompt: `Content: ${contentPrompt}\nImage: ${imagePrompt}`,
      status: publishResult.success ? 'published' : 'created',
      created_at: new Date().toISOString(),
      created_by: 'ai_system'
    };

    // Agregar datos de Instagram si se publicó exitosamente
    if (publishResult.success) {
      postData.instagram_post_id = publishResult.post_id;
      postData.media_id = publishResult.media_id;
      postData.published_at = new Date().toISOString();
      console.log('✅ Post publicado en Instagram:', publishResult.post_id);
    } else {
      console.log('⚠️ No se pudo publicar en Instagram:', publishResult.error);
    }

    // Guardar en base de datos
    const { data: savedPost, error } = await supabase
      .from('instagram_posts')
      .insert([postData])
      .select()
      .single();

    if (error) {
      console.error('Error guardando post:', error);
      return res.status(500).json({ error: 'Error guardando post' });
    }

    console.log('✅ Post guardado exitosamente:', savedPost.id);

    res.json({
      success: true,
      message: publishResult.success ? 'Post generado y publicado exitosamente en Instagram' : 'Post generado exitosamente (no se pudo publicar en Instagram)',
      post: {
        id: savedPost.id,
        caption: savedPost.caption,
        image_url: savedPost.image_url,
        ai_generated: savedPost.ai_generated,
        status: savedPost.status,
        instagram_post_id: savedPost.instagram_post_id,
        created_at: savedPost.created_at,
        published_at: savedPost.published_at
      },
      instagram_publish: publishResult
    });
    
  } catch (error) {
    console.error('Error en create-post:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint para crear story de Instagram con IA
app.post('/api/create-story', upload.fields([
  { name: 'reference_image', maxCount: 1 }
]), async (req, res) => {
  try {
    const { topic, style = 'dynamic', target_audience = 'job_seekers' } = req.body;
    const files = req.files;
    
    if (!topic) {
      return res.status(400).json({ error: 'Topic es requerido para generar la story' });
    }

    console.log('📱 Generando story de Instagram con IA...', { topic, style, target_audience });

    // Generar imagen para story con IA
    const imagePrompt = `Create an illustrative, cartoon-style Instagram Story image for Magneto Empleos about: "${topic}"

STYLE: ${style}
AUDIENCE: ${target_audience}

DESIGN REQUIREMENTS:
- High quality, professional illustration
- Instagram Story dimensions (1080x1920px - vertical)
- Cartoon/caricature style with friendly characters
- Clean, modern layout with balanced composition
- Brand colors: blue (#4A90E2), white (#FFFFFF), orange (#FF6B6B)
- Illustrative and engaging visual style

TEXT TO INCLUDE IN IMAGE:
- Main title: Based on the topic "${topic}" - create an appropriate title (in white, large and visible)
- Subtitle: "${topic}" (in blue, medium size)
- Call to action: Create an appropriate call to action based on the content (in orange, highlighted)
- Minimal but effective text
- Professional, readable fonts

BRANDING REQUIREMENTS (MANDATORY):
- Watermark: "MAGNETO EMPLEOS" (in small, elegant font, bottom right corner)
- Instagram handle: "@magneto_empleos" (in small font, bottom left corner)
- Both branding elements should be subtle but visible
- Use brand colors for branding elements

VISUAL ELEMENTS:
- Cartoon characters and caricatures
- Illustrative tech/programming elements
- Friendly, approachable character designs
- Modern professional graphics with personality
- Clean and engaging design
- Attractive to developers and tech professionals
- Illustrations that complement the text
- Well-distributed spaces with character interactions

STYLE REQUIRED:
- Illustrative cartoon style
- Friendly, approachable characters
- Professional but fun composition
- Well-distributed brand colors
- Visual elements that support the message
- Style that attracts tech professionals
- Complete image ready to publish
- Character-driven storytelling

${files?.reference_image?.[0] ? 'Use the reference image as inspiration for style and composition.' : ''}`;

    const referenceImage = files?.reference_image?.[0];
    const imageUrl = await generateImageWithGemini(imagePrompt, referenceImage);
    
    if (!imageUrl) {
      return res.status(500).json({ error: 'No se pudo generar la imagen' });
    }

    console.log('🖼️ Imagen de story generada:', imageUrl);

    // Publicar story en Instagram usando Graph API
    console.log('📱 Publicando story en Instagram...');
    const publishResult = await publishInstagramStory(imageUrl);
    
    let storyData = {
      image_url: imageUrl,
      ai_generated: true,
      ai_prompt: imagePrompt,
      status: publishResult.success ? 'published' : 'created',
      created_at: new Date().toISOString(),
      created_by: 'ai_system'
    };

    // Agregar datos de Instagram si se publicó exitosamente
    if (publishResult.success) {
      storyData.media_id = publishResult.media_id;
      storyData.container_id = publishResult.media_id;
      storyData.published_at = new Date().toISOString();
    }

    // Guardar en base de datos
    const { data: savedStory, error } = await supabase
      .from('instagram_stories')
      .insert([storyData])
      .select()
      .single();

    if (error) {
      console.error('Error guardando story:', error);
      return res.status(500).json({ error: 'Error guardando story' });
    }

    console.log('✅ Story creada exitosamente:', savedStory.id);

    res.json({
      success: true,
      message: publishResult.success ? 'Story publicada exitosamente en Instagram' : 'Story creada exitosamente (no publicada)',
      story: {
        id: savedStory.id,
        image_url: savedStory.image_url,
        ai_generated: savedStory.ai_generated,
        status: savedStory.status,
        media_id: savedStory.media_id,
        created_at: savedStory.created_at,
        published_at: savedStory.published_at
      },
      instagram: publishResult.success ? {
        media_id: publishResult.media_id,
        story_id: publishResult.story_id
      } : null
    });
    
  } catch (error) {
    console.error('Error en create-story:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint para obtener posts
app.get('/api/posts', async (req, res) => {
  try {
    const { limit = 20, offset = 0, status = 'created' } = req.query;
    
    const { data: posts, error } = await supabase
      .from('instagram_posts')
      .select('*')
      .eq('status', status)
      .order('created_at', { ascending: false })
      .range(offset, offset + parseInt(limit) - 1);

    if (error) {
      console.error('Error obteniendo posts:', error);
      return res.status(500).json({ error: 'Error obteniendo posts' });
    }

    res.json({
      posts: posts || [],
      total: posts?.length || 0,
      limit: parseInt(limit),
      offset: parseInt(offset)
    });
    
  } catch (error) {
    console.error('Error en posts endpoint:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint para obtener stories
app.get('/api/stories', async (req, res) => {
  try {
    const { limit = 20, offset = 0, status = 'created' } = req.query;
    
    const { data: stories, error } = await supabase
      .from('instagram_stories')
      .select('*')
      .eq('status', status)
      .order('created_at', { ascending: false })
      .range(offset, offset + parseInt(limit) - 1);

    if (error) {
      console.error('Error obteniendo stories:', error);
      return res.status(500).json({ error: 'Error obteniendo stories' });
    }

    res.json({
      stories: stories || [],
      total: stories?.length || 0,
      limit: parseInt(limit),
      offset: parseInt(offset)
    });
    
  } catch (error) {
    console.error('Error en stories endpoint:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint para estadísticas de contenido
app.get('/api/content/stats', async (req, res) => {
  try {
    const { data: postStats, error: postError } = await supabase
      .from('instagram_posts')
      .select('status, ai_generated, created_at');

    const { data: storyStats, error: storyError } = await supabase
      .from('instagram_stories')
      .select('status, ai_generated, created_at');

    if (postError || storyError) {
      console.error('Error obteniendo estadísticas de contenido:', postError || storyError);
      return res.status(500).json({ error: 'Error obteniendo estadísticas' });
    }

    // Procesar estadísticas
    const stats = {
      posts: {
        total: postStats?.length || 0,
        by_status: {},
        ai_generated: 0
      },
      stories: {
        total: storyStats?.length || 0,
        by_status: {},
        ai_generated: 0
      }
    };

    postStats?.forEach(post => {
      if (!stats.posts.by_status[post.status]) {
        stats.posts.by_status[post.status] = 0;
      }
      stats.posts.by_status[post.status]++;
      
      if (post.ai_generated) {
        stats.posts.ai_generated++;
      }
    });

    storyStats?.forEach(story => {
      if (!stats.stories.by_status[story.status]) {
        stats.stories.by_status[story.status] = 0;
      }
      stats.stories.by_status[story.status]++;
      
      if (story.ai_generated) {
        stats.stories.ai_generated++;
      }
    });

    res.json({
      ...stats,
      total_content: stats.posts.total + stats.stories.total,
      timestamp: new Date().toISOString()
    });
    
  } catch (error) {
    console.error('Error en content/stats:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// =============================================
// ENDPOINTS DE UTILIDADES
// =============================================

// Endpoint para actualizar usernames faltantes
app.post('/api/update-usernames', async (req, res) => {
  try {
    const { data: conversations, error } = await supabase
      .from('conversaciones')
      .select('id, user_id, username')
      .is('username', null)
      .eq('platform', 'instagram');

    if (error) {
      console.error('Error obteniendo conversaciones:', error);
      return res.status(500).json({ error: 'Error obteniendo conversaciones' });
    }

    const results = [];
    
    for (const conversation of conversations || []) {
      try {
        const username = await getInstagramUsername(conversation.user_id);
        
        if (username) {
          const { error: updateError } = await supabase
            .from('conversaciones')
            .update({ 
              username: username,
              updated_at: new Date().toISOString()
            })
            .eq('id', conversation.id);
          
          if (updateError) {
            console.error('Error actualizando username:', updateError);
            results.push({ 
              conversation_id: conversation.id, 
              user_id: conversation.user_id, 
              success: false, 
              error: updateError.message 
            });
          } else {
            results.push({ 
              conversation_id: conversation.id, 
              user_id: conversation.user_id, 
              success: true, 
              username: username 
            });
          }
        } else {
          results.push({ 
            conversation_id: conversation.id, 
            user_id: conversation.user_id, 
            success: false, 
            error: 'No se pudo obtener username' 
          });
        }
      } catch (error) {
        console.error('Error procesando conversación:', error);
        results.push({ 
          conversation_id: conversation.id, 
          user_id: conversation.user_id, 
          success: false, 
          error: error.message 
        });
      }
    }

    res.json({
      success: true,
      message: 'Proceso de actualización completado',
      results: results,
      total_processed: results.length,
      successful: results.filter(r => r.success).length,
      failed: results.filter(r => !r.success).length
    });
    
  } catch (error) {
    console.error('Error en update-usernames:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint para limpiar conversaciones duplicadas
app.post('/api/cleanup-duplicate-conversations', async (req, res) => {
  try {
    const { data: conversations, error } = await supabase
      .from('conversaciones')
      .select('*')
      .eq('platform', 'instagram')
      .eq('conversation_type', 'dm')
      .order('created_at', { ascending: true });

    if (error) {
      console.error('Error obteniendo conversaciones:', error);
      return res.status(500).json({ error: 'Error obteniendo conversaciones' });
    }

    const duplicates = {};
    const results = [];

    // Agrupar por external_conversation_id
    conversations?.forEach(conv => {
      if (!duplicates[conv.external_conversation_id]) {
        duplicates[conv.external_conversation_id] = [];
      }
      duplicates[conv.external_conversation_id].push(conv);
    });

    // Procesar duplicados
    for (const [conversationId, convs] of Object.entries(duplicates)) {
      if (convs.length > 1) {
        // Ordenar por fecha de creación (más antigua primero)
        convs.sort((a, b) => new Date(a.created_at) - new Date(b.created_at));
        
        const keepConversation = convs[0]; // Mantener la más antigua
        const deleteConversations = convs.slice(1); // Eliminar las demás

        // Mover mensajes de conversaciones duplicadas a la principal
        for (const deleteConv of deleteConversations) {
          const { data: messages, error: msgError } = await supabase
            .from('mensajes')
            .select('*')
            .eq('conversacion_id', deleteConv.id);

          if (!msgError && messages) {
            // Actualizar mensajes para que apunten a la conversación principal
            for (const message of messages) {
              await supabase
                .from('mensajes')
                .update({ conversacion_id: keepConversation.id })
                .eq('id', message.id);
            }
          }

          // Eliminar conversación duplicada
          await supabase
            .from('conversaciones')
            .delete()
            .eq('id', deleteConv.id);

          results.push({
            kept_conversation: keepConversation.id,
            deleted_conversation: deleteConv.id,
            messages_moved: messages?.length || 0
          });
        }
      }
    }

    res.json({
      success: true,
      message: 'Limpieza de conversaciones duplicadas completada',
      results: results,
      total_processed: Object.keys(duplicates).length,
      duplicates_found: results.length
    });
    
  } catch (error) {
    console.error('Error en cleanup-duplicate-conversations:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint para limpiar mensajes duplicados de IA
app.post('/api/cleanup-duplicate-messages', async (req, res) => {
  try {
    const { data: messages, error } = await supabase
      .from('mensajes')
      .select('*')
      .eq('is_ai_generated', true)
      .order('created_at', { ascending: true });

    if (error) {
      console.error('Error obteniendo mensajes:', error);
      return res.status(500).json({ error: 'Error obteniendo mensajes' });
    }

    const duplicates = {};
    const results = [];

    // Agrupar por conversación y contenido
    messages?.forEach(msg => {
      const key = `${msg.conversacion_id}_${msg.content}`;
      if (!duplicates[key]) {
        duplicates[key] = [];
      }
      duplicates[key].push(msg);
    });

    // Procesar duplicados
    for (const [key, msgs] of Object.entries(duplicates)) {
      if (msgs.length > 1) {
        // Mantener el primero, eliminar los demás
        const keepMessage = msgs[0];
        const deleteMessages = msgs.slice(1);

        for (const deleteMsg of deleteMessages) {
          await supabase
            .from('mensajes')
            .delete()
            .eq('id', deleteMsg.id);

          results.push({
            kept_message: keepMessage.id,
            deleted_message: deleteMsg.id,
            conversation_id: deleteMsg.conversacion_id
          });
        }
      }
    }

    res.json({
      success: true,
      message: 'Limpieza de mensajes duplicados completada',
      results: results,
      total_processed: Object.keys(duplicates).length,
      duplicates_found: results.length
    });
    
  } catch (error) {
    console.error('Error en cleanup-duplicate-messages:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint para limpiar conversaciones manuales duplicadas
app.post('/api/cleanup-manual-conversations', async (req, res) => {
  try {
    const { data: conversations, error } = await supabase
      .from('conversaciones')
      .select('*')
      .eq('platform', 'instagram')
      .eq('conversation_type', 'dm')
      .like('external_conversation_id', 'manual_dm_%')
      .order('created_at', { ascending: true });

    if (error) {
      console.error('Error obteniendo conversaciones manuales:', error);
      return res.status(500).json({ error: 'Error obteniendo conversaciones' });
    }

    const duplicates = {};
    const results = [];

    // Agrupar por user_id
    conversations?.forEach(conv => {
      if (!duplicates[conv.user_id]) {
        duplicates[conv.user_id] = [];
      }
      duplicates[conv.user_id].push(conv);
    });

    // Procesar duplicados
    for (const [userId, convs] of Object.entries(duplicates)) {
      if (convs.length > 1) {
        // Buscar conversación normal del usuario
        const { data: normalConv, error: normalError } = await supabase
          .from('conversaciones')
          .select('*')
          .eq('user_id', userId)
          .eq('platform', 'instagram')
          .eq('conversation_type', 'dm')
          .not('external_conversation_id', 'like', 'manual_dm_%')
          .single();

        if (!normalError && normalConv) {
          // Mover mensajes de conversaciones manuales a la normal
          for (const manualConv of convs) {
            const { data: messages, error: msgError } = await supabase
              .from('mensajes')
              .select('*')
              .eq('conversacion_id', manualConv.id);

            if (!msgError && messages) {
              for (const message of messages) {
                await supabase
                  .from('mensajes')
                  .update({ conversacion_id: normalConv.id })
                  .eq('id', message.id);
              }
            }

            // Eliminar conversación manual
            await supabase
              .from('conversaciones')
              .delete()
              .eq('id', manualConv.id);

            results.push({
              user_id: userId,
              normal_conversation: normalConv.id,
              deleted_manual_conversation: manualConv.id,
              messages_moved: messages?.length || 0
            });
          }
        }
      }
    }

    res.json({
      success: true,
      message: 'Limpieza de conversaciones manuales duplicadas completada',
      results: results,
      total_processed: Object.keys(duplicates).length,
      duplicates_found: results.length
    });
    
  } catch (error) {
    console.error('Error en cleanup-manual-conversations:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint para limpiar comentarios del bot
app.post('/api/cleanup-bot-comments', async (req, res) => {
  try {
    console.log('Limpiando comentarios del bot...');
    
    // Obtener conversaciones del bot
    const { data: botConversations, error: botError } = await supabase
      .from('conversaciones')
      .select('id, external_conversation_id, user_id, username')
      .eq('user_id', '17841477544945260')
      .eq('platform', 'instagram')
      .in('conversation_type', ['comment', 'mention']);
    
    if (botError) {
      console.error('Error obteniendo conversaciones del bot:', botError);
      return res.status(500).json({ error: 'Error obteniendo conversaciones del bot' });
    }
    
    let conversationsDeleted = 0;
    let messagesDeleted = 0;
    
    for (const botConv of botConversations) {
      console.log(`Eliminando conversación del bot: ${botConv.external_conversation_id}`);
      
      // Eliminar mensajes primero
      const { error: deleteMsgsError } = await supabase
        .from('mensajes')
        .delete()
        .eq('conversacion_id', botConv.id);
      
      if (deleteMsgsError) {
        console.error('Error eliminando mensajes:', deleteMsgsError);
      } else {
        messagesDeleted++;
      }
      
      // Eliminar conversación
      const { error: deleteConvError } = await supabase
        .from('conversaciones')
        .delete()
        .eq('id', botConv.id);
      
      if (deleteConvError) {
        console.error('Error eliminando conversación:', deleteConvError);
      } else {
        conversationsDeleted++;
      }
    }
    
    res.json({
      success: true,
      message: 'Limpieza de comentarios del bot completada',
      conversationsDeleted,
      messagesDeleted,
      totalFound: botConversations.length
    });
    
  } catch (error) {
    console.error('Error en cleanup-bot-comments:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint para limpiar todos los duplicados
app.post('/api/cleanup-all-duplicates', async (req, res) => {
  try {
    const results = {
      conversations: null,
      messages: null,
      manual_conversations: null,
      bot_comments: null
    };

    // Limpiar conversaciones duplicadas
    try {
      const convResponse = await fetch(`${req.protocol}://${req.get('host')}/api/cleanup-duplicate-conversations`, {
        method: 'POST'
      });
      results.conversations = await convResponse.json();
    } catch (error) {
      results.conversations = { error: error.message };
    }

    // Limpiar mensajes duplicados
    try {
      const msgResponse = await fetch(`${req.protocol}://${req.get('host')}/api/cleanup-duplicate-messages`, {
        method: 'POST'
      });
      results.messages = await msgResponse.json();
    } catch (error) {
      results.messages = { error: error.message };
    }

    // Limpiar conversaciones manuales duplicadas
    try {
      const manualResponse = await fetch(`${req.protocol}://${req.get('host')}/api/cleanup-manual-conversations`, {
        method: 'POST'
      });
      results.manual_conversations = await manualResponse.json();
    } catch (error) {
      results.manual_conversations = { error: error.message };
    }

    // Limpiar comentarios del bot
    try {
      const botResponse = await fetch(`${req.protocol}://${req.get('host')}/api/cleanup-bot-comments`, {
        method: 'POST'
      });
      results.bot_comments = await botResponse.json();
    } catch (error) {
      results.bot_comments = { error: error.message };
    }

    res.json({
      success: true,
      message: 'Limpieza completa de duplicados completada',
      results: results,
      timestamp: new Date().toISOString()
    });
    
  } catch (error) {
    console.error('Error en cleanup-all-duplicates:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint para probar formato de Instagram
app.post('/api/test-instagram-format', (req, res) => {
  try {
    const { text } = req.body;
    
    if (!text) {
      return res.status(400).json({ error: 'text es requerido' });
    }

    const formattedText = convertToInstagramFormat(text);
    
    res.json({
      original: text,
      formatted: formattedText,
      changed: text !== formattedText
    });
    
  } catch (error) {
    console.error('Error en test-instagram-format:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// Endpoint para probar conexión con Supabase
app.get('/api/test-supabase', async (req, res) => {
  try {
    const { data, error } = await supabase
      .from('conversaciones')
      .select('count')
      .limit(1);

    if (error) {
      console.error('Error probando Supabase:', error);
      return res.status(500).json({ 
        error: 'Error conectando con Supabase', 
        details: error.message 
      });
    }

    res.json({
      success: true,
      message: 'Conexión con Supabase exitosa',
      timestamp: new Date().toISOString()
    });
    
  } catch (error) {
    console.error('Error en test-supabase:', error);
    res.status(500).json({ 
      error: 'Error interno del servidor', 
      details: error.message 
    });
  }
});

// ==================== APIs PARA POSTS Y COMENTARIOS DE INSTAGRAM ====================

// Obtener todos los posts de Instagram con paginación
app.get('/api/instagram/posts', async (req, res) => {
  try {
    const { page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;

    console.log('📱 Obteniendo posts de Instagram con parámetros:', {
      page: parseInt(page),
      limit: parseInt(limit),
      offset: parseInt(offset)
    });

    const posts = await getAllInstagramPosts(parseInt(limit), parseInt(offset));

    console.log('📊 Posts obtenidos:', {
      total_posts: posts.length,
      posts: posts.map(post => ({
        id: post.id,
        instagram_post_id: post.instagram_post_id,
        caption: post.caption ? post.caption.substring(0, 50) + '...' : 'Sin caption',
        media_type: post.media_type,
        media_url: post.media_url ? 'Presente' : 'Ausente',
        created_at: post.created_at
      }))
    });

    const response = {
      success: true,
      data: posts,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: posts.length
      }
    };

    console.log('✅ Respuesta de /api/instagram/posts:', {
      success: response.success,
      total_posts: response.data.length,
      pagination: response.pagination
    });

    res.json(response);
  } catch (error) {
    console.error('❌ Error obteniendo posts:', error);
    res.status(500).json({ 
      success: false, 
      error: 'Error interno del servidor',
      details: error.message 
    });
  }
});

// Obtener un post específico por ID
app.get('/api/instagram/posts/:postId', async (req, res) => {
  try {
    const { postId } = req.params;

    const { data: post, error } = await supabase
      .from('instagram_posts')
      .select('*')
      .eq('id', postId)
      .single();

    if (error || !post) {
      return res.status(404).json({ 
        success: false, 
        error: 'Post no encontrado' 
      });
    }

    res.json({
      success: true,
      data: post
    });
  } catch (error) {
    console.error('Error obteniendo post:', error);
    res.status(500).json({ 
      success: false, 
      error: 'Error interno del servidor',
      details: error.message 
    });
  }
});

// Obtener comentarios de un post específico
app.get('/api/instagram/posts/:postId/comments', async (req, res) => {
  try {
    const { postId } = req.params;
    const { includeReplies = true } = req.query;

    const comments = await getPostComments(postId, includeReplies === 'true');

    res.json({
      success: true,
      data: comments,
      count: comments.length
    });
  } catch (error) {
    console.error('Error obteniendo comentarios:', error);
    res.status(500).json({ 
      success: false, 
      error: 'Error interno del servidor',
      details: error.message 
    });
  }
});

// Obtener estadísticas de un post
app.get('/api/instagram/posts/:postId/stats', async (req, res) => {
  try {
    const { postId } = req.params;

    const { data: stats, error } = await supabase
      .from('instagram_comments')
      .select('is_ai_response')
      .eq('post_id', postId);

    if (error) {
      throw error;
    }

    const totalComments = stats.length;
    const aiResponses = stats.filter(s => s.is_ai_response).length;
    const userComments = totalComments - aiResponses;

    res.json({
      success: true,
      data: {
        total_comments: totalComments,
        user_comments: userComments,
        ai_responses: aiResponses,
        response_rate: totalComments > 0 ? (aiResponses / userComments * 100).toFixed(2) : 0
      }
    });
  } catch (error) {
    console.error('Error obteniendo estadísticas:', error);
    res.status(500).json({ 
      success: false, 
      error: 'Error interno del servidor',
      details: error.message 
    });
  }
});

// Buscar posts por texto en caption
app.get('/api/instagram/posts/search', async (req, res) => {
  try {
    const { q, page = 1, limit = 20 } = req.query;
    
    if (!q) {
      return res.status(400).json({ 
        success: false, 
        error: 'Parámetro de búsqueda requerido' 
      });
    }

    const offset = (page - 1) * limit;

    const { data: posts, error } = await supabase
      .from('instagram_posts')
      .select('*')
      .ilike('caption', `%${q}%`)
      .order('created_at', { ascending: false })
      .range(offset, offset + parseInt(limit) - 1);

    if (error) {
      throw error;
    }

    res.json({
      success: true,
      data: posts,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: posts.length
      }
    });
  } catch (error) {
    console.error('Error buscando posts:', error);
    res.status(500).json({ 
      success: false, 
      error: 'Error interno del servidor',
      details: error.message 
    });
  }
});

// Endpoint de estadísticas con análisis de IA
app.get('/api/analytics/ai-insights', async (req, res) => {
  try {
    console.log('📊 Generando estadísticas con análisis de IA...');
    
    // Obtener estadísticas de posts
    const postsData = await getPostsAnalytics();
    
    // Obtener estadísticas de DMs
    const dmData = await getDMAnalytics();
    
    // Generar análisis de IA
    const aiAnalysis = await generateAIAnalytics(postsData, dmData);
    
    // Preparar respuesta completa
    const analytics = {
      timestamp: new Date().toISOString(),
      dataRange: {
        postsAnalyzed: postsData?.totalPosts || 0,
        conversationsAnalyzed: dmData?.totalConversations || 0,
        period: 'Últimos 50 posts y 100 conversaciones'
      },
      posts: {
        summary: {
          totalPosts: postsData?.totalPosts || 0,
          aiGeneratedPosts: postsData?.aiGeneratedPosts || 0,
          manualPosts: postsData?.manualPosts || 0,
          totalComments: postsData?.totalComments || 0,
          avgEngagement: postsData?.avgEngagement || 0,
          aiResponses: postsData?.aiResponses || 0,
          userComments: postsData?.userComments || 0
        },
        topSectors: postsData?.topSectors || [],
        topPositions: postsData?.topPositions || [],
        recentPosts: postsData?.posts?.slice(0, 10) || []
      },
      conversations: {
        summary: {
          totalConversations: dmData?.totalConversations || 0,
          activeConversations: dmData?.activeConversations || 0,
          avgCompletion: dmData?.avgCompletion || 0,
          messageStats: dmData?.messageStats || {}
        },
        topProfessions: dmData?.topProfessions || [],
        topLocations: dmData?.topLocations || [],
        experienceDistribution: dmData?.experienceDistribution || []
      },
      aiInsights: aiAnalysis || {
        error: 'No se pudo generar análisis de IA',
        fallback: 'Datos disponibles pero análisis de IA no disponible'
      }
    };

    console.log('✅ Estadísticas generadas exitosamente:', {
      posts: analytics.posts.summary.totalPosts,
      conversations: analytics.conversations.summary.totalConversations,
      aiAnalysis: !!analytics.aiInsights
    });

    res.json({
      success: true,
      message: 'Estadísticas con análisis de IA generadas exitosamente',
      analytics
    });
    
  } catch (error) {
    console.error('❌ Error generando estadísticas:', error);
    res.status(500).json({ 
      success: false,
      error: 'Error generando estadísticas con análisis de IA',
      details: error.message 
    });
  }
});

// Endpoint de estadísticas básicas (sin IA)
app.get('/api/analytics/basic', async (req, res) => {
  try {
    console.log('📊 Generando estadísticas básicas...');
    
    const postsData = await getPostsAnalytics();
    const dmData = await getDMAnalytics();
    
    res.json({
      success: true,
      message: 'Estadísticas básicas generadas exitosamente',
      data: {
        posts: postsData,
        conversations: dmData,
        timestamp: new Date().toISOString()
      }
    });
    
  } catch (error) {
    console.error('❌ Error generando estadísticas básicas:', error);
    res.status(500).json({ 
      success: false,
      error: 'Error generando estadísticas básicas',
      details: error.message 
    });
  }
});

// Endpoint de prueba para generar video
app.post('/api/test-video-generation', async (req, res) => {
  try {
    console.log('🎬 Test video generation - Body recibido:', req.body);
    
    const { 
      prompt = "Consejos para entrevistas técnicas", 
      accent = 'neutral',
      style = 'realista',
      duration = 8
    } = req.body || {};

    console.log('🎬 Probando generación de video...', { prompt, accent, style, duration });

    // Generar video con IA
    const videoUrl = await generateVideo(prompt, accent, style, duration);
    
    if (!videoUrl) {
      return res.status(500).json({ 
        success: false,
        error: 'Error generando video',
        message: 'La función generateVideoWithGemini retornó null'
      });
    }

    res.json({
      success: true,
      message: 'Video generado exitosamente',
      video_url: videoUrl,
      prompt: prompt,
      accent: accent,
      style: style,
      duration: duration
    });

  } catch (error) {
    console.error('❌ Error en test video generation:', error);
    res.status(500).json({ 
      success: false,
      error: 'Error en test video generation',
      details: error.message,
      stack: error.stack
    });
  }
});

// Endpoint para generar preview de reel
app.post('/api/preview/reel', async (req, res) => {
  try {
    console.log('🎬 Preview reel - Body recibido:', req.body);
    
    const { 
      prompt, 
      accent = 'neutral',
      style = 'realista',
      duration = 8,
      target_audience = 'desarrolladores y profesionales tech'
    } = req.body || {};

    if (!prompt) {
      return res.status(400).json({ error: 'Prompt es requerido' });
    }

    console.log('🎬 Generando preview de reel...', { prompt, accent, style, duration });

            // Generar preview completo de reel (video + captions + sugerencias) en una sola operación
            const previewData = await generateCompleteReelPreview(prompt, accent, style, duration, target_audience);
            
            if (!previewData) {
              return res.status(500).json({ error: 'Error generando preview completo de reel' });
            }

            // Verificar si hay error en la generación del video
            if (previewData.error) {
              return res.status(500).json({ 
                error: 'Error generando video',
                details: previewData.error,
                suggestion: 'Intenta nuevamente en unos minutos o contacta soporte si el problema persiste'
              });
            }

            const { videoUrl, captionOptions, improveSuggestions } = previewData;
    
    // Guardar preview en la base de datos
    const { data: preview, error: insertError } = await supabase
      .from('instagram_previews')
      .insert({
        type: 'reel',
        topic: prompt,
        style: style,
        target_audience: target_audience,
        image_url: videoUrl, // Reutilizamos el campo para videos
        suggested_caption: captionOptions,
        improve_suggestions: improveSuggestions,
        status: 'draft',
        created_by: 'user'
      })
      .select()
      .single();

    if (insertError) {
      console.error('❌ Error guardando preview:', insertError);
      return res.status(500).json({ error: 'Error guardando preview' });
    }

    console.log('✅ Preview de reel generado exitosamente:', preview.id);

    res.json({
      success: true,
      message: 'Preview de reel generado exitosamente',
      preview: {
        id: preview.id,
        type: 'reel',
        video_url: videoUrl,
        suggested_caption: captionOptions,
        improve_suggestions: improveSuggestions,
        topic: prompt,
        style: style,
        accent: accent,
        duration: duration,
        target_audience: target_audience,
        status: 'draft',
        created_at: preview.created_at
      }
    });

  } catch (error) {
    console.error('❌ Error generando preview de reel:', error);
    res.status(500).json({ 
      success: false,
      error: 'Error generando preview de reel',
      details: error.message 
    });
  }
});

// Endpoint para regenerar reel con nuevo prompt
app.post('/api/preview/reel/:id/regenerate', async (req, res) => {
  try {
    const { id } = req.params;
    const { prompt, accent = 'neutral', style = 'realista', duration = 8 } = req.body;

    if (!prompt) {
      return res.status(400).json({ error: 'Prompt es requerido' });
    }

    console.log('🔄 Regenerando reel...', { id, prompt, accent, style, duration });

    // Obtener preview existente
    const { data: preview, error: previewError } = await supabase
      .from('instagram_previews')
      .select('*')
      .eq('id', id)
      .eq('type', 'reel')
      .single();

    if (previewError || !preview) {
      return res.status(404).json({ error: 'Preview de reel no encontrado' });
    }

    // Generar nuevo preview completo de reel
    const previewData = await generateCompleteReelPreview(prompt, accent, style, duration, preview.target_audience);
    
    if (!previewData) {
      return res.status(500).json({ error: 'Error generando nuevo preview completo de reel' });
    }

    const { videoUrl, captionOptions, improveSuggestions } = previewData;

    // Actualizar preview
    const { data: updatedPreview, error: updateError } = await supabase
      .from('instagram_previews')
      .update({
        topic: prompt,
        style: style,
        image_url: videoUrl,
        suggested_caption: captionOptions,
        improve_suggestions: improveSuggestions,
        updated_at: new Date().toISOString()
      })
      .eq('id', id)
      .select()
      .single();

    if (updateError) {
      console.error('❌ Error actualizando preview:', updateError);
      return res.status(500).json({ error: 'Error actualizando preview' });
    }

    console.log('✅ Reel regenerado exitosamente:', updatedPreview.id);

    res.json({
      success: true,
      message: 'Reel regenerado exitosamente',
      preview: {
        id: updatedPreview.id,
        type: 'reel',
        video_url: videoUrl,
        suggested_caption: captionOptions,
        improve_suggestions: improveSuggestions,
        topic: prompt,
        style: style,
        accent: accent,
        duration: duration,
        target_audience: updatedPreview.target_audience,
        status: updatedPreview.status,
        updated_at: updatedPreview.updated_at
      }
    });

  } catch (error) {
    console.error('❌ Error regenerando reel:', error);
    res.status(500).json({ 
      success: false,
      error: 'Error regenerando reel',
      details: error.message 
    });
  }
});

// =============================================
// ENDPOINTS DE PREVIEW Y CORRECCIONES
// =============================================

// Endpoint para generar preview de post (sin publicar)
app.post('/api/preview/post', async (req, res) => {
  try {
    console.log('📝 Preview post - Body recibido:', req.body);
    console.log('📝 Preview post - Headers:', req.headers['content-type']);
    
    const { 
      topic, 
      style = 'moderno y profesional', 
      target_audience = 'desarrolladores y profesionales tech',
      reference_image = null 
    } = req.body || {};

    if (!topic) {
      return res.status(400).json({ error: 'Topic es requerido' });
    }

    console.log('🎨 Generando preview de post...', { topic, style, target_audience });

    // Generar preview completo (imagen + captions + sugerencias) en una sola operación
    const previewData = await generateCompletePreview(topic, style, target_audience, 'post', reference_image);
    
    if (!previewData) {
      return res.status(500).json({ error: 'Error generando preview completo' });
    }

    const { mediaUrl: imageUrl, captionOptions, improveSuggestions } = previewData;

    // Guardar preview en base de datos (sin publicar)
    const { data: previewRecord, error: previewError } = await supabase
      .from('instagram_previews')
      .insert({
        type: 'post',
        topic,
        style,
        target_audience,
        image_url: imageUrl,
        suggested_caption: captionOptions,
        improve_suggestions: improveSuggestions,
        status: 'draft',
        created_by: 'user'
      })
      .select()
      .single();

    if (previewError) {
      console.error('❌ Error guardando preview:', previewError);
      return res.status(500).json({ error: 'Error guardando preview' });
    }

    res.json({
      success: true,
      message: 'Preview de post generado exitosamente',
      preview: {
        id: previewRecord.id,
        type: 'post',
        image_url: imageUrl,
        suggested_caption: captionOptions,
        improve_suggestions: improveSuggestions,
        topic,
        style,
        target_audience,
        status: 'draft',
        created_at: previewData.created_at
      }
    });

  } catch (error) {
    console.error('❌ Error generando preview de post:', error);
    res.status(500).json({ 
      error: 'Error generando preview de post',
      details: error.message 
    });
  }
});

// Endpoint para generar preview de story (sin publicar)
app.post('/api/preview/story', async (req, res) => {
  try {
    console.log('📝 Preview story - Body recibido:', req.body);
    console.log('📝 Preview story - Headers:', req.headers['content-type']);
    
    const { 
      topic, 
      style = 'moderno y profesional', 
      target_audience = 'desarrolladores y profesionales tech',
      reference_image = null 
    } = req.body || {};

    if (!topic) {
      return res.status(400).json({ error: 'Topic es requerido' });
    }

    console.log('🎨 Generando preview de story...', { topic, style, target_audience });

    // Generar preview completo (imagen + captions + sugerencias) en una sola operación
    const previewData = await generateCompletePreview(topic, style, target_audience, 'story', reference_image);
    
    if (!previewData) {
      return res.status(500).json({ error: 'Error generando preview completo' });
    }

    const { mediaUrl: imageUrl, captionOptions, improveSuggestions } = previewData;

    // Guardar preview en base de datos (sin publicar)
    const { data: previewRecord, error: previewError } = await supabase
      .from('instagram_previews')
      .insert({
        type: 'story',
        topic,
        style,
        target_audience,
        image_url: imageUrl,
        suggested_caption: captionOptions,
        improve_suggestions: improveSuggestions,
        status: 'draft',
        created_by: 'user'
      })
      .select()
      .single();

    if (previewError) {
      console.error('❌ Error guardando preview:', previewError);
      return res.status(500).json({ error: 'Error guardando preview' });
    }

    res.json({
      success: true,
      message: 'Preview de story generado exitosamente',
      preview: {
        id: previewRecord.id,
        type: 'story',
        image_url: imageUrl,
        suggested_caption: captionOptions,
        improve_suggestions: improveSuggestions,
        topic,
        style,
        target_audience,
        status: 'draft',
        created_at: previewData.created_at
      }
    });

  } catch (error) {
    console.error('❌ Error generando preview de story:', error);
    res.status(500).json({ 
      error: 'Error generando preview de story',
      details: error.message 
    });
  }
});

// Endpoint para solicitar correcciones con IA
app.post('/api/preview/:id/corrections', async (req, res) => {
  try {
    const { id } = req.params;
    const { 
      corrections = [],
      visual_feedback = null,
      text_changes = null,
      style_changes = null 
    } = req.body;

    console.log('🔧 Procesando correcciones...', { id, corrections, visual_feedback });

    // Obtener preview actual
    const { data: preview, error: previewError } = await supabase
      .from('instagram_previews')
      .select('*')
      .eq('id', id)
      .single();

    if (previewError || !preview) {
      return res.status(404).json({ error: 'Preview no encontrado' });
    }

    // Generar prompt de corrección mejorado
    let correctionPrompt = `Analiza la imagen de referencia y modifícala sobre "${preview.topic}" aplicando los siguientes cambios específicos:\n\n`;
    
    if (corrections.length > 0) {
      correctionPrompt += `CORRECCIONES ESPECÍFICAS:\n${corrections.map((c, i) => `${i + 1}. ${c}`).join('\n')}\n\n`;
    }
    
    if (visual_feedback) {
      correctionPrompt += `CAMBIOS VISUALES DETALLADOS: ${visual_feedback}\n\n`;
    }
    
    if (text_changes) {
      correctionPrompt += `MODIFICACIONES DE TEXTO: ${text_changes}\n\n`;
    }
    
    if (style_changes) {
      correctionPrompt += `AJUSTES DE ESTILO: ${style_changes}\n\n`;
    }

    correctionPrompt += `INSTRUCCIONES IMPORTANTES:
    - Usa la imagen de referencia como base y aplica solo los cambios solicitados
    - Mantén la composición general y los elementos principales
    - Conserva el estilo ${preview.style} y el público objetivo ${preview.target_audience}
    - Asegúrate de que la imagen sea profesional, atractiva y lista para redes sociales
    - Si se solicitan cambios de color, aplica solo a las áreas específicas mencionadas
    - Si se solicitan cambios de texto, mantén la legibilidad y el contraste
    - Preserva la calidad visual y la resolución de la imagen original`;

    // Generar nueva imagen con correcciones usando la imagen anterior como referencia
    const newImageUrl = await generateImageWithGemini(correctionPrompt, preview.image_url);
    
    if (!newImageUrl) {
      return res.status(500).json({ error: 'Error generando imagen corregida' });
    }

    // Actualizar preview con nueva imagen
    const { data: updatedPreview, error: updateError } = await supabase
      .from('instagram_previews')
      .update({
        image_url: newImageUrl,
        correction_count: (preview.correction_count || 0) + 1,
        last_corrections: {
          corrections,
          visual_feedback,
          text_changes,
          style_changes,
          timestamp: new Date().toISOString()
        },
        updated_at: new Date().toISOString()
      })
      .eq('id', id)
      .select()
      .single();

    if (updateError) {
      console.error('❌ Error actualizando preview:', updateError);
      return res.status(500).json({ error: 'Error actualizando preview' });
    }

    res.json({
      success: true,
      message: 'Correcciones aplicadas exitosamente',
      preview: {
        id: updatedPreview.id,
        type: updatedPreview.type,
        image_url: newImageUrl,
        suggested_caption: updatedPreview.suggested_caption,
        correction_count: updatedPreview.correction_count,
        last_corrections: updatedPreview.last_corrections,
        updated_at: updatedPreview.updated_at
      }
    });

  } catch (error) {
    console.error('❌ Error procesando correcciones:', error);
    res.status(500).json({ 
      error: 'Error procesando correcciones',
      details: error.message 
    });
  }
});

// Endpoint para publicar preview final
app.post('/api/preview/:id/publish', async (req, res) => {
  try {
    const { id } = req.params;
    const { final_caption = null, image_url = null } = req.body;

    console.log('🚀 Publicando preview...', { id, final_caption, image_url });

    // Obtener preview
    const { data: preview, error: previewError } = await supabase
      .from('instagram_previews')
      .select('*')
      .eq('id', id)
      .single();

    if (previewError || !preview) {
      return res.status(404).json({ error: 'Preview no encontrado' });
    }

    if (preview.status === 'published') {
      return res.status(400).json({ error: 'Preview ya fue publicado' });
    }

    // Usar caption final o el sugerido
    const caption = final_caption || preview.suggested_caption;

    // Usar URL proporcionada o la del preview
    const finalImageUrl = image_url || preview.image_url;
    
    // Debug: verificar el tipo de image_url
    console.log('🔍 Debug image_url:', typeof finalImageUrl, finalImageUrl);

    let publishResult;
    
    if (preview.type === 'post') {
      // Publicar como post
      const imageUrl = typeof finalImageUrl === 'string' ? finalImageUrl : finalImageUrl?.imageUrl || finalImageUrl;
      console.log('🔍 Debug imageUrl final:', imageUrl);
      publishResult = await publishInstagramPost(imageUrl, caption);
    } else if (preview.type === 'story') {
      // Publicar como story
      const imageUrl = typeof finalImageUrl === 'string' ? finalImageUrl : finalImageUrl?.imageUrl || finalImageUrl;
      publishResult = await publishInstagramStory(imageUrl);
    } else if (preview.type === 'reel') {
      // Publicar como Reel (video)
      const videoUrl = typeof finalImageUrl === 'string' ? finalImageUrl : finalImageUrl?.video_url || finalImageUrl;
      publishResult = await publishInstagramReel(videoUrl, caption);
    } else {
      return res.status(400).json({ error: 'Tipo de preview no válido' });
    }

    if (!publishResult.success) {
      return res.status(500).json({ 
        error: 'Error publicando en Instagram',
        details: publishResult.error 
      });
    }

    // Actualizar preview como publicado
    const { data: updatedPreview, error: updateError } = await supabase
      .from('instagram_previews')
      .update({
        status: 'published',
        published_at: new Date().toISOString(),
        instagram_media_id: publishResult.media_id || publishResult.mediaId,
        instagram_url: publishResult.permalink || null,
        final_caption: caption
      })
      .eq('id', id)
      .select()
      .single();

    if (updateError) {
      console.error('❌ Error actualizando preview publicado:', updateError);
    }

    // Guardar registro en instagram_posts
    try {
      const mediaType = preview.type === 'post' ? 'IMAGE' : (preview.type === 'story' ? 'IMAGE' : 'REEL');
      const insertPayload = {
        media_id: publishResult.media_id || publishResult.mediaId,
        instagram_post_id: publishResult.post_id || null,
        image_url: mediaType === 'IMAGE' ? finalImageUrl : null,
        video_url: mediaType !== 'IMAGE' ? finalImageUrl : null,
        caption: caption || null,
        media_type: mediaType,
        status: 'published',
        ai_generated: true,
        ai_prompt: preview.topic || null,
        created_by: 'user',
        published_at: new Date().toISOString(),
        instagram_media_url: publishResult.permalink || null
      };
      await supabase.from('instagram_posts').insert([insertPayload]);
    } catch (e) {
      console.warn('⚠️ No se pudo insertar en instagram_posts:', e.message);
    }

    res.json({
      success: true,
      message: `${preview.type === 'post' ? 'Post' : (preview.type === 'story' ? 'Story' : 'Reel')} publicado exitosamente`,
      published: {
        id: updatedPreview.id,
        type: updatedPreview.type,
        instagram_media_id: publishResult.media_id || publishResult.mediaId,
        instagram_url: publishResult.permalink || null,
        final_caption: caption,
        published_at: updatedPreview.published_at
      }
    });

  } catch (error) {
    console.error('❌ Error publicando preview:', error);
    res.status(500).json({ 
      error: 'Error publicando preview',
      details: error.message 
    });
  }
});

// Endpoint para obtener previews del usuario
app.get('/api/previews', async (req, res) => {
  try {
    const { status = 'all', type = 'all', limit = 20, offset = 0 } = req.query;

    let query = supabase
      .from('instagram_previews')
      .select('*')
      .order('created_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (status !== 'all') {
      query = query.eq('status', status);
    }

    if (type !== 'all') {
      query = query.eq('type', type);
    }

    const { data: previews, error: previewsError } = await query;

    if (previewsError) {
      console.error('❌ Error obteniendo previews:', previewsError);
      return res.status(500).json({ error: 'Error obteniendo previews' });
    }

    res.json({
      success: true,
      message: 'Previews obtenidos exitosamente',
      previews: previews || [],
      pagination: {
        limit: parseInt(limit),
        offset: parseInt(offset),
        total: previews?.length || 0
      }
    });

  } catch (error) {
    console.error('❌ Error obteniendo previews:', error);
    res.status(500).json({ 
      error: 'Error obteniendo previews',
      details: error.message 
    });
  }
});

// =============================================
// ENDPOINTS DE VIDEOS EN PROCESAMIENTO
// =============================================

// Endpoint para verificar estado de videos en procesamiento
app.get('/api/video-status/:jobId', async (req, res) => {
  try {
    const { jobId } = req.params;
    
    // Verificar si el job está en nuestra cola
    const queueItem = videoProcessingQueue.get(jobId);
    if (!queueItem) {
      return res.status(404).json({ 
        error: 'Job no encontrado en la cola de procesamiento',
        jobId 
      });
    }
    
    res.json({
      jobId,
      status: queueItem.status,
      progress: queueItem.progress,
      message: 'Video en procesamiento'
    });
    
  } catch (error) {
    console.error('❌ Error verificando estado de video:', error);
    res.status(500).json({ 
      error: 'Error verificando estado de video',
      details: error.message 
    });
  }
});

// Endpoint para listar todos los videos en procesamiento
app.get('/api/video-queue', async (req, res) => {
  try {
    const queueStatus = Array.from(videoProcessingQueue.entries()).map(([jobId, item]) => ({
      jobId,
      status: item.status,
      progress: item.progress
    }));
    
    res.json({
      totalJobs: videoProcessingQueue.size,
      jobs: queueStatus
    });
    
  } catch (error) {
    console.error('❌ Error listando cola de videos:', error);
    res.status(500).json({ 
      error: 'Error listando cola de videos',
      details: error.message 
    });
  }
});

// Endpoint de prueba para generar imágenes mejoradas
app.post('/api/test-image-generation', async (req, res) => {
  try {
    const { topic = 'Desarrollador Full Stack en Rappi' } = req.body;
    
    console.log('🧪 Probando generación de imagen mejorada...', { topic });

    // Usar la función mejorada directamente
    const imageUrl = await generateImageWithGemini(topic);
    
    if (!imageUrl) {
      return res.status(500).json({ error: 'No se pudo generar la imagen de prueba' });
    }

    console.log('✅ Imagen de prueba generada exitosamente:', imageUrl);

    res.json({
      success: true,
      message: 'Imagen generada con texto incluido por la IA',
      image_url: imageUrl,
      topic: topic,
      improvements: [
        'Texto generado directamente por la IA',
        'Sin función addTextToImage',
        'Diseño equilibrado entre texto e imágenes',
        'Call to action incluido',
        'Imagen completa lista para publicar',
        'Colores corporativos bien distribuidos'
      ]
    });
  } catch (error) {
    console.error('❌ Error en prueba de generación:', error);
    res.status(500).json({ 
      error: 'Error generando imagen de prueba',
      details: error.message 
    });
  }
});

// =============================================
// INICIO DEL SERVIDOR
// =============================================

app.listen(PORT, () => {
  console.log(`🚀 Servidor Magneto Backend ejecutándose en puerto ${PORT}`);
  console.log(`📱 Webhook Instagram: http://localhost:${PORT}/webhook/instagram`);
  console.log(`🤖 IA Agent: http://localhost:${PORT}/api/agent/reply`);
  console.log(`💬 Chats API: http://localhost:${PORT}/api/chats`);
  console.log(`🔍 Search API: http://localhost:${PORT}/api/search`);
  console.log(`📊 Stats API: http://localhost:${PORT}/api/conversations/stats`);
  console.log(`👤 Users API: http://localhost:${PORT}/api/users`);
  console.log(`📸 Content API: http://localhost:${PORT}/api/posts`);
  console.log(`📱 Instagram Posts: http://localhost:${PORT}/api/instagram/posts`);
  console.log(`💬 Post Comments: http://localhost:${PORT}/api/instagram/posts/:id/comments`);
  console.log(`🔔 SSE Notifications: http://localhost:${PORT}/api/notifications/stream`);
  console.log(`💾 Supabase conectado: ${process.env.SUPABASE_URL ? '✅' : '❌'}`);
  console.log(`🤖 OpenAI/OpenRouter: ${process.env.OPENROUTER_API_KEY ? '✅' : '❌'}`);
  console.log(`🎨 Gemini AI: ${process.env.GEMINI_API_KEY ? '✅' : '❌'}`);
  console.log(`📱 Instagram Token: ${process.env.INSTAGRAM_ACCESS_TOKEN ? '✅' : '❌'}`);
});
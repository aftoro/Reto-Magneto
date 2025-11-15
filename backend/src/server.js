const express = require('express');
const cors = require('cors');
const multer = require('multer');
require('dotenv').config();

// Importar middlewares
const { loggingMiddleware, errorLoggingMiddleware } = require('./middlewares/logging.middleware');
const { rateLimitByIP } = require('./middlewares/rate-limit.middleware');
const { authMiddleware } = require('./middlewares/auth.middleware');

// Importar rutas
const apiRoutes = require('./routes');

// Importar utilidades y funciones existentes
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
  sendInstagramDMReply,
  handleInstagramComment,
  handleInstagramMention,
  handleInstagramMessage,
  handleInstagramLike,
  APP_CONSTANTS
} = require('./utils');

const app = express();
const PORT = process.env.PORT || 3000;

app.set('trust proxy', 1);

app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(',') || '*',
  credentials: true
}));

app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

app.use(loggingMiddleware);

app.use(rateLimitByIP({ 
  maxRequests: 1000, 
  windowMs: 15 * 60 * 1000
}));

const storage = multer.memoryStorage();
const upload = multer({ 
  storage: storage,
  limits: {
    fileSize: 10 * 1024 * 1024 // 10MB
  }
});

app.use('/api', apiRoutes);

app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    name: APP_CONSTANTS.NAME,
    version: APP_CONSTANTS.VERSION,
    architecture: APP_CONSTANTS.ARCHITECTURE,
    description: APP_CONSTANTS.DESCRIPTION
  });
});

app.get('/instagram/webhook/verify', (req, res) => {
  const mode = req.query['hub.mode'];
  const token = req.query['hub.verify_token'];
  const challenge = req.query['hub.challenge'];

  if (mode === 'subscribe' && token === process.env.INSTAGRAM_VERIFY_TOKEN) {
    res.status(200).send(challenge);
  } else {
    res.status(403).json({
      success: false,
      message: 'Token de verificación inválido'
    });
  }
});

app.post('/instagram/webhook/comment', async (req, res) => {
  try {
    const result = await handleInstagramComment(req.body);
    res.json({ success: true, data: result });
  } catch (error) {
    console.error('Error processing Instagram comment:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

app.post('/instagram/webhook/mention', async (req, res) => {
  try {
    const result = await handleInstagramMention(req.body);
    res.json({ success: true, data: result });
  } catch (error) {
    console.error('Error processing Instagram mention:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

app.post('/instagram/webhook/message', async (req, res) => {
  try {
    const result = await handleInstagramMessage(req.body);
    res.json({ success: true, data: result });
  } catch (error) {
    console.error('Error processing Instagram message:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

app.post('/instagram/webhook/like', async (req, res) => {
  try {
    const result = await handleInstagramLike(req.body);
    res.json({ success: true, data: result });
  } catch (error) {
    console.error('Error processing Instagram like:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

function sendSSE(res, event, data) {
  res.write(`event: ${event}\n`);
  res.write(`data: ${JSON.stringify(data)}\n\n`);
}

app.post('/generate/preview/stream', upload.single('image'), async (req, res) => {
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  res.setHeader('X-Accel-Buffering', 'no');

  try {
    const { type, prompt, topic, style, target_audience } = req.body;
    const imageFile = req.file;
    
    const finalTopic = topic || prompt;
    
    if (!finalTopic) {
      sendSSE(res, 'error', { message: 'Topic o prompt son requeridos' });
      res.end();
      return;
    }

    const finalStyle = style || 'moderno y profesional';
    const finalTargetAudience = target_audience || 'desarrolladores y profesionales tech';
    const finalType = type || 'post';

    let streamData = {
      captionOptions: null,
      mediaUrl: null,
      videoUrl: null,
      improveSuggestions: null,
    };

    sendSSE(res, 'start', { type: finalType, topic: finalTopic });

    const captureEvent = (event, data) => {
      if (event === 'captions') {
        streamData.captionOptions = data.captionOptions;
      } else if (event === 'media') {
        streamData.mediaUrl = data.mediaUrl;
        streamData.videoUrl = data.videoUrl;
      } else if (event === 'suggestions') {
        streamData.improveSuggestions = data.improveSuggestions;
      }
      sendSSE(res, event, data);
    };

    if (finalType === 'reel') {
      const accent = req.body.accent || 'neutral';
      const duration = parseInt(req.body.duration) || 8;
      
      sendSSE(res, 'status', { message: 'Generando reel en background... Esto puede tomar varios minutos.' });
      
      processReelInBackgroundAndCreatePreview(
        finalTopic,
        accent,
        finalStyle,
        duration,
        finalTargetAudience,
        (previewId) => {
          sendSSE(res, 'preview_created', { previewId });
        }
      ).then((previewId) => {
        if (previewId) {
          sendSSE(res, 'preview_saved', { previewId });
        }
        sendSSE(res, 'done', {});
        res.end();
      }).catch(error => {
        console.error('Error procesando reel en background:', error);
        sendSSE(res, 'error', { message: error.message });
        res.end();
      });
      
      return;
    } else {
      const { generateCompletePreviewStream } = require('./utils/functions');
      
      await generateCompletePreviewStream(
        finalTopic,
        finalStyle,
        finalTargetAudience,
        finalType,
        imageFile?.path,
        captureEvent
      );
    }

    if (finalType !== 'story') {
      try {
        const mediaUrl = streamData.videoUrl || streamData.mediaUrl;
        if (mediaUrl) {
          const previewData = {
            type: finalType,
            topic: finalTopic,
            style: finalStyle,
            target_audience: finalTargetAudience,
            image_url: mediaUrl,
            status: 'draft',
            suggested_caption: streamData.captionOptions || null,
            improve_suggestions: streamData.improveSuggestions || null,
            created_by: 'user',
          };

          const { data: savedPreview, error: saveError } = await supabase
            .from('instagram_previews')
            .insert(previewData)
            .select()
            .single();

          if (!saveError && savedPreview) {
            sendSSE(res, 'preview_saved', { previewId: savedPreview.id });
          }
        }
      } catch (saveErr) {
        console.error('Error guardando preview como borrador:', saveErr);
      }
    }

    sendSSE(res, 'done', {});
    res.end();
  } catch (error) {
    console.error('Error generating preview stream:', error);
    sendSSE(res, 'error', { message: error.message });
    res.end();
  }
});

app.post('/generate/preview', upload.single('image'), async (req, res) => {
  try {
    const { type, prompt, topic, style, target_audience } = req.body;
    const imageFile = req.file;
    
    const finalTopic = topic || prompt;
    
    if (!finalTopic) {
      return res.status(400).json({
        success: false,
        message: 'Topic o prompt son requeridos'
      });
    }

    const finalStyle = style || 'moderno y profesional';
    const finalTargetAudience = target_audience || 'desarrolladores y profesionales tech';
    const finalType = type || 'post';

    let result;
    if (finalType === 'reel') {
      const accent = req.body.accent || 'neutral';
      const duration = parseInt(req.body.duration) || 8;
      
      processReelInBackgroundAndCreatePreview(
        finalTopic,
        accent,
        finalStyle,
        duration,
        finalTargetAudience
      ).catch(error => {
        console.error('Error procesando reel en background:', error);
      });

      return res.json({ 
        success: true, 
        data: {
          status: 'generating',
          message: 'Reel generándose en background. Te notificaremos cuando esté listo.'
        }
      });
    } else {
      const { generateCompletePreview } = require('./utils/functions');
      result = await generateCompletePreview(finalTopic, finalStyle, finalTargetAudience, finalType, imageFile?.path);
      
      if (result && result.mediaUrl) {
        const previewData = {
          type: finalType,
          topic: finalTopic,
          style: finalStyle,
          target_audience: finalTargetAudience,
          image_url: result.mediaUrl,
          status: 'draft',
          suggested_caption: result.captionOptions || null,
          improve_suggestions: result.improveSuggestions || null,
          created_by: 'user',
        };

        const { data: savedPreview, error: saveError } = await supabase
          .from('instagram_previews')
          .insert(previewData)
          .select()
          .single();

        if (!saveError && savedPreview) {
          result.previewId = savedPreview.id;
          result.id = savedPreview.id;
        }
    }

    if (result) {
      if (result.previewId && !result.id) {
        result.id = result.previewId;
      }
      if (result.id && !result.previewId) {
        result.previewId = result.id;
      }
    }

    res.json({ success: true, data: result });
    }
  } catch (error) {
    console.error('Error generating preview:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

app.get('/previews', async (req, res) => {
  try {
    const {
      status,
      type,
      limit = 20,
      offset = 0,
      search
    } = req.query;

    let query = supabase
      .from('instagram_previews')
      .select('*', { count: 'exact' })
      .order('created_at', { ascending: false });

    if (status) {
      query = query.eq('status', status);
    }

    if (type) {
      query = query.eq('type', type);
    }

    if (search) {
      query = query.or(`topic.ilike.%${search}%,final_caption.ilike.%${search}%`);
    }

    const limitNum = parseInt(limit) || 20;
    const offsetNum = parseInt(offset) || 0;
    query = query.range(offsetNum, offsetNum + limitNum - 1);

    const { data: previews, error, count } = await query;

    if (error) {
      console.error('Error obteniendo previews:', error);
      return res.status(500).json({
        success: false,
        message: 'Error al obtener previews',
        error: error.message
      });
    }

    res.json({
      success: true,
      previews: previews || [],
      pagination: {
        total: count || 0,
        limit: limitNum,
        offset: offsetNum,
        hasMore: (offsetNum + (previews?.length || 0)) < (count || 0)
      }
    });
  } catch (error) {
    console.error('Error en GET /previews:', error);
    res.status(500).json({
      success: false,
      message: 'Error al obtener previews',
      error: error.message
    });
  }
});

app.post('/generate/ai-content', async (req, res) => {
  try {
    const { prompt, type = 'text' } = req.body;
    
    if (!prompt) {
      return res.status(400).json({
        success: false,
        message: 'Prompt es requerido'
      });
    }

    const result = await generateAIContent(prompt, type);
    res.json({ success: true, data: result });
  } catch (error) {
    console.error('Error generating AI content:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

async function processReelInBackgroundAndCreatePreview(prompt, accent, style, duration, targetAudience, onPreviewCreated = null) {
  try {
    const { generateCompleteReelPreview } = require('./utils/functions');
    
    const result = await generateCompleteReelPreview(prompt, accent, style, duration, targetAudience);
    
    if (result.error) {
      throw new Error(result.error);
    }
    
    const previewData = {
      type: 'reel',
      topic: prompt,
      style: style,
      target_audience: targetAudience,
      image_url: result.videoUrl,
      status: 'draft',
      suggested_caption: result.captionOptions || null,
      improve_suggestions: result.improveSuggestions || null,
      created_by: 'user',
    };

    const { data: savedPreview, error: saveError } = await supabase
      .from('instagram_previews')
      .insert(previewData)
      .select()
      .single();

    if (saveError || !savedPreview) {
      console.error('Error creando preview después de generar reel:', saveError);
      throw saveError || new Error('Error creando preview');
    }
    
    if (onPreviewCreated) {
      onPreviewCreated(savedPreview.id);
    }
    
    return savedPreview.id;
  } catch (error) {
    console.error('Error procesando reel en background:', error);
    throw error;
  }
}

async function processReelInBackground(previewId, prompt, accent, style, duration, targetAudience) {
  try {
    const { generateCompleteReelPreview } = require('./utils/functions');
    
    const result = await generateCompleteReelPreview(prompt, accent, style, duration, targetAudience);
    
    if (result.error) {
      throw new Error(result.error);
    }
    
    const updateData = {
      status: 'draft',
      image_url: result.videoUrl || null,
      suggested_caption: result.captionOptions || null,
      improve_suggestions: result.improveSuggestions || null,
      updated_at: new Date().toISOString(),
    };

    const { data: updatedPreview, error: updateError } = await supabase
      .from('instagram_previews')
      .update(updateData)
      .eq('id', previewId)
      .select()
      .single();

    if (updateError) {
      console.error('Error actualizando preview:', updateError);
      throw updateError;
    }
    
    return updatedPreview;
  } catch (error) {
    console.error('Error procesando reel en background:', error);
    
    await supabase
      .from('instagram_previews')
      .update({ 
        status: 'error',
        updated_at: new Date().toISOString()
      })
      .eq('id', previewId)
      .catch(updateErr => console.error('Error actualizando preview a error:', updateErr));
    
    throw error;
  }
}

app.use(errorLoggingMiddleware);

app.listen(PORT, () => {
  console.log(`${APP_CONSTANTS.NAME} v${APP_CONSTANTS.VERSION} - Puerto: ${PORT}`);
  
  if (process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID && process.env.INSTAGRAM_ACCESS_TOKEN) {
    const { syncInstagramPostLikes } = require('./utils/functions');
    
    const SYNC_INTERVAL_MS = parseInt(process.env.INSTAGRAM_LIKES_SYNC_INTERVAL_MS || '3600000');
    
    if (process.env.INSTAGRAM_LIKES_SYNC_ON_START === 'true') {
      setImmediate(async () => {
        try {
          await syncInstagramPostLikes();
        } catch (error) {
          console.error('Error en sincronización inicial:', error);
        }
      });
    }
    
    setInterval(async () => {
      try {
        await syncInstagramPostLikes();
      } catch (error) {
        console.error('Error en sincronización periódica:', error);
      }
    }, SYNC_INTERVAL_MS);
  }
});

module.exports = {
  app,
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
};

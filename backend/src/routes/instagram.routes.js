const express = require('express');
const { rateLimitWebhooks } = require('../middlewares/rate-limit.middleware');
const { validateInstagramData } = require('../middlewares/validation.middleware');

const router = express.Router();

// Importar handlers existentes
const {
  handleInstagramComment,
  handleInstagramMention,
  handleInstagramMessage,
  handleInstagramLike
} = require('../utils/handlers');

// Aplicar rate limiting específico para webhooks
router.use(rateLimitWebhooks({ maxRequests: 10, windowMs: 60 * 1000 })); // 10 webhooks por minuto

router.post('/webhook/comment', 
  validateInstagramData,
  async (req, res) => {
    try {
      const result = await handleInstagramComment(req.body);
      
      res.json({
        success: true,
        message: 'Comentario procesado exitosamente',
        data: result
      });
    } catch (error) {
      console.error('Error processing Instagram comment:', error);
      res.status(500).json({
        success: false,
        message: 'Error al procesar comentario',
        error: error.message
      });
    }
  }
);

router.post('/webhook/mention', 
  validateInstagramData,
  async (req, res) => {
    try {
      const result = await handleInstagramMention(req.body);
      
      res.json({
        success: true,
        message: 'Mención procesada exitosamente',
        data: result
      });
    } catch (error) {
      console.error('Error processing Instagram mention:', error);
      res.status(500).json({
        success: false,
        message: 'Error al procesar mención',
        error: error.message
      });
    }
  }
);

router.post('/webhook/message', 
  validateInstagramData,
  async (req, res) => {
    try {
      const result = await handleInstagramMessage(req.body);
      
      res.json({
        success: true,
        message: 'Mensaje procesado exitosamente',
        data: result
      });
    } catch (error) {
      console.error('Error processing Instagram message:', error);
      res.status(500).json({
        success: false,
        message: 'Error al procesar mensaje',
        error: error.message
      });
    }
  }
);

router.post('/webhook/like', 
  validateInstagramData,
  async (req, res) => {
    res.status(200).json({
      success: false,
      message: 'Este endpoint está deprecado. Instagram NO ofrece webhooks para likes de posts. Usa el sistema de polling periódico.',
      deprecated: true
    });
  }
);

router.get('/webhook', (req, res) => {
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

router.post('/webhook', 
  validateInstagramData,
  async (req, res) => {
    try {
      const webhookData = req.body;
      
      res.status(200).json({ success: true });

      if (webhookData.entry && Array.isArray(webhookData.entry)) {
        for (const entry of webhookData.entry) {
          if (entry.messaging && Array.isArray(entry.messaging)) {
            for (const messagingItem of entry.messaging) {
              if (messagingItem.message) {
                if (!messagingItem.sender || !messagingItem.sender.id) {
                  continue;
                }
                
                if (!messagingItem.recipient || !messagingItem.recipient.id) {
                  continue;
                }
                
                const messageData = {
                  id: messagingItem.message.mid || messagingItem.message.id || `msg_${messagingItem.timestamp}`,
                  sender: messagingItem.sender,
                  recipient: messagingItem.recipient,
                  text: messagingItem.message.text || '',
                  timestamp: messagingItem.timestamp,
                  message: messagingItem.message,
                  postback: messagingItem.postback
                };
                
                await handleInstagramMessage(messageData);
              } else if (messagingItem.postback) {
                if (!messagingItem.sender || !messagingItem.sender.id) {
                  continue;
                }
                
                const messageData = {
                  id: `postback_${messagingItem.timestamp}`,
                  sender: messagingItem.sender,
                  recipient: messagingItem.recipient,
                  text: messagingItem.postback.title || messagingItem.postback.payload || '',
                  timestamp: messagingItem.timestamp,
                  postback: messagingItem.postback
                };
                await handleInstagramMessage(messageData);
              }
            }
          }

          if (entry.changes && Array.isArray(entry.changes)) {
            for (const change of entry.changes) {
              if (change.field === 'comments') {
                if (change.value) {
                  const commentData = {
                    id: change.value.id || change.value.comment_id,
                    text: change.value.text || change.value.message,
                    from: change.value.from || {
                      id: change.value.user_id,
                      username: change.value.username
                    },
                    media: change.value.media || {
                      id: change.value.media_id
                    },
                    timestamp: change.value.created_time || change.value.timestamp
                  };
                  
                  if (commentData.id && commentData.from?.id) {
                    await handleInstagramComment(commentData);
                  }
                }
              } else if (change.field === 'mentions') {
                if (change.value) {
                  const mentionData = {
                    id: change.value.id || change.value.mention_id,
                    text: change.value.text || change.value.message,
                    from: change.value.from || {
                      id: change.value.user_id,
                      username: change.value.username
                    },
                    media: change.value.media || {
                      id: change.value.media_id
                    }
                  };
                  
                  if (mentionData.id && mentionData.from?.id) {
                    await handleInstagramMention(mentionData);
                  }
                }
              }
            }
          }
        }
      }
    } catch (error) {
      console.error('Error procesando eventos de webhook:', error);
    }
  }
);

router.get('/posts', async (req, res) => {
  try {
    const { getAllInstagramPosts } = require('../utils/functions');
    const { limit = 20, offset = 0 } = req.query;
    
    const posts = await getAllInstagramPosts(parseInt(limit), parseInt(offset));
    
    res.json({
      success: true,
      data: posts
    });
  } catch (error) {
    console.error('Error getting Instagram posts:', error);
    res.status(500).json({
      success: false,
      message: 'Error al obtener posts de Instagram',
      error: error.message
    });
  }
});

router.get('/posts/:postId/comments', async (req, res) => {
  try {
    const { getPostComments } = require('../utils/functions');
    const { postId } = req.params;
    
    const comments = await getPostComments(postId);
    
    res.json({
      success: true,
      data: comments
    });
  } catch (error) {
    console.error('Error getting post comments:', error);
    res.status(500).json({
      success: false,
      message: 'Error al obtener comentarios del post',
      error: error.message
    });
  }
});

router.post('/publish/post', async (req, res) => {
  try {
    const { publishInstagramPost } = require('../utils/functions');
    const { imageUrl, caption } = req.body;
    
    if (!imageUrl || !caption) {
      return res.status(400).json({
        success: false,
        message: 'URL de imagen y caption son requeridos'
      });
    }
    
    const result = await publishInstagramPost(imageUrl, caption);
    
    res.json({
      success: true,
      message: 'Post publicado exitosamente',
      data: result
    });
  } catch (error) {
    console.error('Error publishing Instagram post:', error);
    res.status(500).json({
      success: false,
      message: 'Error al publicar en Instagram',
      error: error.message
    });
  }
});

router.post('/publish/story', async (req, res) => {
  try {
    const { publishInstagramStory } = require('../utils/functions');
    const { imageUrl, caption } = req.body;
    
    if (!imageUrl) {
      return res.status(400).json({
        success: false,
        message: 'URL de imagen es requerida'
      });
    }
    
    const result = await publishInstagramStory(imageUrl, caption);
    
    res.json({
      success: true,
      message: 'Story publicado exitosamente',
      data: result
    });
  } catch (error) {
    console.error('Error publishing Instagram story:', error);
    res.status(500).json({
      success: false,
      message: 'Error al publicar story en Instagram',
      error: error.message
    });
  }
});

router.post('/publish/reel', async (req, res) => {
  try {
    const { publishInstagramReel } = require('../utils/functions');
    const { videoUrl, caption } = req.body;
    
    if (!videoUrl) {
      return res.status(400).json({
        success: false,
        message: 'URL de video es requerida'
      });
    }
    
    const result = await publishInstagramReel(videoUrl, caption);
    
    res.json({
      success: true,
      message: 'Reel publicado exitosamente',
      data: result
    });
  } catch (error) {
    console.error('Error publishing Instagram reel:', error);
    res.status(500).json({
      success: false,
      message: 'Error al publicar reel en Instagram',
      error: error.message
    });
  }
});

router.post('/sync-likes', async (req, res) => {
  try {
    const { syncInstagramPostLikes } = require('../utils/functions');
    
    const result = await syncInstagramPostLikes();
    
    res.json({
      success: true,
      message: 'Sincronización de likes completada',
      data: result
    });
  } catch (error) {
    console.error('Error sincronizando likes:', error);
    res.status(500).json({
      success: false,
      message: 'Error al sincronizar likes',
      error: error.message
    });
  }
});

router.get('/likes/stats', async (req, res) => {
  try {
    const PostLikeRepository = require('../repositories/PostLikeRepository');
    const postLikeRepository = new PostLikeRepository();
    
    const weeklyCount = await postLikeRepository.getWeeklyLikesCount();
    
    res.json({
      success: true,
      data: {
        weeklyCount: weeklyCount
      }
    });
  } catch (error) {
    console.error('Error obteniendo estadísticas de likes:', error);
    res.status(500).json({
      success: false,
      message: 'Error al obtener estadísticas de likes',
      error: error.message
    });
  }
});

router.get('/likes-summary', async (req, res) => {
  try {
    const { supabase } = require('../utils/functions');
    const { getInstagramPostLikeCount } = require('../utils/functions');
    
    const { data: posts, error: postsError } = await supabase
      .from('instagram_posts')
      .select('id, instagram_post_id, media_id')
      .order('created_at', { ascending: false });
    
    if (postsError) {
      console.error('Error obteniendo posts:', postsError);
      throw postsError;
    }
    
    if (!posts || posts.length === 0) {
      return res.json({
        success: true,
        data: {
          totalLikes: 0,
          totalPosts: 0
        }
      });
    }
    
    let totalLikes = 0;
    let processedPosts = 0;
    
    const batchSize = 10;
    for (let i = 0; i < posts.length; i += batchSize) {
      const batch = posts.slice(i, i + batchSize);
      
      await Promise.all(
        batch.map(async (post) => {
          try {
            const mediaId = post.instagram_post_id || post.media_id;
            if (mediaId) {
              const likeCount = await getInstagramPostLikeCount(mediaId);
              totalLikes += likeCount;
              processedPosts++;
            }
          } catch (error) {
            // Ignorar errores individuales
          }
        })
      );
      
      if (i + batchSize < posts.length) {
        await new Promise(resolve => setTimeout(resolve, 500));
      }
    }
    
    res.json({
      success: true,
      data: {
        totalLikes: totalLikes,
        totalPosts: posts.length,
        processedPosts: processedPosts
      }
    });
  } catch (error) {
    console.error('Error obteniendo resumen de likes:', error);
    res.status(500).json({
      success: false,
      message: 'Error al obtener resumen de likes',
      error: error.message
    });
  }
});

router.post('/likes/by-posts', async (req, res) => {
  try {
    const { postIds } = req.body;
    
    if (!postIds || !Array.isArray(postIds)) {
      return res.status(400).json({
        success: false,
        message: 'postIds debe ser un array'
      });
    }
    
    const PostLikeRepository = require('../repositories/PostLikeRepository');
    const postLikeRepository = new PostLikeRepository();
    
    const counts = await postLikeRepository.getLikesCountByPosts(postIds);
    
    res.json({
      success: true,
      data: counts
    });
  } catch (error) {
    console.error('Error obteniendo conteo de likes por posts:', error);
    res.status(500).json({
      success: false,
      message: 'Error al obtener conteo de likes',
      error: error.message
    });
  }
});

module.exports = router;

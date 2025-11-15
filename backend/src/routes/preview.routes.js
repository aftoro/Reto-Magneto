const express = require('express');
const { authMiddleware } = require('../middlewares/auth.middleware');
const { supabase } = require('../utils');
const {
  publishInstagramPost,
  publishInstagramStory,
  publishInstagramReel,
  getOrCreateInstagramPost
} = require('../utils');

const router = express.Router();

router.get('/:id', authMiddleware, async (req, res) => {
  try {
    const { id } = req.params;
    
    const { data: preview, error } = await supabase
      .from('instagram_previews')
      .select('*')
      .eq('id', id)
      .single();

    if (error || !preview) {
      return res.status(404).json({ 
        success: false,
        error: 'Preview no encontrado',
        searchedId: id
      });
    }

    res.json(preview);
  } catch (error) {
    console.error('Error obteniendo preview:', error);
    res.status(500).json({ 
      success: false,
      error: error.message 
    });
  }
});

router.get('/:id/status', authMiddleware, async (req, res) => {
  try {
    const { id } = req.params;
    
    const { data: preview, error } = await supabase
      .from('instagram_previews')
      .select('id, status, type, topic, image_url, created_at, updated_at')
      .eq('id', id)
      .single();

    if (error || !preview) {
      return res.status(404).json({ 
        success: false,
        error: 'Preview no encontrado' 
      });
    }

    res.json({
      success: true,
      preview: {
        id: preview.id,
        status: preview.status,
        type: preview.type,
        topic: preview.topic,
        hasMedia: !!preview.image_url,
        createdAt: preview.created_at,
        updatedAt: preview.updated_at,
      }
    });
  } catch (error) {
    console.error('Error verificando estado de preview:', error);
    res.status(500).json({ 
      success: false,
      error: error.message 
    });
  }
});

router.post('/:id/publish', authMiddleware, async (req, res) => {
  try {
    const { id } = req.params;
    const { finalCaption } = req.body;

    let preview = null;
    let previewError = null;
    
    const { data: previewByUuid, error: errorByUuid } = await supabase
      .from('instagram_previews')
      .select('*')
      .eq('id', id)
      .single();
    
    if (!errorByUuid && previewByUuid) {
      preview = previewByUuid;
    } else {
      const { data: recentPreviews, error: recentError } = await supabase
        .from('instagram_previews')
        .select('*')
        .eq('type', 'reel')
        .in('status', ['draft', 'generating'])
        .order('created_at', { ascending: false })
        .limit(10);
      
      if (!recentError && recentPreviews && recentPreviews.length > 0) {
        if (/^\d+$/.test(id)) {
          const idTimestamp = parseInt(id);
          const matchingPreview = recentPreviews.find(p => {
            const createdAt = new Date(p.created_at).getTime();
            return Math.abs(createdAt - idTimestamp) < 3600000;
          });
          
          if (matchingPreview) {
            preview = matchingPreview;
          }
        }
      }
      
      if (!preview) {
        previewError = errorByUuid || new Error('Preview no encontrado');
      }
    }

    if (previewError || !preview) {
      return res.status(404).json({ 
        success: false,
        error: 'Preview no encontrado',
        searchedId: id
      });
    }

    if (preview.status === 'published') {
      return res.status(400).json({ 
        success: false,
        error: 'Preview ya fue publicado' 
      });
    }

    const caption = finalCaption || preview.final_caption || preview.suggested_caption?.captions?.[0]?.content || '';
    const mediaUrl = preview.image_url;

    if (!mediaUrl) {
      return res.status(400).json({ 
        success: false,
        error: 'No hay media disponible para publicar' 
      });
    }

    let publishResult;
    if (preview.type === 'post') {
      publishResult = await publishInstagramPost(mediaUrl, caption);
    } else if (preview.type === 'story') {
      publishResult = await publishInstagramStory(mediaUrl);
    } else if (preview.type === 'reel') {
      publishResult = await publishInstagramReel(mediaUrl, caption);
    } else {
      return res.status(400).json({ 
        success: false,
        error: 'Tipo de preview no soportado' 
      });
    }

    if (!publishResult.success) {
      console.error('Error publicando en Instagram:', publishResult.error);
      return res.status(500).json({ 
        success: false,
        error: publishResult.error || 'Error al publicar en Instagram' 
      });
    }

    const publishedPostId = publishResult.post_id || publishResult.story_id || publishResult.id || publishResult.media_id;
    
    let permalink = publishResult.permalink;
    if (!permalink && publishedPostId && preview.type === 'post') {
      try {
        const fieldsResp = await fetch(`https://graph.instagram.com/v24.0/${publishedPostId}?fields=permalink,media_type,media_url`, {
          headers: { 'Authorization': `Bearer ${process.env.INSTAGRAM_ACCESS_TOKEN}` }
        });
        if (fieldsResp.ok) {
          const fields = await fieldsResp.json();
          permalink = fields.permalink || null;
        }
      } catch (e) {
        // Ignorar error al obtener permalink
      }
    }

    const updateData = {
      status: 'published',
      published_at: new Date().toISOString(),
      final_caption: caption || preview.final_caption,
      instagram_media_id: publishedPostId,
      instagram_url: permalink || null,
    };

    const { data: updatedPreview, error: updateError } = await supabase
      .from('instagram_previews')
      .update(updateData)
      .eq('id', preview.id)
      .select()
      .single();

    if (updateError) {
      console.error('Error actualizando preview:', updateError);
      return res.status(500).json({ 
        success: false,
        error: 'Error al actualizar preview: ' + updateError.message 
      });
    }

    if (preview.type === 'story' && publishedPostId) {
      try {
        const storyData = {
          media_id: publishedPostId,
          container_id: publishResult.media_id || publishedPostId,
          image_url: mediaUrl,
          media_type: 'IMAGE',
          status: 'published',
          ai_generated: true,
          ai_prompt: preview.topic || null,
          published_at: new Date().toISOString(),
          created_by: 'user',
        };

        await supabase
          .from('instagram_stories')
          .insert(storyData)
          .select()
          .single();
      } catch (storyError) {
        console.error('Error guardando story en instagram_stories:', storyError);
      }
    }

    if ((preview.type === 'post' || preview.type === 'reel') && publishedPostId) {
      try {
        let mediaInfo = {
          id: publishedPostId,
          media_type: preview.type === 'reel' ? 'VIDEO' : 'IMAGE',
          caption: caption || preview.final_caption || '',
          permalink: permalink,
          timestamp: new Date().toISOString()
        };

        try {
          const fieldsResp = await fetch(`https://graph.instagram.com/v24.0/${publishedPostId}?fields=media_type,media_url,caption,permalink,timestamp`, {
            headers: { 'Authorization': `Bearer ${process.env.INSTAGRAM_ACCESS_TOKEN}` }
          });
          if (fieldsResp.ok) {
            const fields = await fieldsResp.json();
            let mappedMediaType = mediaInfo.media_type;
            if (fields.media_type) {
              if (fields.media_type === 'REELS' || fields.media_type === 'VIDEO' || preview.type === 'reel') {
                mappedMediaType = 'VIDEO';
              } else {
                mappedMediaType = 'IMAGE';
              }
            }
            
            mediaInfo = {
              ...mediaInfo,
              media_type: mappedMediaType,
              media_url: fields.media_url || mediaUrl,
              caption: fields.caption || mediaInfo.caption,
              permalink: fields.permalink || mediaInfo.permalink,
              timestamp: fields.timestamp || mediaInfo.timestamp
            };
          }
        } catch (e) {
          mediaInfo.media_url = mediaUrl;
        }

        await getOrCreateInstagramPost(mediaInfo);
      } catch (postError) {
        console.error('Error guardando post en instagram_posts:', postError);
      }
    }

    res.json(updatedPreview);
  } catch (error) {
    console.error('Error en POST /api/preview/:id/publish:', error);
    res.status(500).json({ 
      success: false,
      error: error.message 
    });
  }
});

module.exports = router;


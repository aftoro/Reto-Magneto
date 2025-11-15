const express = require('express');
const { supabase } = require('../utils/functions');
const { rateLimitByIP } = require('../middlewares/rate-limit.middleware');

const router = express.Router();

// Rate limiting
router.use(rateLimitByIP({ maxRequests: 100, windowMs: 15 * 60 * 1000 })); // 100 requests por 15 min

/**
 * Obtener lista de stories
 * GET /api/stories?limit=20&offset=0&status=created
 */
router.get('/', async (req, res) => {
  try {
    const { limit = 20, offset = 0, status } = req.query;
    
    let query = supabase
      .from('instagram_stories')
      .select('*')
      .order('created_at', { ascending: false })
      .range(parseInt(offset), parseInt(offset) + parseInt(limit) - 1);

    // Filtrar por status si se proporciona
    if (status) {
      query = query.eq('status', status);
    }

    const { data: stories, error } = await query;

    if (error) {
      console.error('Error obteniendo stories:', error);
      return res.status(500).json({
        success: false,
        message: 'Error al obtener stories',
        error: error.message
      });
    }


    // Obtener total para paginación
    let countQuery = supabase
      .from('instagram_stories')
      .select('*', { count: 'exact', head: true });

    if (status) {
      countQuery = countQuery.eq('status', status);
    }

    const { count } = await countQuery;

    res.json({
      success: true,
      data: {
        stories: stories || [],
        total: count || 0,
        limit: parseInt(limit),
        offset: parseInt(offset)
      }
    });
  } catch (error) {
    console.error('Error en GET /api/stories:', error);
    res.status(500).json({
      success: false,
      message: 'Error al obtener stories',
      error: error.message
    });
  }
});

module.exports = router;

const express = require('express');
const { getPostsAnalytics, getDMAnalytics } = require('../utils/functions');
const { rateLimitByIP } = require('../middlewares/rate-limit.middleware');

const router = express.Router();

// Rate limiting
router.use(rateLimitByIP({ maxRequests: 50, windowMs: 15 * 60 * 1000 })); // 50 requests por 15 min

/**
 * Obtener analytics básicas
 * GET /api/analytics/basic
 */
router.get('/basic', async (req, res) => {
  try {
    // Obtener analytics de posts y DMs en paralelo
    const [postsAnalytics, dmAnalytics] = await Promise.all([
      getPostsAnalytics(),
      getDMAnalytics()
    ]);

    if (!postsAnalytics || !dmAnalytics) {
      return res.status(500).json({
        success: false,
        message: 'Error al obtener analytics',
      });
    }

    // Combinar analytics
    const analytics = {
      timestamp: new Date().toISOString(),
      dataRange: {
        postsAnalyzed: postsAnalytics.totalPosts || 0,
        conversationsAnalyzed: dmAnalytics.totalConversations || 0,
        period: 'Últimos 50 posts y 100 conversaciones'
      },
      posts: {
        summary: {
          totalPosts: postsAnalytics.totalPosts || 0,
          totalComments: postsAnalytics.totalComments || 0,
          totalLikes: 0, // Instagram no proporciona likes via API
          avgEngagement: postsAnalytics.avgEngagement || 0,
          aiResponses: postsAnalytics.aiResponses || 0,
          userComments: postsAnalytics.userComments || 0
        },
        topSectors: (postsAnalytics.topSectors || []).map(s => ({
          sector: s.sector,
          count: s.count
        })),
        topPositions: (postsAnalytics.topPositions || []).map(p => ({
          position: p.position,
          count: p.count
        })),
        recentPosts: (postsAnalytics.posts || []).slice(0, 5).map(post => ({
          id: post.id,
          caption: post.caption,
          comments: post.comments || 0,
          likes: 0,
          createdAt: post.created_at
        }))
      },
      conversations: {
        summary: {
          totalConversations: dmAnalytics.totalConversations || 0,
          activeConversations: dmAnalytics.activeConversations || 0,
          avgCompletion: dmAnalytics.avgCompletion || 0,
          messageStats: {
            total: dmAnalytics.totalMessages || 0,
            aiGenerated: dmAnalytics.aiMessages || 0,
            userGenerated: dmAnalytics.userMessages || 0,
            aiRatio: dmAnalytics.totalMessages > 0 
              ? Math.round((dmAnalytics.aiMessages / dmAnalytics.totalMessages) * 100)
              : 0
          }
        },
        topProfessions: (dmAnalytics.topProfessions || []).map(p => ({
          profession: p.profession,
          count: p.count
        })),
        topLocations: (dmAnalytics.topLocations || []).map(l => ({
          location: l.location,
          count: l.count
        })),
        experienceDistribution: (dmAnalytics.experienceDistribution || []).map(e => ({
          level: e.level,
          count: e.count
        }))
      },
      aiInsights: {
        marketTrends: {
          hotSectors: (postsAnalytics.topSectors || []).slice(0, 3).map(s => s.sector),
          demandPatterns: `Posts sobre ${postsAnalytics.topSectors?.[0]?.sector || 'tecnología'} tienen mayor engagement`,
          growthOpportunities: 'Contenido sobre sectores en crecimiento'
        },
        userBehavior: {
          engagementLevel: 'Alto en posts de tecnología',
          profileCompletion: `${dmAnalytics.avgCompletion || 0}% promedio`,
          interactionPatterns: 'Usuarios activos en DMs'
        },
        recommendations: [
          'Crear más contenido sobre sectores populares',
          'Mejorar onboarding para completar perfiles',
          'Enfocar contenido en usuarios activos'
        ],
        insights: [
          `${dmAnalytics.topLocations?.[0]?.location || 'Bogotá'} representa mayor porcentaje de usuarios`,
          'Posts con keywords específicas tienen mayor engagement',
          'Usuarios con perfiles completos tienen más conversaciones'
        ]
      }
    };

    res.json({
      success: true,
      message: 'Analytics básicas obtenidas exitosamente',
      analytics
    });
  } catch (error) {
    console.error('Error en GET /api/analytics/basic:', error);
    res.status(500).json({
      success: false,
      message: 'Error al obtener analytics básicas',
      error: error.message
    });
  }
});

module.exports = router;

const { supabase } = require('../config/database');
const PostLike = require('../models/PostLike');
const { v4: uuidv4 } = require('uuid');

/**
 * Repositorio de Likes de Posts de Instagram
 * Maneja todas las operaciones de base de datos relacionadas con likes
 */
class PostLikeRepository {
  constructor() {
    this.tableName = 'instagram_post_likes';
  }

  /**
   * Crea un nuevo like
   */
  async create(likeData) {
    try {
      const like = new PostLike({
        id: uuidv4(),
        ...likeData,
        createdAt: new Date()
      });

      const validation = like.validate();
      if (!validation.isValid) {
        throw new Error(`Datos de like inválidos: ${validation.errors.join(', ')}`);
      }

      const { data, error } = await supabase
        .from(this.tableName)
        .insert(like.toJson())
        .select()
        .single();

      if (error) {
        // Si el error es por duplicado, retornar el existente
        if (error.code === '23505') {
          return await this.findByPostAndUser(likeData.instagramPostId, likeData.instagramUserId);
        }
        throw error;
      }

      return PostLike.fromJson(data);
    } catch (error) {
      console.error('Error creating post like:', error);
      throw new Error(`Error al crear like: ${error.message}`);
    }
  }

  /**
   * Busca un like por ID
   */
  async findById(id) {
    try {
      const { data, error } = await supabase
        .from(this.tableName)
        .select('*')
        .eq('id', id)
        .single();

      if (error) {
        if (error.code === 'PGRST116') return null;
        throw error;
      }

      return PostLike.fromJson(data);
    } catch (error) {
      console.error('Error finding like by ID:', error);
      throw new Error(`Error al buscar like: ${error.message}`);
    }
  }

  /**
   * Busca un like por post y usuario
   */
  async findByPostAndUser(postId, userId) {
    try {
      const { data, error } = await supabase
        .from(this.tableName)
        .select('*')
        .eq('instagram_post_id', postId)
        .eq('instagram_user_id', userId)
        .single();

      if (error) {
        if (error.code === 'PGRST116') return null;
        throw error;
      }

      return PostLike.fromJson(data);
    } catch (error) {
      console.error('Error finding like by post and user:', error);
      throw new Error(`Error al buscar like: ${error.message}`);
    }
  }

  /**
   * Obtiene todos los likes de un usuario
   */
  async findByUserId(userId, options = {}) {
    try {
      const {
        page = 1,
        limit = 50,
        orderBy = 'timestamp',
        orderDirection = 'desc'
      } = options;

      const offset = (page - 1) * limit;

      const { data, error, count } = await supabase
        .from(this.tableName)
        .select('*', { count: 'exact' })
        .eq('instagram_user_id', userId)
        .order(orderBy, { ascending: orderDirection === 'asc' })
        .range(offset, offset + limit - 1);

      if (error) throw error;

      return {
        likes: data.map(like => PostLike.fromJson(like)),
        total: count,
        page,
        limit,
        totalPages: Math.ceil(count / limit)
      };
    } catch (error) {
      console.error('Error finding likes by user:', error);
      throw new Error(`Error al buscar likes del usuario: ${error.message}`);
    }
  }

  /**
   * Obtiene todos los likes de un post
   */
  async findByPostId(postId, options = {}) {
    try {
      const {
        page = 1,
        limit = 50,
        orderBy = 'timestamp',
        orderDirection = 'desc'
      } = options;

      const offset = (page - 1) * limit;

      const { data, error, count } = await supabase
        .from(this.tableName)
        .select('*', { count: 'exact' })
        .eq('instagram_post_id', postId)
        .order(orderBy, { ascending: orderDirection === 'asc' })
        .range(offset, offset + limit - 1);

      if (error) throw error;

      return {
        likes: data.map(like => PostLike.fromJson(like)),
        total: count,
        page,
        limit,
        totalPages: Math.ceil(count / limit)
      };
    } catch (error) {
      console.error('Error finding likes by post:', error);
      throw new Error(`Error al buscar likes del post: ${error.message}`);
    }
  }

  /**
   * Elimina un like
   */
  async delete(id) {
    try {
      const { error } = await supabase
        .from(this.tableName)
        .delete()
        .eq('id', id);

      if (error) throw error;
      return true;
    } catch (error) {
      console.error('Error deleting like:', error);
      throw new Error(`Error al eliminar like: ${error.message}`);
    }
  }

  /**
   * Elimina un like por post y usuario
   */
  async deleteByPostAndUser(postId, userId) {
    try {
      const { error } = await supabase
        .from(this.tableName)
        .delete()
        .eq('instagram_post_id', postId)
        .eq('instagram_user_id', userId);

      if (error) throw error;
      return true;
    } catch (error) {
      console.error('Error deleting like by post and user:', error);
      throw new Error(`Error al eliminar like: ${error.message}`);
    }
  }

  /**
   * Obtiene estadísticas de likes por usuario
   */
  async getUserLikeStats(userId) {
    try {
      const { data, error } = await supabase
        .from(this.tableName)
        .select('media_type, caption, timestamp')
        .eq('instagram_user_id', userId);

      if (error) throw error;

      const stats = {
        total: data.length,
        byMediaType: {},
        keywords: {},
        recentKeywords: []
      };

      // Analizar tipos de media
      data.forEach(like => {
        const type = like.media_type || 'UNKNOWN';
        stats.byMediaType[type] = (stats.byMediaType[type] || 0) + 1;
      });

      // Extraer keywords de los últimos 30 días
      const thirtyDaysAgo = new Date();
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

      data.forEach(like => {
        if (like.caption) {
          const likeInstance = PostLike.fromJson(like);
          const keywords = likeInstance.extractKeywords();
          
          keywords.forEach(keyword => {
            stats.keywords[keyword] = (stats.keywords[keyword] || 0) + 1;
            
            // Keywords recientes (últimos 30 días)
            if (like.timestamp && new Date(like.timestamp) > thirtyDaysAgo) {
              if (!stats.recentKeywords.includes(keyword)) {
                stats.recentKeywords.push(keyword);
              }
            }
          });
        }
      });

      // Ordenar keywords por frecuencia
      stats.topKeywords = Object.entries(stats.keywords)
        .sort((a, b) => b[1] - a[1])
        .slice(0, 20)
        .map(([keyword, count]) => ({ keyword, count }));

      return stats;
    } catch (error) {
      console.error('Error getting user like stats:', error);
      throw new Error(`Error al obtener estadísticas: ${error.message}`);
    }
  }

  /**
   * Obtiene los temas más populares basados en likes
   */
  async getPopularTopics(userId, limit = 10) {
    try {
      const stats = await this.getUserLikeStats(userId);
      return stats.topKeywords.slice(0, limit);
    } catch (error) {
      console.error('Error getting popular topics:', error);
      throw new Error(`Error al obtener temas populares: ${error.message}`);
    }
  }

  /**
   * Obtiene el conteo de likes de esta semana
   */
  async getWeeklyLikesCount() {
    try {
      const now = new Date();
      const weekAgo = new Date(now);
      weekAgo.setDate(weekAgo.getDate() - 7);

      const { count, error } = await supabase
        .from(this.tableName)
        .select('*', { count: 'exact', head: true })
        .gte('timestamp', weekAgo.toISOString())
        .lte('timestamp', now.toISOString());

      if (error) throw error;

      return count || 0;
    } catch (error) {
      console.error('Error getting weekly likes count:', error);
      throw new Error(`Error al obtener conteo de likes semanales: ${error.message}`);
    }
  }

  /**
   * Obtiene el conteo de likes por post
   * NOTA: El endpoint /likes está deprecado. Esta función ahora obtiene
   * el conteo desde Instagram API usando like_count
   */
  async getLikesCountByPost(postId) {
    try {
      const { getInstagramPostLikeCount } = require('../utils/functions');
      return await getInstagramPostLikeCount(postId);
    } catch (error) {
      console.error('Error getting likes count by post:', error);
      throw new Error(`Error al obtener conteo de likes del post: ${error.message}`);
    }
  }

  /**
   * Obtiene el conteo de likes para múltiples posts
   * NOTA: El endpoint /likes está deprecado. Esta función ahora obtiene
   * los conteos desde Instagram API usando like_count
   */
  async getLikesCountByPosts(postIds) {
    try {
      if (!postIds || postIds.length === 0) {
        return {};
      }

      const { getInstagramPostLikeCount } = require('../utils/functions');
      const counts = {};
      
      // Inicializar todos los posts con 0
      postIds.forEach(postId => {
        counts[postId] = 0;
      });

      // Obtener like_count desde Instagram API para cada post
      await Promise.all(
        postIds.map(async (postId) => {
          try {
            const likeCount = await getInstagramPostLikeCount(postId);
            counts[postId] = likeCount;
          } catch (error) {
            console.warn(`No se pudo obtener like_count para post ${postId}:`, error.message);
            counts[postId] = 0;
          }
        })
      );

      return counts;
    } catch (error) {
      console.error('Error getting likes count by posts:', error);
      throw new Error(`Error al obtener conteo de likes de posts: ${error.message}`);
    }
  }
}

module.exports = PostLikeRepository;

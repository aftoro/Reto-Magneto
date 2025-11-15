const PostLikeRepository = require('../repositories/PostLikeRepository');
const { getGeminiClient } = require('../utils/functions');

/**
 * Servicio de Preferencias de Usuario
 * Analiza los gustos del usuario basándose en los likes de Instagram
 */
class UserPreferencesService {
  constructor() {
    this.postLikeRepository = new PostLikeRepository();
  }

  /**
   * Analiza los gustos del usuario basándose en sus likes
   */
  async analyzeUserPreferences(userId) {
    try {
      const stats = await this.postLikeRepository.getUserLikeStats(userId);
      
      if (stats.total === 0) {
        return {
          hasPreferences: false,
          message: 'No hay suficientes likes para analizar preferencias'
        };
      }

      const preferences = {
        totalLikes: stats.total,
        preferredMediaTypes: this._getPreferredMediaTypes(stats.byMediaType),
        topInterests: stats.topKeywords,
        recentInterests: stats.recentKeywords,
        preferencesSummary: this._generatePreferencesSummary(stats)
      };

      return {
        hasPreferences: true,
        preferences
      };
    } catch (error) {
      console.error('Error analyzing user preferences:', error);
      throw error;
    }
  }

  /**
   * Genera un resumen de preferencias usando IA
   */
  async generateAIPreferencesSummary(userId) {
    try {
      const stats = await this.postLikeRepository.getUserLikeStats(userId);
      
      if (stats.total === 0) {
        return 'No hay suficientes datos para generar un resumen de preferencias.';
      }

      const prompt = this._buildPreferencesPrompt(stats);
      const geminiClient = getGeminiClient();
      const model = geminiClient.getGenerativeModel({ model: 'gemini-2.5-flash' });

      const result = await model.generateContent(prompt);
      const response = await result.response;
      const summary = response.text();

      return summary;
    } catch (error) {
      console.error('Error generating AI preferences summary:', error);
      // Si falla la IA, retornar resumen básico
      const stats = await this.postLikeRepository.getUserLikeStats(userId);
      return this._generatePreferencesSummary(stats);
    }
  }

  /**
   * Obtiene el contexto de preferencias para usar en respuestas de IA
   */
  async getUserPreferencesContext(userId) {
    try {
      const stats = await this.postLikeRepository.getUserLikeStats(userId);
      
      if (stats.total === 0) {
        return null;
      }

      const context = {
        totalLikes: stats.total,
        topInterests: stats.topKeywords.slice(0, 10).map(k => k.keyword),
        preferredMediaTypes: Object.keys(stats.byMediaType).sort(
          (a, b) => stats.byMediaType[b] - stats.byMediaType[a]
        ).slice(0, 3),
        recentInterests: stats.recentKeywords.slice(0, 5)
      };

      return this._formatContextForAI(context);
    } catch (error) {
      console.error('Error getting user preferences context:', error);
      return null;
    }
  }

  /**
   * Formatea el contexto para usar en prompts de IA
   */
  _formatContextForAI(context) {
    const interests = context.topInterests.join(', ');
    const mediaTypes = context.preferredMediaTypes.join(', ');
    const recent = context.recentInterests.join(', ');

    return `
CONTEXTO DE PREFERENCIAS DEL USUARIO:
- Total de posts que le gustan: ${context.totalLikes}
- Intereses principales: ${interests}
- Tipos de contenido preferidos: ${mediaTypes}
- Intereses recientes: ${recent}

Usa esta información para personalizar tus respuestas y sugerencias de contenido.
Cuando generes contenido, considera estos intereses y tipos de media preferidos.
`;
  }

  /**
   * Construye el prompt para la IA
   */
  _buildPreferencesPrompt(stats) {
    const topKeywords = stats.topKeywords.slice(0, 15).map(k => `- ${k.keyword} (${k.count} veces)`).join('\n');
    const mediaTypes = Object.entries(stats.byMediaType)
      .map(([type, count]) => `- ${type}: ${count} likes`)
      .join('\n');

    return `Analiza las preferencias de un usuario de Instagram basándote en los posts que le ha dado like:

ESTADÍSTICAS:
- Total de likes: ${stats.total}
- Tipos de contenido preferidos:
${mediaTypes}

PALABRAS CLAVE MÁS FRECUENTES:
${topKeywords}

INTERESES RECIENTES (últimos 30 días):
${stats.recentKeywords.slice(0, 10).join(', ')}

Genera un resumen conciso (2-3 párrafos) sobre los gustos y preferencias de este usuario. 
Incluye:
1. Sus principales intereses y temas favoritos
2. Tipos de contenido que prefiere (imágenes, videos, etc.)
3. Tendencias recientes en sus gustos
4. Sugerencias sobre qué tipo de contenido podría interesarle

Responde en español de manera natural y conversacional.`;
  }

  /**
   * Genera un resumen básico de preferencias sin IA
   */
  _generatePreferencesSummary(stats) {
    const topInterests = stats.topKeywords.slice(0, 5).map(k => k.keyword).join(', ');
    const topMediaType = Object.entries(stats.byMediaType)
      .sort((a, b) => b[1] - a[1])[0]?.[0] || 'N/A';

    return `El usuario ha dado like a ${stats.total} posts. Sus intereses principales incluyen: ${topInterests}. 
    Prefiere contenido tipo ${topMediaType}.`;
  }

  /**
   * Obtiene los tipos de media preferidos
   */
  _getPreferredMediaTypes(byMediaType) {
    return Object.entries(byMediaType)
      .sort((a, b) => b[1] - a[1])
      .map(([type, count]) => ({ type, count }));
  }

  /**
   * Verifica si un usuario tiene suficientes datos para análisis
   */
  async hasEnoughData(userId, minLikes = 5) {
    try {
      const stats = await this.postLikeRepository.getUserLikeStats(userId);
      return stats.total >= minLikes;
    } catch (error) {
      console.error('Error checking if user has enough data:', error);
      return false;
    }
  }

  /**
   * Obtiene recomendaciones de contenido basadas en preferencias
   */
  async getContentRecommendations(userId) {
    try {
      const stats = await this.postLikeRepository.getUserLikeStats(userId);
      
      if (stats.total < 5) {
        return {
          hasRecommendations: false,
          message: 'Se necesitan más likes para generar recomendaciones'
        };
      }

      const recommendations = {
        suggestedTopics: stats.topKeywords.slice(0, 5).map(k => k.keyword),
        preferredMediaType: Object.entries(stats.byMediaType)
          .sort((a, b) => b[1] - a[1])[0]?.[0],
        trendingInterests: stats.recentKeywords.slice(0, 3)
      };

      return {
        hasRecommendations: true,
        recommendations
      };
    } catch (error) {
      console.error('Error getting content recommendations:', error);
      throw error;
    }
  }
}

module.exports = UserPreferencesService;

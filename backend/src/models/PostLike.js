/**
 * Modelo de Like de Post de Instagram
 * Representa un like dado a un post de Instagram por un usuario
 */
class PostLike {
  constructor({
    id,
    instagramPostId,
    instagramUserId,
    username,
    mediaType,
    mediaUrl,
    caption,
    timestamp,
    createdAt,
    metadata = {}
  }) {
    this.id = id;
    this.instagramPostId = instagramPostId;
    this.instagramUserId = instagramUserId;
    this.username = username;
    this.mediaType = mediaType; // 'IMAGE', 'VIDEO', 'CAROUSEL_ALBUM'
    this.mediaUrl = mediaUrl;
    this.caption = caption;
    this.timestamp = timestamp;
    this.createdAt = createdAt;
    this.metadata = metadata;
  }

  /**
   * Crea una instancia de PostLike desde un objeto JSON
   */
  static fromJson(json) {
    return new PostLike({
      id: json.id,
      instagramPostId: json.instagram_post_id,
      instagramUserId: json.instagram_user_id,
      username: json.username,
      mediaType: json.media_type,
      mediaUrl: json.media_url,
      caption: json.caption,
      timestamp: json.timestamp ? new Date(json.timestamp) : null,
      createdAt: json.created_at ? new Date(json.created_at) : null,
      metadata: json.metadata || {}
    });
  }

  /**
   * Convierte la instancia a JSON para almacenamiento
   */
  toJson() {
    return {
      id: this.id,
      instagram_post_id: this.instagramPostId,
      instagram_user_id: this.instagramUserId,
      username: this.username,
      media_type: this.mediaType,
      media_url: this.mediaUrl,
      caption: this.caption,
      timestamp: this.timestamp?.toISOString(),
      created_at: this.createdAt?.toISOString(),
      metadata: this.metadata
    };
  }

  /**
   * Valida los datos del like
   */
  validate() {
    const errors = [];

    if (!this.instagramPostId) errors.push('ID de post de Instagram es requerido');
    if (!this.instagramUserId) errors.push('ID de usuario de Instagram es requerido');
    if (!this.timestamp) errors.push('Timestamp es requerido');

    return {
      isValid: errors.length === 0,
      errors
    };
  }

  /**
   * Extrae palabras clave del caption para análisis
   */
  extractKeywords() {
    if (!this.caption) return [];
    
    // Remover hashtags y menciones, convertir a minúsculas
    const text = this.caption
      .replace(/#\w+/g, '')
      .replace(/@\w+/g, '')
      .toLowerCase();
    
    // Palabras comunes a ignorar
    const stopWords = ['el', 'la', 'de', 'que', 'y', 'a', 'en', 'un', 'es', 'se', 'no', 'te', 'lo', 'le', 'da', 'su', 'por', 'son', 'con', 'para', 'del', 'los', 'las', 'una', 'como', 'pero', 'sus', 'más', 'muy', 'sin', 'sobre', 'también', 'me', 'ya', 'todo', 'esta', 'entre', 'cuando', 'todo', 'esta', 'ser', 'son', 'dos', 'también', 'fue', 'había', 'era', 'muy', 'años', 'hasta', 'desde', 'está', 'mi', 'porque', 'qué', 'sólo', 'han', 'yo', 'hay', 'vez', 'puede', 'todos', 'así', 'nos', 'ni', 'parte', 'tiene', 'él', 'uno', 'donde', 'bien', 'tiempo', 'mismo', 'ese', 'ahora', 'cada', 'e', 'vida', 'otro', 'después', 'te', 'otros', 'aunque', 'esas', 'esos', 'estas', 'estos', 'estas', 'estos', 'estas', 'estos'];
    
    // Extraer palabras de 3+ caracteres
    const words = text
      .split(/\s+/)
      .filter(word => word.length >= 3 && !stopWords.includes(word));
    
    return [...new Set(words)]; // Eliminar duplicados
  }

  /**
   * Retorna una copia del like para respuesta
   */
  toResponseJson() {
    return {
      id: this.id,
      instagramPostId: this.instagramPostId,
      instagramUserId: this.instagramUserId,
      username: this.username,
      mediaType: this.mediaType,
      mediaUrl: this.mediaUrl,
      caption: this.caption,
      timestamp: this.timestamp,
      keywords: this.extractKeywords()
    };
  }
}

module.exports = PostLike;

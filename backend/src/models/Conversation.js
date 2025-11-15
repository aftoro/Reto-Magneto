/**
 * Modelo de Conversación
 * Representa una conversación en el sistema
 */
class Conversation {
  constructor({
    id,
    userId,
    title,
    lastMessage,
    lastMessageAt,
    messageCount = 0,
    isActive = true,
    metadata = {},
    createdAt,
    updatedAt
  }) {
    this.id = id;
    this.userId = userId;
    this.title = title;
    this.lastMessage = lastMessage;
    this.lastMessageAt = lastMessageAt;
    this.messageCount = messageCount;
    this.isActive = isActive;
    this.metadata = metadata;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
  }

  /**
   * Crea una instancia de Conversation desde un objeto JSON
   */
  static fromJson(json) {
    return new Conversation({
      id: json.id,
      userId: json.user_id,
      title: json.title,
      lastMessage: json.last_message,
      lastMessageAt: json.last_message_at ? new Date(json.last_message_at) : null,
      messageCount: json.message_count || 0,
      isActive: json.is_active !== false,
      metadata: json.metadata || {},
      createdAt: json.created_at ? new Date(json.created_at) : null,
      updatedAt: json.updated_at ? new Date(json.updated_at) : null
    });
  }

  /**
   * Convierte la instancia a JSON para almacenamiento
   */
  toJson() {
    return {
      id: this.id,
      user_id: this.userId,
      title: this.title,
      last_message: this.lastMessage,
      last_message_at: this.lastMessageAt?.toISOString(),
      message_count: this.messageCount,
      is_active: this.isActive,
      metadata: this.metadata,
      created_at: this.createdAt?.toISOString(),
      updated_at: this.updatedAt?.toISOString()
    };
  }

  /**
   * Valida los datos de la conversación
   */
  validate() {
    const errors = [];

    if (!this.id) errors.push('ID es requerido');
    if (!this.userId) errors.push('ID de usuario es requerido');
    if (this.title && this.title.trim().length < 1) {
      errors.push('Título no puede estar vacío');
    }

    return {
      isValid: errors.length === 0,
      errors
    };
  }

  /**
   * Actualiza el último mensaje de la conversación
   */
  updateLastMessage(message, messageAt = new Date()) {
    this.lastMessage = message;
    this.lastMessageAt = messageAt;
    this.messageCount += 1;
    this.updatedAt = new Date();
  }

  /**
   * Marca la conversación como inactiva
   */
  deactivate() {
    this.isActive = false;
    this.updatedAt = new Date();
  }

  /**
   * Marca la conversación como activa
   */
  activate() {
    this.isActive = true;
    this.updatedAt = new Date();
  }

  /**
   * Actualiza el título de la conversación
   */
  updateTitle(newTitle) {
    this.title = newTitle;
    this.updatedAt = new Date();
  }

  /**
   * Agrega metadatos a la conversación
   */
  addMetadata(key, value) {
    this.metadata[key] = value;
    this.updatedAt = new Date();
  }

  /**
   * Retorna una copia de la conversación para respuesta
   */
  toResponseJson() {
    return {
      id: this.id,
      userId: this.userId,
      title: this.title,
      lastMessage: this.lastMessage,
      lastMessageAt: this.lastMessageAt,
      messageCount: this.messageCount,
      isActive: this.isActive,
      createdAt: this.createdAt
    };
  }
}

module.exports = Conversation;

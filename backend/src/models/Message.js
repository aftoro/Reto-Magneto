/**
 * Modelo de Mensaje
 * Representa un mensaje en el sistema de chat
 */
class Message {
  constructor({
    id,
    conversationId,
    userId,
    content,
    messageType = 'text',
    mediaUrl,
    metadata = {},
    isFromAI = false,
    createdAt,
    updatedAt,
    isProcessed = false
  }) {
    this.id = id;
    this.conversationId = conversationId;
    this.userId = userId;
    this.content = content;
    this.messageType = messageType;
    this.mediaUrl = mediaUrl;
    this.metadata = metadata;
    this.isFromAI = isFromAI;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
    this.isProcessed = isProcessed;
  }

  /**
   * Crea una instancia de Message desde un objeto JSON
   * Campos de la tabla mensajes:
   * - id, conversacion_id, platform_message_id, content, message_type
   * - media_context (jsonb), is_ai_generated, ai_model
   * - created_at, sent_at, delivery_status, author_name, author_type
   */
  static fromJson(json) {
    // Los campos adicionales están directamente en la BD, no en metadata
    const metadata = json.metadata || {};
    
    // Incluir campos de la tabla en metadata para acceso fácil
    if (json.platform_message_id) metadata.platform_message_id = json.platform_message_id;
    if (json.author_name) metadata.author_name = json.author_name;
    if (json.author_type) metadata.author_type = json.author_type;
    if (json.delivery_status) metadata.delivery_status = json.delivery_status;
    if (json.ai_model) metadata.ai_model = json.ai_model;
    if (json.sent_at) metadata.sent_at = json.sent_at;
    if (json.media_context) metadata.media_context = json.media_context;

    return new Message({
      id: json.id,
      conversationId: json.conversacion_id,
      userId: null, // No existe user_id en la tabla mensajes
      content: json.content,
      messageType: json.message_type || 'text',
      mediaUrl: null, // No existe media_url, se usa media_context (jsonb)
      metadata: metadata,
      isFromAI: json.is_ai_generated || false,
      createdAt: json.created_at ? new Date(json.created_at) : null,
      updatedAt: null, // No existe updated_at en la tabla mensajes
      isProcessed: false // Campo interno, no existe en BD
    });
  }

  /**
   * Convierte la instancia a JSON para almacenamiento
   * Solo incluye campos que existen en la tabla mensajes:
   * - id, conversacion_id, platform_message_id, content, message_type
   * - media_context (jsonb), is_ai_generated, ai_model
   * - created_at, sent_at, delivery_status, author_name, author_type
   */
  toJson() {
    const json = {
      // Campos principales
      id: this.id,
      conversacion_id: this.conversationId,
      content: this.content,
      message_type: this.messageType,
      is_ai_generated: this.isFromAI,
    };
    
    // Campos opcionales que existen en la tabla
    if (this.metadata?.platform_message_id) {
      json.platform_message_id = this.metadata.platform_message_id;
    }
    if (this.metadata?.media_context) {
      json.media_context = this.metadata.media_context;
    }
    if (this.metadata?.ai_model) {
      json.ai_model = this.metadata.ai_model;
    }
    if (this.metadata?.author_name) {
      json.author_name = this.metadata.author_name;
    }
    if (this.metadata?.author_type) {
      json.author_type = this.metadata.author_type;
    }
    if (this.metadata?.delivery_status) {
      json.delivery_status = this.metadata.delivery_status;
    }
    if (this.metadata?.sent_at) {
      json.sent_at = this.metadata.sent_at instanceof Date 
        ? this.metadata.sent_at.toISOString() 
        : this.metadata.sent_at;
    }
    if (this.createdAt) {
      json.created_at = this.createdAt.toISOString();
    }
    
    // No incluir campos que no existen en la tabla:
    // - user_id (no existe)
    // - media_url (no existe, se usa media_context)
    // - updated_at (no existe)
    // - is_processed (no existe)
    // - metadata completo (los campos están directamente en la tabla)
    
    return json;
  }

  /**
   * Valida los datos del mensaje
   */
  validate() {
    const errors = [];

    if (!this.conversationId) errors.push('ID de conversación es requerido');
    // user_id no existe en la tabla, no validar
    if (!this.content && !this.metadata?.media_context) {
      errors.push('Contenido o media_context es requerido');
    }
    if (this.messageType && !this.isValidMessageType(this.messageType)) {
      errors.push('Tipo de mensaje inválido');
    }

    return {
      isValid: errors.length === 0,
      errors
    };
  }

  /**
   * Valida el tipo de mensaje
   * Acepta tipos de contenido (text, image, video, audio, file) 
   * y tipos de dirección (incoming, outgoing)
   */
  isValidMessageType(type) {
    const validContentTypes = ['text', 'image', 'video', 'audio', 'file'];
    const validDirectionTypes = ['incoming', 'outgoing'];
    return validContentTypes.includes(type) || validDirectionTypes.includes(type);
  }

  /**
   * Marca el mensaje como procesado
   */
  markAsProcessed() {
    this.isProcessed = true;
    this.updatedAt = new Date();
  }

  /**
   * Actualiza el contenido del mensaje
   */
  updateContent(newContent) {
    this.content = newContent;
    this.updatedAt = new Date();
  }

  /**
   * Agrega metadatos al mensaje
   */
  addMetadata(key, value) {
    this.metadata[key] = value;
    this.updatedAt = new Date();
  }

  /**
   * Retorna una copia del mensaje para respuesta
   * Formato snake_case para compatibilidad con el frontend
   * Incluye todos los campos de la tabla mensajes más campos adicionales para compatibilidad
   */
  toResponseJson() {
    return {
      // Campos principales de la tabla
      id: this.id,
      conversacion_id: this.conversationId,
      content: this.content,
      message_type: this.messageType,
      is_ai_generated: this.isFromAI,
      is_from_ai: this.isFromAI, // Alias para compatibilidad
      
      // Campos opcionales de la tabla
      platform_message_id: this.metadata?.platform_message_id || null,
      media_context: this.metadata?.media_context || null,
      ai_model: this.metadata?.ai_model || null,
      author_name: this.metadata?.author_name || null,
      author_type: this.metadata?.author_type || null,
      delivery_status: this.metadata?.delivery_status || null,
      sent_at: this.metadata?.sent_at 
        ? (this.metadata.sent_at instanceof Date ? this.metadata.sent_at.toISOString() : this.metadata.sent_at)
        : null,
      created_at: this.createdAt 
        ? (this.createdAt instanceof Date ? this.createdAt.toISOString() : this.createdAt)
        : null,
      
      // Campos adicionales para compatibilidad (no existen en BD pero el frontend puede esperarlos)
      user_id: this.userId || null,
      media_url: this.mediaUrl || null,
      updated_at: this.updatedAt 
        ? (this.updatedAt instanceof Date ? this.updatedAt.toISOString() : this.updatedAt)
        : null,
      is_processed: this.isProcessed
    };
  }
}

module.exports = Message;

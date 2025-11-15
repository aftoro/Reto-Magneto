const MessageRepository = require('../repositories/MessageRepository');
const Message = require('../models/Message');
const { v4: uuidv4 } = require('uuid');
const { supabase } = require('../utils');
const { sendInstagramDMReply, convertToInstagramFormat } = require('../utils');

/**
 * Servicio de Mensajes
 * Contiene la lógica de negocio para operaciones de mensajes
 */
class MessageService {
  constructor() {
    this.messageRepository = new MessageRepository();
  }

  /**
   * Crea un nuevo mensaje
   */
  async createMessage({
    conversationId,
    userId,
    content,
    messageType = 'text',
    mediaUrl = null,
    isFromAI = false,
    metadata = {}
  }) {
    try {
      const message = new Message({
        id: uuidv4(),
        conversationId,
        userId,
        content,
        messageType,
        mediaUrl,
        metadata,
        isFromAI,
        createdAt: new Date(),
        updatedAt: new Date(),
        isProcessed: false
      });

      // Validar el mensaje
      const validation = message.validate();
      if (!validation.isValid) {
        throw new Error(`Datos de mensaje inválidos: ${validation.errors.join(', ')}`);
      }

      // Guardar mensaje en BD
      const createdMessage = await this.messageRepository.create(message);
      
      console.log('📝 [MessageService] Mensaje creado en BD:', {
        id: createdMessage.id,
        messageType,
        conversationId,
        contentLength: content.length
      });
      
      // Si el mensaje es saliente (outgoing) y es de Instagram, enviarlo a Instagram
      if (messageType === 'outgoing') {
        console.log('📤 [MessageService] Mensaje es outgoing, intentando enviar a Instagram...');
        try {
          // Obtener información de la conversación para obtener el user_id de Instagram
          console.log('🔍 [MessageService] Obteniendo información de conversación:', conversationId);
          const { data: conversation, error: convError } = await supabase
            .from('conversaciones')
            .select('user_id, platform, conversation_type')
            .eq('id', conversationId)
            .single();

          console.log('📋 [MessageService] Resultado de consulta de conversación:', {
            found: !!conversation,
            error: convError?.message,
            platform: conversation?.platform,
            conversation_type: conversation?.conversation_type,
            user_id: conversation?.user_id
          });

          if (!convError && conversation) {
            // Solo enviar si es una conversación de Instagram DM
            if (conversation.platform === 'instagram' && conversation.conversation_type === 'dm') {
              const instagramUserId = conversation.user_id;
              
              if (instagramUserId) {
                console.log('📤 [MessageService] Enviando mensaje a Instagram DM:', {
                  conversationId,
                  instagramUserId,
                  content: content.substring(0, 50) + '...'
                });

                // Convertir formato para Instagram (si es necesario)
                const formattedContent = convertToInstagramFormat ? convertToInstagramFormat(content) : content;
                console.log('📝 [MessageService] Contenido formateado:', formattedContent.substring(0, 50) + '...');
                
                // Enviar mensaje a Instagram
                const sendResult = await sendInstagramDMReply(instagramUserId, formattedContent);
                console.log('📬 [MessageService] Resultado del envío a Instagram:', {
                  success: sendResult.success,
                  error: sendResult.error,
                  resultsCount: sendResult.results?.length
                });
                
                if (sendResult.success) {
                  console.log('✅ [MessageService] Mensaje enviado exitosamente a Instagram');
                  
                  // Actualizar el mensaje con el platform_message_id si está disponible
                  if (sendResult.results && sendResult.results.length > 0) {
                    const platformMessageId = sendResult.results[0].message_id;
                    if (platformMessageId) {
                      console.log('💾 [MessageService] Actualizando mensaje con platform_message_id:', platformMessageId);
                      // Actualizar mensaje con platform_message_id y delivery_status
                      const updatedMessage = await this.messageRepository.update(createdMessage.id, {
                        platform_message_id: platformMessageId,
                        delivery_status: 'sent',
                        sent_at: new Date().toISOString()
                      });
                      
                      return updatedMessage.toResponseJson();
                    }
                  }
                  
                  // Si no hay message_id pero fue exitoso, actualizar solo el estado
                  console.log('💾 [MessageService] Actualizando mensaje con estado sent (sin platform_message_id)');
                  const updatedMessage = await this.messageRepository.update(createdMessage.id, {
                    delivery_status: 'sent',
                    sent_at: new Date().toISOString()
                  });
                  
                  return updatedMessage.toResponseJson();
                } else {
                  console.error('❌ [MessageService] Error enviando mensaje a Instagram:', sendResult.error);
                  
                  // Actualizar mensaje con estado de error
                  const updatedMessage = await this.messageRepository.update(createdMessage.id, {
                    delivery_status: 'failed'
                  });
                  
                  return updatedMessage.toResponseJson();
                }
              } else {
                console.warn('⚠️ [MessageService] No se encontró user_id de Instagram en la conversación');
              }
            } else {
              console.log('ℹ️ [MessageService] Conversación no es de Instagram DM:', {
                platform: conversation.platform,
                conversation_type: conversation.conversation_type
              });
            }
          } else {
            console.warn('⚠️ [MessageService] No se pudo obtener información de la conversación:', convError?.message);
          }
        } catch (sendError) {
          console.error('❌ [MessageService] Error al enviar mensaje a Instagram:', sendError);
          console.error('   Stack:', sendError.stack);
          // Continuar y retornar el mensaje creado aunque falle el envío
        }
      } else {
        console.log('ℹ️ [MessageService] Mensaje no es outgoing, no se enviará a Instagram. messageType:', messageType);
      }

      return createdMessage.toResponseJson();
    } catch (error) {
      console.error('Error creating message:', error);
      throw error;
    }
  }

  /**
   * Obtiene mensajes de una conversación
   */
  async getMessagesByConversation(conversationId, options = {}) {
    try {
      console.log('📨 [MessageService] Obteniendo mensajes para conversación:', conversationId);
      console.log('   Opciones:', options);
      
      const result = await this.messageRepository.findByConversationId(conversationId, options);
      
      console.log('✅ [MessageService] Resultado del repositorio:');
      console.log('   Total mensajes:', result.messages?.length || 0);
      console.log('   Total en BD:', result.total);
      
      const responseMessages = result.messages.map(message => {
        try {
          const json = message.toResponseJson();
          return json;
        } catch (parseError) {
          console.error('⚠️ [MessageService] Error al convertir mensaje a JSON:', parseError);
          return null;
        }
      }).filter(msg => msg !== null);
      
      console.log('✅ [MessageService] Mensajes convertidos a JSON:', responseMessages.length);
      
      return {
        ...result,
        messages: responseMessages
      };
    } catch (error) {
      console.error('❌ [MessageService] Error getting messages by conversation:', error);
      throw error;
    }
  }

  /**
   * Obtiene mensajes de un usuario
   */
  async getMessagesByUser(userId, options = {}) {
    try {
      const result = await this.messageRepository.findByUserId(userId, options);
      return {
        ...result,
        messages: result.messages.map(message => message.toResponseJson())
      };
    } catch (error) {
      console.error('Error getting messages by user:', error);
      throw error;
    }
  }

  /**
   * Obtiene un mensaje por ID
   */
  async getMessageById(id) {
    try {
      const message = await this.messageRepository.findById(id);
      if (!message) {
        throw new Error('Mensaje no encontrado');
      }
      return message.toResponseJson();
    } catch (error) {
      console.error('Error getting message by ID:', error);
      throw error;
    }
  }

  /**
   * Actualiza un mensaje
   */
  async updateMessage(id, updateData) {
    try {
      const message = await this.messageRepository.findById(id);
      if (!message) {
        throw new Error('Mensaje no encontrado');
      }

      // Validar datos de actualización
      const allowedFields = ['content', 'mediaUrl', 'metadata'];
      const filteredData = {};
      
      allowedFields.forEach(field => {
        if (updateData[field] !== undefined) {
          filteredData[field] = updateData[field];
        }
      });

      if (Object.keys(filteredData).length === 0) {
        throw new Error('No hay datos válidos para actualizar');
      }

      const updatedMessage = await this.messageRepository.update(id, {
        ...filteredData,
        updated_at: new Date().toISOString()
      });

      return updatedMessage.toResponseJson();
    } catch (error) {
      console.error('Error updating message:', error);
      throw error;
    }
  }

  /**
   * Elimina un mensaje
   */
  async deleteMessage(id) {
    try {
      const message = await this.messageRepository.findById(id);
      if (!message) {
        throw new Error('Mensaje no encontrado');
      }

      await this.messageRepository.delete(id);
      return true;
    } catch (error) {
      console.error('Error deleting message:', error);
      throw error;
    }
  }

  /**
   * Marca un mensaje como procesado
   */
  async markMessageAsProcessed(id) {
    try {
      const message = await this.messageRepository.findById(id);
      if (!message) {
        throw new Error('Mensaje no encontrado');
      }

      const updatedMessage = await this.messageRepository.markAsProcessed(id);
      return updatedMessage.toResponseJson();
    } catch (error) {
      console.error('Error marking message as processed:', error);
      throw error;
    }
  }

  /**
   * Obtiene mensajes no procesados
   */
  async getUnprocessedMessages(limit = 100) {
    try {
      const messages = await this.messageRepository.findUnprocessed(limit);
      return messages.map(message => message.toResponseJson());
    } catch (error) {
      console.error('Error getting unprocessed messages:', error);
      throw error;
    }
  }

  /**
   * Busca mensajes por contenido
   */
  async searchMessages(searchTerm, options = {}) {
    try {
      if (!searchTerm || searchTerm.trim().length < 2) {
        throw new Error('El término de búsqueda debe tener al menos 2 caracteres');
      }

      const result = await this.messageRepository.searchByContent(searchTerm, options);
      return {
        ...result,
        messages: result.messages.map(message => message.toResponseJson())
      };
    } catch (error) {
      console.error('Error searching messages:', error);
      throw error;
    }
  }

  /**
   * Obtiene mensajes por tipo
   */
  async getMessagesByType(messageType, options = {}) {
    try {
      const result = await this.messageRepository.findByType(messageType, options);
      return {
        ...result,
        messages: result.messages.map(message => message.toResponseJson())
      };
    } catch (error) {
      console.error('Error getting messages by type:', error);
      throw error;
    }
  }

  /**
   * Obtiene estadísticas de mensajes
   */
  async getMessageStats(userId = null) {
    try {
      const stats = await this.messageRepository.getStats(userId);
      return stats;
    } catch (error) {
      console.error('Error getting message stats:', error);
      throw error;
    }
  }

  /**
   * Procesa mensajes en lote
   */
  async processBatchMessages(messageIds, processor) {
    try {
      const results = [];
      
      for (const messageId of messageIds) {
        try {
          const message = await this.messageRepository.findById(messageId);
          if (!message) {
            results.push({ id: messageId, success: false, error: 'Mensaje no encontrado' });
            continue;
          }

          // Procesar el mensaje
          const processedData = await processor(message);
          
          // Actualizar el mensaje con los datos procesados
          if (processedData) {
            await this.messageRepository.update(messageId, {
              ...processedData,
              updated_at: new Date().toISOString()
            });
          } else {
            // Solo actualizar updated_at ya que is_processed no existe en la tabla
            await this.messageRepository.markAsProcessed(messageId);
          }

          results.push({ id: messageId, success: true });
        } catch (error) {
          console.error(`Error processing message ${messageId}:`, error);
          results.push({ id: messageId, success: false, error: error.message });
        }
      }

      return results;
    } catch (error) {
      console.error('Error processing batch messages:', error);
      throw error;
    }
  }

  /**
   * Obtiene el historial de mensajes para AI
   */
  async getMessageHistoryForAI(conversationId, limit = 10) {
    try {
      const result = await this.messageRepository.findByConversationId(conversationId, {
        limit,
        orderBy: 'created_at',
        orderDirection: 'desc'
      });

      // Formatear mensajes para AI
      const formattedMessages = result.messages.map(message => ({
        role: message.isFromAI ? 'assistant' : 'user',
        content: message.content,
        timestamp: message.createdAt
      }));

      return formattedMessages.reverse(); // Ordenar cronológicamente
    } catch (error) {
      console.error('Error getting message history for AI:', error);
      throw error;
    }
  }

  /**
   * Crea un mensaje de respuesta de AI
   */
  async createAIResponse(conversationId, userId, content, metadata = {}) {
    try {
      return await this.createMessage({
        conversationId,
        userId,
        content,
        messageType: 'text',
        isFromAI: true,
        metadata: {
          ...metadata,
          aiGenerated: true,
          timestamp: new Date().toISOString()
        }
      });
    } catch (error) {
      console.error('Error creating AI response:', error);
      throw error;
    }
  }
}

module.exports = MessageService;

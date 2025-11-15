const { supabase } = require('../utils/functions'); // Usar la misma instancia que el resto del backend
const Message = require('../models/Message');

/**
 * Repositorio de Mensajes
 * Maneja todas las operaciones de base de datos relacionadas con mensajes
 */
class MessageRepository {
  constructor() {
    this.tableName = 'mensajes'; // Tabla en español
  }

  /**
   * Crea un nuevo mensaje
   */
  async create(messageData) {
    try {
      const { data, error } = await supabase
        .from(this.tableName)
        .insert(messageData.toJson())
        .select()
        .single();

      if (error) throw error;
      return Message.fromJson(data);
    } catch (error) {
      console.error('Error creating message:', error);
      throw new Error(`Error al crear mensaje: ${error.message}`);
    }
  }

  /**
   * Busca un mensaje por ID
   */
  async findById(id) {
    try {
      const { data, error } = await supabase
        .from(this.tableName)
        .select('*')
        .eq('id', id)
        .single();

      if (error) {
        if (error.code === 'PGRST116') return null; // No encontrado
        throw error;
      }

      return Message.fromJson(data);
    } catch (error) {
      console.error('Error finding message by ID:', error);
      throw new Error(`Error al buscar mensaje: ${error.message}`);
    }
  }

  /**
   * Busca mensajes por conversación
   */
  async findByConversationId(conversationId, options = {}) {
    try {
      const {
        page = 1,
        limit = 50,
        orderBy = 'created_at',
        orderDirection = 'asc'
      } = options;

      const offset = (page - 1) * limit;

      console.log('🔍 [MessageRepository] Buscando mensajes por conversación:');
      console.log('   Conversation ID:', conversationId);
      console.log('   Tipo de Conversation ID:', typeof conversationId);
      console.log('   Page:', page, 'Limit:', limit, 'Offset:', offset);
      console.log('   Order By:', orderBy, 'Direction:', orderDirection);

      // DIAGNÓSTICO: Verificar si hay mensajes en la tabla
      const { data: allMessagesSample, error: sampleError } = await supabase
        .from(this.tableName)
        .select('id, conversacion_id, content, message_type, created_at')
        .limit(5);
      
      if (!sampleError && allMessagesSample) {
        console.log('📊 [MessageRepository] Muestra de mensajes en BD:');
        allMessagesSample.forEach((msg, idx) => {
          console.log(`   Mensaje ${idx + 1}:`);
          console.log(`      ID: ${msg.id}`);
          console.log(`      conversacion_id: ${msg.conversacion_id} (tipo: ${typeof msg.conversacion_id})`);
          console.log(`      Coincide con búsqueda: ${msg.conversacion_id === conversationId}`);
          console.log(`      Content: ${msg.content?.substring(0, 30)}...`);
        });
      }

      // DIAGNÓSTICO: Contar total de mensajes en la tabla
      const { count: totalMessagesInTable } = await supabase
        .from(this.tableName)
        .select('*', { count: 'exact', head: true });
      
      console.log('📊 [MessageRepository] Total de mensajes en tabla mensajes:', totalMessagesInTable);

      // DIAGNÓSTICO: Verificar conversación existe
      console.log('🔍 [MessageRepository] Verificando existencia de conversación...');
      console.log('   Conversation ID a buscar:', conversationId);
      console.log('   Tipo:', typeof conversationId);
      
      // Primero, listar todas las conversaciones para debug
      const { data: allConversations, error: allConvError } = await supabase
        .from('conversaciones')
        .select('id, user_id, username, status')
        .limit(10);
      
      if (allConvError) {
        console.log('⚠️ [MessageRepository] Error al listar conversaciones:', allConvError.message);
      }
      
      console.log('📋 [MessageRepository] Primeras 10 conversaciones en BD:');
      if (allConversations && allConversations.length > 0) {
        allConversations.forEach((conv, idx) => {
          const idMatch = conv.id === conversationId || conv.id?.toString() === conversationId?.toString();
          console.log(`   ${idx + 1}. ID: ${conv.id} (tipo: ${typeof conv.id}) | Username: ${conv.username} | Coincide: ${idMatch}`);
        });
      } else {
        console.log('   ⚠️ No hay conversaciones en la BD o error en la consulta');
      }
      
      // Intentar buscar la conversación - asegurarse de que el ID sea UUID
      let conversationIdToSearch = conversationId;
      
      // Si el conversationId es un string, intentar convertirlo a UUID si es necesario
      const { data: conversation, error: convError } = await supabase
        .from('conversaciones')
        .select('id, user_id, username, status')
        .eq('id', conversationIdToSearch)
        .maybeSingle();
      
      if (convError) {
        console.log('⚠️ [MessageRepository] Error al buscar conversación:', convError.message);
        console.log('   Error code:', convError.code);
        console.log('   Error details:', convError.details);
        console.log('   Error hint:', convError.hint);
      } else if (!conversation) {
        console.log('⚠️ [MessageRepository] Conversación NO encontrada en BD');
        console.log('   ID buscado:', conversationId);
        console.log('   Tipo del ID buscado:', typeof conversationId);
        console.log('   Intentando buscar por external_conversation_id...');
        
        // Intentar buscar por external_conversation_id
        const { data: convByExternal, error: extError } = await supabase
          .from('conversaciones')
          .select('id, user_id, username, status, external_conversation_id')
          .eq('external_conversation_id', conversationId)
          .maybeSingle();
        
        if (extError) {
          console.log('   Error buscando por external_conversation_id:', extError.message);
        }
        
        if (convByExternal) {
          console.log('✅ [MessageRepository] Conversación encontrada por external_conversation_id:');
          console.log('   ID real:', convByExternal.id);
          console.log('   External ID:', convByExternal.external_conversation_id);
          console.log('   ⚠️ El ID usado no coincide con el ID real de la conversación');
          console.log('   🔧 Usando el ID real para buscar mensajes...');
          
          // Usar el ID real para buscar mensajes
          conversationIdToSearch = convByExternal.id;
        } else {
          console.log('   ⚠️ Tampoco se encontró por external_conversation_id');
        }
      } else {
        console.log('✅ [MessageRepository] Conversación existe:');
        console.log('   ID:', conversation.id);
        console.log('   User ID:', conversation.user_id);
        console.log('   Username:', conversation.username);
        console.log('   Status:', conversation.status);
      }

      // Query principal - usar el ID correcto (puede haber sido actualizado arriba)
      const finalConversationId = conversationIdToSearch || conversationId;
      console.log('🔍 [MessageRepository] Ejecutando query principal...');
      console.log('   Usando Conversation ID:', finalConversationId);
      console.log('   Tipo:', typeof finalConversationId);
      
      const { data, error, count } = await supabase
        .from(this.tableName)
        .select('*', { count: 'exact' })
        .eq('conversacion_id', finalConversationId) // Campo en español
        .order(orderBy, { ascending: orderDirection === 'asc' })
        .range(offset, offset + limit - 1);

      if (error) {
        console.error('❌ [MessageRepository] Error en query de Supabase:', error);
        console.error('   Error code:', error.code);
        console.error('   Error message:', error.message);
        console.error('   Error details:', error.details);
        throw error;
      }

      console.log('✅ [MessageRepository] Query exitosa:');
      console.log('   Mensajes encontrados (raw):', data?.length || 0);
      console.log('   Total en BD para esta conversación:', count);
      console.log('   Primeros 3 mensajes:', data?.slice(0, 3).map(m => ({
        id: m.id,
        conversacion_id: m.conversacion_id,
        content: m.content?.substring(0, 50),
        message_type: m.message_type
      })));

      const messages = data.map(message => {
        try {
          return Message.fromJson(message);
        } catch (parseError) {
          console.error('⚠️ [MessageRepository] Error al parsear mensaje:', parseError);
          console.error('   Datos del mensaje:', message);
          return null;
        }
      }).filter(msg => msg !== null);

      console.log('✅ [MessageRepository] Mensajes parseados:', messages.length);

      return {
        messages,
        total: count || 0,
        page,
        limit,
        totalPages: Math.ceil((count || 0) / limit)
      };
    } catch (error) {
      console.error('❌ [MessageRepository] Error finding messages by conversation:', error);
      throw new Error(`Error al buscar mensajes: ${error.message}`);
    }
  }

  /**
   * Busca mensajes por usuario
   */
  async findByUserId(userId, options = {}) {
    try {
      const {
        page = 1,
        limit = 50,
        orderBy = 'created_at',
        orderDirection = 'desc'
      } = options;

      const offset = (page - 1) * limit;

      const { data, error, count } = await supabase
        .from(this.tableName)
        .select('*', { count: 'exact' })
        .eq('user_id', userId)
        .order(orderBy, { ascending: orderDirection === 'asc' })
        .range(offset, offset + limit - 1);

      if (error) throw error;

      return {
        messages: data.map(message => Message.fromJson(message)),
        total: count,
        page,
        limit,
        totalPages: Math.ceil(count / limit)
      };
    } catch (error) {
      console.error('Error finding messages by user:', error);
      throw new Error(`Error al buscar mensajes del usuario: ${error.message}`);
    }
  }

  /**
   * Actualiza un mensaje
   */
  async update(id, updateData) {
    try {
      const { data, error } = await supabase
        .from(this.tableName)
        .update(updateData)
        .eq('id', id)
        .select()
        .single();

      if (error) throw error;
      return Message.fromJson(data);
    } catch (error) {
      console.error('Error updating message:', error);
      throw new Error(`Error al actualizar mensaje: ${error.message}`);
    }
  }

  /**
   * Elimina un mensaje
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
      console.error('Error deleting message:', error);
      throw new Error(`Error al eliminar mensaje: ${error.message}`);
    }
  }

  /**
   * Marca un mensaje como procesado
   * NOTA: La columna is_processed no existe en la tabla mensajes,
   * y updated_at tampoco existe. Este método solo retorna el mensaje sin cambios.
   */
  async markAsProcessed(id) {
    try {
      // Como no hay campos para marcar como procesado, solo retornamos el mensaje
      const { data, error } = await supabase
        .from(this.tableName)
        .select('*')
        .eq('id', id)
        .single();

      if (error) throw error;
      return Message.fromJson(data);
    } catch (error) {
      console.error('Error marking message as processed:', error);
      throw new Error(`Error al marcar mensaje como procesado: ${error.message}`);
    }
  }

  /**
   * Busca mensajes no procesados
   * NOTA: La columna is_processed no existe en la tabla mensajes,
   * por lo que este método retorna todos los mensajes ordenados por fecha
   */
  async findUnprocessed(limit = 100) {
    try {
      const { data, error } = await supabase
        .from(this.tableName)
        .select('*')
        .order('created_at', { ascending: true })
        .limit(limit);

      if (error) throw error;
      return data.map(message => Message.fromJson(message));
    } catch (error) {
      console.error('Error finding unprocessed messages:', error);
      throw new Error(`Error al buscar mensajes no procesados: ${error.message}`);
    }
  }

  /**
   * Busca mensajes por tipo
   */
  async findByType(messageType, options = {}) {
    try {
      const {
        page = 1,
        limit = 50,
        orderBy = 'created_at',
        orderDirection = 'desc'
      } = options;

      const offset = (page - 1) * limit;

      const { data, error, count } = await supabase
        .from(this.tableName)
        .select('*', { count: 'exact' })
        .eq('message_type', messageType)
        .order(orderBy, { ascending: orderDirection === 'asc' })
        .range(offset, offset + limit - 1);

      if (error) throw error;

      return {
        messages: data.map(message => Message.fromJson(message)),
        total: count,
        page,
        limit,
        totalPages: Math.ceil(count / limit)
      };
    } catch (error) {
      console.error('Error finding messages by type:', error);
      throw new Error(`Error al buscar mensajes por tipo: ${error.message}`);
    }
  }

  /**
   * Busca mensajes con búsqueda de texto
   */
  async searchByContent(searchTerm, options = {}) {
    try {
      const {
        page = 1,
        limit = 50,
        conversationId,
        userId
      } = options;

      const offset = (page - 1) * limit;

      let query = supabase
        .from(this.tableName)
        .select('*', { count: 'exact' })
        .ilike('content', `%${searchTerm}%`);

      if (conversationId) {
        query = query.eq('conversacion_id', conversationId); // Campo en español
      }
      if (userId) {
        query = query.eq('user_id', userId);
      }

      const { data, error, count } = await query
        .order('created_at', { ascending: false })
        .range(offset, offset + limit - 1);

      if (error) throw error;

      return {
        messages: data.map(message => Message.fromJson(message)),
        total: count,
        page,
        limit,
        totalPages: Math.ceil(count / limit)
      };
    } catch (error) {
      console.error('Error searching messages by content:', error);
      throw new Error(`Error al buscar mensajes: ${error.message}`);
    }
  }

  /**
   * Obtiene estadísticas de mensajes
   */
  async getStats(userId = null) {
    try {
      let query = supabase
        .from(this.tableName)
        .select('message_type, is_ai_generated, created_at');

      if (userId) {
        query = query.eq('user_id', userId);
      }

      const { data, error } = await query;

      if (error) throw error;

      const stats = {
        total: data.length,
        byType: {},
        byAI: { fromAI: 0, fromUser: 0 },
        byDate: {}
      };

      data.forEach(message => {
        // Por tipo
        stats.byType[message.message_type] = (stats.byType[message.message_type] || 0) + 1;
        
        // Por AI - usar el nombre correcto de la columna
        if (message.is_ai_generated) {
          stats.byAI.fromAI++;
        } else {
          stats.byAI.fromUser++;
        }

        // Por fecha
        const date = new Date(message.created_at).toISOString().split('T')[0];
        stats.byDate[date] = (stats.byDate[date] || 0) + 1;
      });

      return stats;
    } catch (error) {
      console.error('Error getting message stats:', error);
      throw new Error(`Error al obtener estadísticas: ${error.message}`);
    }
  }
}

module.exports = MessageRepository;

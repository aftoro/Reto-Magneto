const MessageService = require('../services/MessageService');

class MessageController {
  constructor() {
    this.messageService = new MessageService();
  }

  async createMessage(req, res) {
    try {
      const {
        conversationId,
        content,
        messageType = 'text',
        mediaUrl
      } = req.body;

      const userId = req.user.id;

      if (!conversationId || !content) {
        return res.status(400).json({
          success: false,
          message: 'ID de conversación y contenido son requeridos'
        });
      }

      const message = await this.messageService.createMessage({
        conversationId,
        userId,
        content,
        messageType,
        mediaUrl
      });

      res.status(201).json({
        success: true,
        message: 'Mensaje creado exitosamente',
        data: message
      });
    } catch (error) {
      console.error('Error in createMessage controller:', error);
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  async getMessagesByConversation(req, res) {
    try {
      const { conversationId } = req.params;
      const {
        page = 1,
        limit = 50,
        orderBy = 'created_at',
        orderDirection = 'asc'
      } = req.query;

      const options = {
        page: parseInt(page),
        limit: parseInt(limit),
        orderBy,
        orderDirection
      };

      const result = await this.messageService.getMessagesByConversation(conversationId, options);

      res.json({
        success: true,
        data: result
      });
    } catch (error) {
      console.error('Error in getMessagesByConversation:', error);
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  }

  async getMyMessages(req, res) {
    try {
      const userId = req.user.id;
      const {
        page = 1,
        limit = 50,
        orderBy = 'created_at',
        orderDirection = 'desc'
      } = req.query;

      const options = {
        page: parseInt(page),
        limit: parseInt(limit),
        orderBy,
        orderDirection
      };

      const result = await this.messageService.getMessagesByUser(userId, options);

      res.json({
        success: true,
        data: result
      });
    } catch (error) {
      console.error('Error in getMyMessages controller:', error);
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  }

  async getMessageById(req, res) {
    try {
      const { id } = req.params;
      const message = await this.messageService.getMessageById(id);

      res.json({
        success: true,
        data: message
      });
    } catch (error) {
      console.error('Error in getMessageById controller:', error);
      res.status(404).json({
        success: false,
        message: error.message
      });
    }
  }

  async updateMessage(req, res) {
    try {
      const { id } = req.params;
      const updateData = req.body;

      const message = await this.messageService.updateMessage(id, updateData);

      res.json({
        success: true,
        message: 'Mensaje actualizado exitosamente',
        data: message
      });
    } catch (error) {
      console.error('Error in updateMessage controller:', error);
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  async deleteMessage(req, res) {
    try {
      const { id } = req.params;
      await this.messageService.deleteMessage(id);

      res.json({
        success: true,
        message: 'Mensaje eliminado exitosamente'
      });
    } catch (error) {
      console.error('Error in deleteMessage controller:', error);
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  async markAsProcessed(req, res) {
    try {
      const { id } = req.params;
      const message = await this.messageService.markMessageAsProcessed(id);

      res.json({
        success: true,
        message: 'Mensaje marcado como procesado',
        data: message
      });
    } catch (error) {
      console.error('Error in markAsProcessed controller:', error);
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  async getUnprocessedMessages(req, res) {
    try {
      const { limit = 100 } = req.query;
      const messages = await this.messageService.getUnprocessedMessages(parseInt(limit));

      res.json({
        success: true,
        data: messages
      });
    } catch (error) {
      console.error('Error in getUnprocessedMessages controller:', error);
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  }

  async searchMessages(req, res) {
    try {
      const { q: searchTerm } = req.query;
      const {
        page = 1,
        limit = 50,
        conversationId,
        userId
      } = req.query;

      if (!searchTerm) {
        return res.status(400).json({
          success: false,
          message: 'Término de búsqueda es requerido'
        });
      }

      const options = {
        page: parseInt(page),
        limit: parseInt(limit),
        conversationId,
        userId
      };

      const result = await this.messageService.searchMessages(searchTerm, options);

      res.json({
        success: true,
        data: result
      });
    } catch (error) {
      console.error('Error in searchMessages controller:', error);
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  }

  async getMessagesByType(req, res) {
    try {
      const { type } = req.params;
      const {
        page = 1,
        limit = 50,
        orderBy = 'created_at',
        orderDirection = 'desc'
      } = req.query;

      const options = {
        page: parseInt(page),
        limit: parseInt(limit),
        orderBy,
        orderDirection
      };

      const result = await this.messageService.getMessagesByType(type, options);

      res.json({
        success: true,
        data: result
      });
    } catch (error) {
      console.error('Error in getMessagesByType controller:', error);
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  }

  async getMessageStats(req, res) {
    try {
      const { userId } = req.query;
      const stats = await this.messageService.getMessageStats(userId);

      res.json({
        success: true,
        data: stats
      });
    } catch (error) {
      console.error('Error in getMessageStats controller:', error);
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  }

  async processBatchMessages(req, res) {
    try {
      const { messageIds, processor } = req.body;

      if (!messageIds || !Array.isArray(messageIds)) {
        return res.status(400).json({
          success: false,
          message: 'Lista de IDs de mensajes es requerida'
        });
      }

      const results = await this.messageService.processBatchMessages(messageIds, processor);

      res.json({
        success: true,
        message: 'Procesamiento en lote completado',
        data: results
      });
    } catch (error) {
      console.error('Error in processBatchMessages controller:', error);
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  }

  async getMessageHistoryForAI(req, res) {
    try {
      const { conversationId } = req.params;
      const { limit = 10 } = req.query;

      const messages = await this.messageService.getMessageHistoryForAI(
        conversationId,
        parseInt(limit)
      );

      res.json({
        success: true,
        data: messages
      });
    } catch (error) {
      console.error('Error in getMessageHistoryForAI controller:', error);
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  }

  async createAIResponse(req, res) {
    try {
      const { conversationId, content, metadata = {} } = req.body;
      const userId = req.user.id;

      if (!conversationId || !content) {
        return res.status(400).json({
          success: false,
          message: 'ID de conversación y contenido son requeridos'
        });
      }

      const message = await this.messageService.createAIResponse(
        conversationId,
        userId,
        content,
        metadata
      );

      res.status(201).json({
        success: true,
        message: 'Respuesta de AI creada exitosamente',
        data: message
      });
    } catch (error) {
      console.error('Error in createAIResponse controller:', error);
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }
}

module.exports = MessageController;

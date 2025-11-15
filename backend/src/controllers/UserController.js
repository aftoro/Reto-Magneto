const UserService = require('../services/UserService');
const { createSuccessResponse, createErrorResponse, createValidationResponse } = require('../utils/helpers');

class UserController {
  constructor() {
    this.userService = new UserService();
  }

  async register(req, res) {
    try {
      const { email, password, fullName } = req.body;

      if (!email || !password) {
        const { response, statusCode } = createValidationResponse(['Email y contraseña son requeridos']);
        return res.status(statusCode).json(response);
      }

      const user = await this.userService.registerUser({
        email,
        password,
        fullName
      });

      res.status(201).json({
        success: true,
        message: 'Usuario registrado exitosamente',
        data: user
      });
    } catch (error) {
      console.error('Error in register controller:', error);
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  async login(req, res) {
    try {
      const { email, password } = req.body;

      if (!email || !password) {
        return res.status(400).json({
          success: false,
          message: 'Email y contraseña son requeridos'
        });
      }

      const result = await this.userService.authenticateUser({
        email,
        password
      });

      res.json({
        success: true,
        message: 'Autenticación exitosa',
        data: result
      });
    } catch (error) {
      console.error('Error in login controller:', error);
      res.status(401).json({
        success: false,
        message: error.message
      });
    }
  }

  async getProfile(req, res) {
    try {
      const userId = req.user.id;
      const user = await this.userService.getUserById(userId);

      res.json({
        success: true,
        data: user
      });
    } catch (error) {
      console.error('Error in getProfile controller:', error);
      res.status(404).json({
        success: false,
        message: error.message
      });
    }
  }

  async updateProfile(req, res) {
    try {
      const userId = req.user.id;
      const updateData = req.body;

      const user = await this.userService.updateUserProfile(userId, updateData);

      res.json({
        success: true,
        message: 'Perfil actualizado exitosamente',
        data: user
      });
    } catch (error) {
      console.error('Error in updateProfile controller:', error);
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  async getUserById(req, res) {
    try {
      const { id } = req.params;
      const user = await this.userService.getUserById(id);

      res.json({
        success: true,
        data: user
      });
    } catch (error) {
      console.error('Error in getUserById controller:', error);
      res.status(404).json({
        success: false,
        message: error.message
      });
    }
  }

  async listUsers(req, res) {
    try {
      const {
        page = 1,
        limit = 10,
        orderBy = 'created_at',
        orderDirection = 'desc'
      } = req.query;

      const options = {
        page: parseInt(page),
        limit: parseInt(limit),
        orderBy,
        orderDirection
      };

      const result = await this.userService.listUsers(options);

      res.json({
        success: true,
        data: result
      });
    } catch (error) {
      console.error('Error in listUsers controller:', error);
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  }

  async searchUsers(req, res) {
    try {
      const { email, fullName, role } = req.query;
      
      const criteria = {};
      if (email) criteria.email = email;
      if (fullName) criteria.fullName = fullName;
      if (role) criteria.role = role;

      const users = await this.userService.searchUsers(criteria);

      res.json({
        success: true,
        data: users
      });
    } catch (error) {
      console.error('Error in searchUsers controller:', error);
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  }

  async deleteUser(req, res) {
    try {
      const { id } = req.params;
      await this.userService.deleteUser(id);

      res.json({
        success: true,
        message: 'Usuario eliminado exitosamente'
      });
    } catch (error) {
      console.error('Error in deleteUser controller:', error);
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  async getUserStats(req, res) {
    try {
      const stats = await this.userService.getUserStats();

      res.json({
        success: true,
        data: stats
      });
    } catch (error) {
      console.error('Error in getUserStats controller:', error);
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  }

  async logout(req, res) {
    try {
      await this.userService.logoutUser();

      res.json({
        success: true,
        message: 'Sesión cerrada exitosamente'
      });
    } catch (error) {
      console.error('Error in logout controller:', error);
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  }

  async sendVerificationEmail(req, res) {
    try {
      const { email } = req.body;

      if (!email) {
        return res.status(400).json({
          success: false,
          message: 'Email es requerido'
        });
      }

      await this.userService.sendVerificationEmail(email);

      res.json({
        success: true,
        message: 'Email de verificación enviado'
      });
    } catch (error) {
      console.error('Error in sendVerificationEmail controller:', error);
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  async resetPassword(req, res) {
    try {
      const { email } = req.body;

      if (!email) {
        return res.status(400).json({
          success: false,
          message: 'Email es requerido'
        });
      }

      await this.userService.resetPassword(email);

      res.json({
        success: true,
        message: 'Email de restablecimiento enviado'
      });
    } catch (error) {
      console.error('Error in resetPassword controller:', error);
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }

  async checkEmailExists(req, res) {
    try {
      const { email } = req.query;

      if (!email) {
        return res.status(400).json({
          success: false,
          message: 'Email es requerido'
        });
      }

      const exists = await this.userService.checkEmailExists(email);

      res.json({
        success: true,
        data: { exists }
      });
    } catch (error) {
      console.error('Error in checkEmailExists controller:', error);
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  }
}

module.exports = UserController;

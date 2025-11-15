const UserRepository = require('../repositories/UserRepository');
const User = require('../models/User');
const { supabase } = require('../config/database');

/**
 * Servicio de Usuario
 * Contiene la lógica de negocio para operaciones de usuario
 */
class UserService {
  constructor() {
    this.userRepository = new UserRepository();
  }

  /**
   * Registra un nuevo usuario
   */
  async registerUser({ email, password, fullName }) {
    try {
      // Verificar si el email ya existe
      const existingUser = await this.userRepository.findByEmail(email);
      if (existingUser) {
        throw new Error('El email ya está registrado');
      }

      // Crear usuario en Supabase Auth
      const { data: authData, error: authError } = await supabase.auth.signUp({
        email,
        password,
        options: {
          data: {
            full_name: fullName
          }
        }
      });

      if (authError) {
        throw new Error(`Error en autenticación: ${authError.message}`);
      }

      if (!authData.user) {
        throw new Error('No se pudo crear el usuario');
      }

      // Crear perfil en la base de datos
      const user = new User({
        id: authData.user.id,
        email,
        fullName,
        createdAt: new Date(),
        updatedAt: new Date(),
        isEmailVerified: false,
        role: 'user'
      });

      const createdUser = await this.userRepository.create(user);
      return createdUser.toPublicJson();
    } catch (error) {
      console.error('Error registering user:', error);
      throw error;
    }
  }

  /**
   * Autentica un usuario
   */
  async authenticateUser({ email, password }) {
    try {
      const { data: authData, error: authError } = await supabase.auth.signInWithPassword({
        email,
        password
      });

      if (authError) {
        throw new Error(`Error de autenticación: ${authError.message}`);
      }

      if (!authData.user) {
        throw new Error('Credenciales inválidas');
      }

      // Obtener perfil del usuario
      let user = await this.userRepository.findById(authData.user.id);
      
      if (!user) {
        // Crear perfil si no existe
        user = new User({
          id: authData.user.id,
          email: authData.user.email,
          fullName: authData.user.user_metadata?.full_name,
          createdAt: new Date(),
          updatedAt: new Date(),
          isEmailVerified: !!authData.user.email_confirmed_at,
          role: 'user'
        });
        user = await this.userRepository.create(user);
      } else {
        // Actualizar último acceso
        await this.userRepository.updateLastAccess(user.id);
      }

      return {
        user: user.toPublicJson(),
        session: authData.session
      };
    } catch (error) {
      console.error('Error authenticating user:', error);
      throw error;
    }
  }

  /**
   * Obtiene un usuario por ID
   */
  async getUserById(id) {
    try {
      const user = await this.userRepository.findById(id);
      if (!user) {
        throw new Error('Usuario no encontrado');
      }
      return user.toPublicJson();
    } catch (error) {
      console.error('Error getting user by ID:', error);
      throw error;
    }
  }

  /**
   * Actualiza el perfil de un usuario
   */
  async updateUserProfile(id, updateData) {
    try {
      const user = await this.userRepository.findById(id);
      if (!user) {
        throw new Error('Usuario no encontrado');
      }

      // Validar datos de actualización
      const allowedFields = ['fullName', 'avatarUrl', 'phoneNumber'];
      const filteredData = {};
      
      allowedFields.forEach(field => {
        if (updateData[field] !== undefined) {
          filteredData[field] = updateData[field];
        }
      });

      if (Object.keys(filteredData).length === 0) {
        throw new Error('No hay datos válidos para actualizar');
      }

      // Actualizar en la base de datos
      const updatedUser = await this.userRepository.update(id, {
        ...filteredData,
        updated_at: new Date().toISOString()
      });

      return updatedUser.toPublicJson();
    } catch (error) {
      console.error('Error updating user profile:', error);
      throw error;
    }
  }

  /**
   * Elimina un usuario
   */
  async deleteUser(id) {
    try {
      const user = await this.userRepository.findById(id);
      if (!user) {
        throw new Error('Usuario no encontrado');
      }

      // Eliminar de Supabase Auth
      const { error: authError } = await supabase.auth.admin.deleteUser(id);
      if (authError) {
        console.warn('Error deleting user from auth:', authError);
      }

      // Eliminar de la base de datos
      await this.userRepository.delete(id);
      return true;
    } catch (error) {
      console.error('Error deleting user:', error);
      throw error;
    }
  }

  /**
   * Lista usuarios con paginación
   */
  async listUsers(options = {}) {
    try {
      const result = await this.userRepository.findAll(options);
      return {
        ...result,
        users: result.users.map(user => user.toPublicJson())
      };
    } catch (error) {
      console.error('Error listing users:', error);
      throw error;
    }
  }

  /**
   * Busca usuarios
   */
  async searchUsers(criteria) {
    try {
      const users = await this.userRepository.search(criteria);
      return users.map(user => user.toPublicJson());
    } catch (error) {
      console.error('Error searching users:', error);
      throw error;
    }
  }

  /**
   * Verifica si un email existe
   */
  async checkEmailExists(email) {
    try {
      return await this.userRepository.emailExists(email);
    } catch (error) {
      console.error('Error checking email existence:', error);
      throw error;
    }
  }

  /**
   * Obtiene estadísticas de usuarios
   */
  async getUserStats() {
    try {
      const { users, total } = await this.userRepository.findAll({ limit: 1000 });
      
      const stats = {
        total,
        verified: users.filter(u => u.isEmailVerified).length,
        unverified: users.filter(u => !u.isEmailVerified).length,
        byRole: {},
        recent: users
          .filter(u => u.createdAt && new Date(u.createdAt) > new Date(Date.now() - 7 * 24 * 60 * 60 * 1000))
          .length
      };

      users.forEach(user => {
        stats.byRole[user.role] = (stats.byRole[user.role] || 0) + 1;
      });

      return stats;
    } catch (error) {
      console.error('Error getting user stats:', error);
      throw error;
    }
  }

  /**
   * Cierra sesión del usuario
   */
  async logoutUser() {
    try {
      const { error } = await supabase.auth.signOut();
      if (error) {
        throw new Error(`Error al cerrar sesión: ${error.message}`);
      }
      return true;
    } catch (error) {
      console.error('Error logging out user:', error);
      throw error;
    }
  }

  /**
   * Envía email de verificación
   */
  async sendVerificationEmail(email) {
    try {
      const { error } = await supabase.auth.resend({
        type: 'signup',
        email
      });

      if (error) {
        throw new Error(`Error al enviar email: ${error.message}`);
      }
      return true;
    } catch (error) {
      console.error('Error sending verification email:', error);
      throw error;
    }
  }

  /**
   * Restablece contraseña
   */
  async resetPassword(email) {
    try {
      const { error } = await supabase.auth.resetPasswordForEmail(email);
      if (error) {
        throw new Error(`Error al restablecer contraseña: ${error.message}`);
      }
      return true;
    } catch (error) {
      console.error('Error resetting password:', error);
      throw error;
    }
  }
}

module.exports = UserService;

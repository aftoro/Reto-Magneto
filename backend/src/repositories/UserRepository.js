const { supabase } = require('../config/database');
const User = require('../models/User');

/**
 * Repositorio de Usuario
 * Maneja todas las operaciones de base de datos relacionadas con usuarios
 */
class UserRepository {
  constructor() {
    this.tableName = 'profiles';
  }

  /**
   * Crea un nuevo usuario
   */
  async create(userData) {
    try {
      const { data, error } = await supabase
        .from(this.tableName)
        .insert(userData.toJson())
        .select()
        .single();

      if (error) throw error;
      return User.fromJson(data);
    } catch (error) {
      console.error('Error creating user:', error);
      throw new Error(`Error al crear usuario: ${error.message}`);
    }
  }

  /**
   * Busca un usuario por ID
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

      return User.fromJson(data);
    } catch (error) {
      console.error('Error finding user by ID:', error);
      throw new Error(`Error al buscar usuario: ${error.message}`);
    }
  }

  /**
   * Busca un usuario por email
   */
  async findByEmail(email) {
    try {
      const { data, error } = await supabase
        .from(this.tableName)
        .select('*')
        .eq('email', email)
        .single();

      if (error) {
        if (error.code === 'PGRST116') return null; // No encontrado
        throw error;
      }

      return User.fromJson(data);
    } catch (error) {
      console.error('Error finding user by email:', error);
      throw new Error(`Error al buscar usuario por email: ${error.message}`);
    }
  }

  /**
   * Actualiza un usuario
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
      return User.fromJson(data);
    } catch (error) {
      console.error('Error updating user:', error);
      throw new Error(`Error al actualizar usuario: ${error.message}`);
    }
  }

  /**
   * Elimina un usuario
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
      console.error('Error deleting user:', error);
      throw new Error(`Error al eliminar usuario: ${error.message}`);
    }
  }

  /**
   * Lista todos los usuarios con paginación
   */
  async findAll(options = {}) {
    try {
      const {
        page = 1,
        limit = 10,
        orderBy = 'created_at',
        orderDirection = 'desc'
      } = options;

      const offset = (page - 1) * limit;

      const { data, error, count } = await supabase
        .from(this.tableName)
        .select('*', { count: 'exact' })
        .order(orderBy, { ascending: orderDirection === 'asc' })
        .range(offset, offset + limit - 1);

      if (error) throw error;

      return {
        users: data.map(user => User.fromJson(user)),
        total: count,
        page,
        limit,
        totalPages: Math.ceil(count / limit)
      };
    } catch (error) {
      console.error('Error listing users:', error);
      throw new Error(`Error al listar usuarios: ${error.message}`);
    }
  }

  /**
   * Busca usuarios por criterios
   */
  async search(criteria) {
    try {
      let query = supabase.from(this.tableName).select('*');

      if (criteria.email) {
        query = query.ilike('email', `%${criteria.email}%`);
      }
      if (criteria.fullName) {
        query = query.ilike('full_name', `%${criteria.fullName}%`);
      }
      if (criteria.role) {
        query = query.eq('role', criteria.role);
      }

      const { data, error } = await query;

      if (error) throw error;
      return data.map(user => User.fromJson(user));
    } catch (error) {
      console.error('Error searching users:', error);
      throw new Error(`Error al buscar usuarios: ${error.message}`);
    }
  }

  /**
   * Verifica si un email ya existe
   */
  async emailExists(email) {
    try {
      const { data, error } = await supabase
        .from(this.tableName)
        .select('id')
        .eq('email', email)
        .single();

      if (error) {
        if (error.code === 'PGRST116') return false; // No encontrado
        throw error;
      }

      return !!data;
    } catch (error) {
      console.error('Error checking email existence:', error);
      throw new Error(`Error al verificar email: ${error.message}`);
    }
  }

  /**
   * Actualiza el último acceso del usuario
   */
  async updateLastAccess(id) {
    try {
      const { error } = await supabase
        .from(this.tableName)
        .update({ 
          last_access: new Date().toISOString(),
          updated_at: new Date().toISOString()
        })
        .eq('id', id);

      if (error) throw error;
      return true;
    } catch (error) {
      console.error('Error updating last access:', error);
      throw new Error(`Error al actualizar último acceso: ${error.message}`);
    }
  }
}

module.exports = UserRepository;

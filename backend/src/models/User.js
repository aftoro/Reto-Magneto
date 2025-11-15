/**
 * Modelo de Usuario
 * Representa la entidad de usuario en el sistema
 */
class User {
  constructor({
    id,
    email,
    fullName,
    avatarUrl,
    phoneNumber,
    createdAt,
    updatedAt,
    isEmailVerified = false,
    role = 'user'
  }) {
    this.id = id;
    this.email = email;
    this.fullName = fullName;
    this.avatarUrl = avatarUrl;
    this.phoneNumber = phoneNumber;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
    this.isEmailVerified = isEmailVerified;
    this.role = role;
  }

  /**
   * Crea una instancia de User desde un objeto JSON
   */
  static fromJson(json) {
    return new User({
      id: json.id,
      email: json.email,
      fullName: json.full_name,
      avatarUrl: json.avatar_url,
      phoneNumber: json.phone_number,
      createdAt: json.created_at ? new Date(json.created_at) : null,
      updatedAt: json.updated_at ? new Date(json.updated_at) : null,
      isEmailVerified: json.is_email_verified || false,
      role: json.role || 'user'
    });
  }

  /**
   * Convierte la instancia a JSON para almacenamiento
   */
  toJson() {
    return {
      id: this.id,
      email: this.email,
      full_name: this.fullName,
      avatar_url: this.avatarUrl,
      phone_number: this.phoneNumber,
      created_at: this.createdAt?.toISOString(),
      updated_at: this.updatedAt?.toISOString(),
      is_email_verified: this.isEmailVerified,
      role: this.role
    };
  }

  /**
   * Valida los datos del usuario
   */
  validate() {
    const errors = [];

    if (!this.id) errors.push('ID es requerido');
    if (!this.email) errors.push('Email es requerido');
    if (this.email && !this.isValidEmail(this.email)) {
      errors.push('Formato de email inválido');
    }
    if (this.fullName && this.fullName.trim().length < 2) {
      errors.push('Nombre debe tener al menos 2 caracteres');
    }

    return {
      isValid: errors.length === 0,
      errors
    };
  }

  /**
   * Valida formato de email
   */
  isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  }

  /**
   * Actualiza los campos del usuario
   */
  update(updates) {
    Object.keys(updates).forEach(key => {
      if (this.hasOwnProperty(key) && updates[key] !== undefined) {
        this[key] = updates[key];
      }
    });
    this.updatedAt = new Date();
  }

  /**
   * Retorna una copia del usuario sin datos sensibles
   */
  toPublicJson() {
    return {
      id: this.id,
      email: this.email,
      fullName: this.fullName,
      avatarUrl: this.avatarUrl,
      isEmailVerified: this.isEmailVerified,
      role: this.role
    };
  }
}

module.exports = User;

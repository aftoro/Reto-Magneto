class UserEntity {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final String? phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isEmailVerified;
  final String role;

  const UserEntity({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
    this.isEmailVerified = false,
    this.role = 'user',
  });

  UserEntity copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
    String? role,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isEmailVerified': isEmailVerified,
      'role': role,
    };
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String) 
          : null,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      role: json['role'] as String? ?? 'user',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, fullName: $fullName)';
  }
}

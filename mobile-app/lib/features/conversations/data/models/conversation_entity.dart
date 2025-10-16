import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_entity.freezed.dart';
part 'conversation_entity.g.dart';

@freezed
class ConversationEntity with _$ConversationEntity {
  const factory ConversationEntity({
    required String id,
    required String platform,
    required String conversationType,
    String? externalConversationId,
    required String userId,
    String? username,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    
        // Perfil de Instagram (solo campos disponibles)
        String? userCurrentEmotion,
    
    // Datos recolectados
    String? userFullName,
    String? userProfession,
    String? userStudies,
    int? userExperienceYears,
    List<String>? userSkills,
    String? userLocation,
    List<String>? userLanguages,
    String? userSalaryExpectation,
    String? userAvailability,
    List<String>? userInterests,
    String? userCompanySizePreference,
    List<String>? userIndustryPreference,
    String? userWorkModePreference,
    String? userCareerLevel,
    String? userPortfolioUrl,
    String? userLinkedinUrl,
    String? userGithubUrl,
    int? userDataCompletionPercentage,
    DateTime? lastDataCollection,
  }) = _ConversationEntity;

  factory ConversationEntity.fromJson(Map<String, dynamic> json) =>
      _$ConversationEntityFromJson(json);

  factory ConversationEntity.fromSupabase(Map<String, dynamic> data) {
    return ConversationEntity(
      id: data['id']?.toString() ?? '',
      platform: data['platform']?.toString() ?? 'instagram',
      conversationType: data['conversation_type']?.toString() ?? '',
      externalConversationId: data['external_conversation_id']?.toString(),
      userId: data['user_id']?.toString() ?? '',
      username: data['username']?.toString(),
      status: data['status']?.toString(),
      createdAt: data['created_at'] != null 
          ? DateTime.tryParse(data['created_at'].toString()) 
          : null,
      updatedAt: data['updated_at'] != null 
          ? DateTime.tryParse(data['updated_at'].toString()) 
          : null,
      
      // Perfil de Instagram (solo campos disponibles)
      userCurrentEmotion: data['user_current_emotion']?.toString(),
      
      // Datos recolectados
      userFullName: data['user_full_name']?.toString(),
      userProfession: data['user_profession']?.toString(),
      userStudies: data['user_studies']?.toString(),
      userExperienceYears: data['user_experience_years'] as int?,
      userSkills: data['user_skills'] != null 
          ? List<String>.from(data['user_skills']) 
          : null,
      userLocation: data['user_location']?.toString(),
      userLanguages: data['user_languages'] != null 
          ? List<String>.from(data['user_languages']) 
          : null,
      userSalaryExpectation: data['user_salary_expectation']?.toString(),
      userAvailability: data['user_availability']?.toString(),
      userInterests: data['user_interests'] != null 
          ? List<String>.from(data['user_interests']) 
          : null,
      userCompanySizePreference: data['user_company_size_preference']?.toString(),
      userIndustryPreference: data['user_industry_preference'] != null 
          ? List<String>.from(data['user_industry_preference']) 
          : null,
      userWorkModePreference: data['user_work_mode_preference']?.toString(),
      userCareerLevel: data['user_career_level']?.toString(),
      userPortfolioUrl: data['user_portfolio_url']?.toString(),
      userLinkedinUrl: data['user_linkedin_url']?.toString(),
      userGithubUrl: data['user_github_url']?.toString(),
      userDataCompletionPercentage: data['user_data_completion_percentage'] as int?,
      lastDataCollection: data['last_data_collection'] != null 
          ? DateTime.tryParse(data['last_data_collection'].toString()) 
          : null,
    );
  }

  factory ConversationEntity.fromApiJson(Map<String, dynamic> data) {
    try {
      return ConversationEntity(
        id: data['id']?.toString() ?? '',
        platform: data['platform']?.toString() ?? 'instagram',
        conversationType: data['conversation_type']?.toString() ?? '',
        externalConversationId: data['external_conversation_id']?.toString(),
        userId: data['user_id']?.toString() ?? '',
        username: data['username']?.toString(),
        status: data['status']?.toString(),
        createdAt: data['created_at'] != null 
            ? DateTime.tryParse(data['created_at'].toString()) 
            : null,
        updatedAt: data['updated_at'] != null 
            ? DateTime.tryParse(data['updated_at'].toString()) 
            : null,
        
        // Perfil de Instagram (solo campos disponibles)
        userCurrentEmotion: data['user_current_emotion']?.toString(),
        
        // Datos recolectados
        userFullName: data['user_full_name']?.toString(),
        userProfession: data['user_profession']?.toString(),
        userStudies: data['user_studies']?.toString(),
        userExperienceYears: data['user_experience_years'] as int?,
        userSkills: data['user_skills'] != null 
            ? List<String>.from(data['user_skills']) 
            : null,
        userLocation: data['user_location']?.toString(),
        userLanguages: data['user_languages'] != null 
            ? List<String>.from(data['user_languages']) 
            : null,
        userSalaryExpectation: data['user_salary_expectation']?.toString(),
        userAvailability: data['user_availability']?.toString(),
        userInterests: data['user_interests'] != null 
            ? List<String>.from(data['user_interests']) 
            : null,
        userCompanySizePreference: data['user_company_size_preference']?.toString(),
        userIndustryPreference: data['user_industry_preference'] != null 
            ? List<String>.from(data['user_industry_preference']) 
            : null,
        userWorkModePreference: data['user_work_mode_preference']?.toString(),
        userCareerLevel: data['user_career_level']?.toString(),
        userPortfolioUrl: data['user_portfolio_url']?.toString(),
        userLinkedinUrl: data['user_linkedin_url']?.toString(),
        userGithubUrl: data['user_github_url']?.toString(),
        userDataCompletionPercentage: data['user_data_completion_percentage'] as int?,
        lastDataCollection: data['last_data_collection'] != null 
            ? DateTime.tryParse(data['last_data_collection'].toString()) 
            : null,
      );
    } catch (e) {
      print('Error al procesar ConversationEntity: $e');
      // Retornar una conversación básica en caso de error
      return ConversationEntity(
        id: data['id']?.toString() ?? 'unknown',
        platform: 'instagram',
        conversationType: 'dm',
        userId: data['user_id']?.toString() ?? 'unknown',
        username: data['username']?.toString(),
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }
}

@freezed
class MessageEntity with _$MessageEntity {
  const factory MessageEntity({
    required String id,
    String? conversacionId,
    String? platformMessageId,
    required String content,
    required String messageType,
    Map<String, dynamic>? mediaContext,
    bool? isAiGenerated,
    String? aiModel,
    String? authorName,
    String? authorType,
    DateTime? createdAt,
    DateTime? sentAt,
    String? deliveryStatus,
  }) = _MessageEntity;

  factory MessageEntity.fromJson(Map<String, dynamic> json) =>
      _$MessageEntityFromJson(json);

  factory MessageEntity.fromSupabase(Map<String, dynamic> data) {
    return MessageEntity(
      id: data['id']?.toString() ?? '',
      conversacionId: data['conversacion_id']?.toString(),
      platformMessageId: data['platform_message_id']?.toString(),
      content: data['content']?.toString() ?? '',
      messageType: data['message_type']?.toString() ?? 'text',
      mediaContext: data['media_context'] as Map<String, dynamic>?,
      isAiGenerated: data['is_ai_generated'] as bool?,
      aiModel: data['ai_model']?.toString(),
      authorName: data['author_name']?.toString(),
      authorType: data['author_type']?.toString(),
      createdAt: data['created_at'] != null 
          ? DateTime.tryParse(data['created_at'].toString()) 
          : null,
      sentAt: data['sent_at'] != null 
          ? DateTime.tryParse(data['sent_at'].toString()) 
          : null,
      deliveryStatus: data['delivery_status']?.toString(),
    );
  }

  factory MessageEntity.fromApiJson(Map<String, dynamic> data) {
    return MessageEntity(
      id: data['id']?.toString() ?? '',
      conversacionId: data['conversacion_id']?.toString(),
      platformMessageId: data['platform_message_id']?.toString(),
      content: data['content']?.toString() ?? '',
      messageType: data['message_type']?.toString() ?? 'text',
      mediaContext: data['media_context'] as Map<String, dynamic>?,
      isAiGenerated: data['is_ai_generated'] as bool?,
      aiModel: data['ai_model']?.toString(),
      authorName: data['author_name']?.toString(),
      authorType: data['author_type']?.toString(),
      createdAt: data['created_at'] != null 
          ? DateTime.tryParse(data['created_at'].toString()) 
          : null,
      sentAt: data['sent_at'] != null 
          ? DateTime.tryParse(data['sent_at'].toString()) 
          : null,
      deliveryStatus: data['delivery_status']?.toString(),
    );
  }
}

@freezed
class ConversationWithMessages with _$ConversationWithMessages {
  const factory ConversationWithMessages({
    required ConversationEntity conversation,
    List<MessageEntity>? messages,
    int? unreadCount,
    MessageEntity? lastMessage,
  }) = _ConversationWithMessages;

  factory ConversationWithMessages.fromJson(Map<String, dynamic> json) =>
      _$ConversationWithMessagesFromJson(json);

  factory ConversationWithMessages.fromApiJson(Map<String, dynamic> data) {
    final conversation = ConversationEntity.fromApiJson(data);
    
    // Procesar mensajes
    List<MessageEntity> messages = [];
    if (data['mensajes'] != null) {
      messages = (data['mensajes'] as List)
          .map((msg) => MessageEntity.fromApiJson(msg))
          .toList();
    }

    // Ordenar mensajes por fecha de creación
    messages.sort((a, b) {
      final aTime = a.createdAt ?? DateTime(1970);
      final bTime = b.createdAt ?? DateTime(1970);
      return aTime.compareTo(bTime); // Orden ascendente para mostrar cronológicamente
    });

    // Obtener último mensaje
    MessageEntity? lastMessage;
    if (messages.isNotEmpty) {
      lastMessage = messages.last; // El último mensaje después del ordenamiento
    }

    // Calcular mensajes no leídos (simplificado)
    int unreadCount = 0;
    for (final message in messages) {
      if (message.messageType == 'incoming' && 
          message.deliveryStatus == 'delivered') {
        unreadCount++;
      }
    }

    return ConversationWithMessages(
      conversation: conversation,
      messages: messages,
      unreadCount: unreadCount,
      lastMessage: lastMessage,
    );
  }
}

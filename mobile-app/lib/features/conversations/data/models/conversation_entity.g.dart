// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationEntityImpl _$$ConversationEntityImplFromJson(
  Map<String, dynamic> json,
) => _$ConversationEntityImpl(
  id: json['id'] as String,
  platform: json['platform'] as String,
  conversationType: json['conversationType'] as String,
  externalConversationId: json['externalConversationId'] as String?,
  userId: json['userId'] as String,
  username: json['username'] as String?,
  status: json['status'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  userCurrentEmotion: json['userCurrentEmotion'] as String?,
  userFullName: json['userFullName'] as String?,
  userProfession: json['userProfession'] as String?,
  userStudies: json['userStudies'] as String?,
  userExperienceYears: (json['userExperienceYears'] as num?)?.toInt(),
  userSkills: (json['userSkills'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  userLocation: json['userLocation'] as String?,
  userLanguages: (json['userLanguages'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  userSalaryExpectation: json['userSalaryExpectation'] as String?,
  userAvailability: json['userAvailability'] as String?,
  userInterests: (json['userInterests'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  userCompanySizePreference: json['userCompanySizePreference'] as String?,
  userIndustryPreference: (json['userIndustryPreference'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  userWorkModePreference: json['userWorkModePreference'] as String?,
  userCareerLevel: json['userCareerLevel'] as String?,
  userPortfolioUrl: json['userPortfolioUrl'] as String?,
  userLinkedinUrl: json['userLinkedinUrl'] as String?,
  userGithubUrl: json['userGithubUrl'] as String?,
  userDataCompletionPercentage: (json['userDataCompletionPercentage'] as num?)
      ?.toInt(),
  lastDataCollection: json['lastDataCollection'] == null
      ? null
      : DateTime.parse(json['lastDataCollection'] as String),
);

Map<String, dynamic> _$$ConversationEntityImplToJson(
  _$ConversationEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'platform': instance.platform,
  'conversationType': instance.conversationType,
  'externalConversationId': instance.externalConversationId,
  'userId': instance.userId,
  'username': instance.username,
  'status': instance.status,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'userCurrentEmotion': instance.userCurrentEmotion,
  'userFullName': instance.userFullName,
  'userProfession': instance.userProfession,
  'userStudies': instance.userStudies,
  'userExperienceYears': instance.userExperienceYears,
  'userSkills': instance.userSkills,
  'userLocation': instance.userLocation,
  'userLanguages': instance.userLanguages,
  'userSalaryExpectation': instance.userSalaryExpectation,
  'userAvailability': instance.userAvailability,
  'userInterests': instance.userInterests,
  'userCompanySizePreference': instance.userCompanySizePreference,
  'userIndustryPreference': instance.userIndustryPreference,
  'userWorkModePreference': instance.userWorkModePreference,
  'userCareerLevel': instance.userCareerLevel,
  'userPortfolioUrl': instance.userPortfolioUrl,
  'userLinkedinUrl': instance.userLinkedinUrl,
  'userGithubUrl': instance.userGithubUrl,
  'userDataCompletionPercentage': instance.userDataCompletionPercentage,
  'lastDataCollection': instance.lastDataCollection?.toIso8601String(),
};

_$MessageEntityImpl _$$MessageEntityImplFromJson(Map<String, dynamic> json) =>
    _$MessageEntityImpl(
      id: json['id'] as String,
      conversacionId: json['conversacionId'] as String?,
      platformMessageId: json['platformMessageId'] as String?,
      content: json['content'] as String,
      messageType: json['messageType'] as String,
      mediaContext: json['mediaContext'] as Map<String, dynamic>?,
      isAiGenerated: json['isAiGenerated'] as bool?,
      aiModel: json['aiModel'] as String?,
      authorName: json['authorName'] as String?,
      authorType: json['authorType'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      sentAt: json['sentAt'] == null
          ? null
          : DateTime.parse(json['sentAt'] as String),
      deliveryStatus: json['deliveryStatus'] as String?,
    );

Map<String, dynamic> _$$MessageEntityImplToJson(_$MessageEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversacionId': instance.conversacionId,
      'platformMessageId': instance.platformMessageId,
      'content': instance.content,
      'messageType': instance.messageType,
      'mediaContext': instance.mediaContext,
      'isAiGenerated': instance.isAiGenerated,
      'aiModel': instance.aiModel,
      'authorName': instance.authorName,
      'authorType': instance.authorType,
      'createdAt': instance.createdAt?.toIso8601String(),
      'sentAt': instance.sentAt?.toIso8601String(),
      'deliveryStatus': instance.deliveryStatus,
    };

_$ConversationWithMessagesImpl _$$ConversationWithMessagesImplFromJson(
  Map<String, dynamic> json,
) => _$ConversationWithMessagesImpl(
  conversation: ConversationEntity.fromJson(
    json['conversation'] as Map<String, dynamic>,
  ),
  messages: (json['messages'] as List<dynamic>?)
      ?.map((e) => MessageEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
  unreadCount: (json['unreadCount'] as num?)?.toInt(),
  lastMessage: json['lastMessage'] == null
      ? null
      : MessageEntity.fromJson(json['lastMessage'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$ConversationWithMessagesImplToJson(
  _$ConversationWithMessagesImpl instance,
) => <String, dynamic>{
  'conversation': instance.conversation,
  'messages': instance.messages,
  'unreadCount': instance.unreadCount,
  'lastMessage': instance.lastMessage,
};

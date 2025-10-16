// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationModelImpl _$$ConversationModelImplFromJson(
  Map<String, dynamic> json,
) => _$ConversationModelImpl(
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
);

Map<String, dynamic> _$$ConversationModelImplToJson(
  _$ConversationModelImpl instance,
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
      'createdAt': instance.createdAt?.toIso8601String(),
      'sentAt': instance.sentAt?.toIso8601String(),
      'deliveryStatus': instance.deliveryStatus,
    };

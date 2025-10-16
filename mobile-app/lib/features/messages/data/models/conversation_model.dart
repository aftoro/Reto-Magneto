import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

@freezed
class ConversationModel with _$ConversationModel {
  const factory ConversationModel({
    required String id,
    required String platform,
    required String conversationType,
    String? externalConversationId,
    required String userId,
    String? username,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);
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
    DateTime? createdAt,
    DateTime? sentAt,
    String? deliveryStatus,
  }) = _MessageEntity;

  factory MessageEntity.fromJson(Map<String, dynamic> json) =>
      _$MessageEntityFromJson(json);
}

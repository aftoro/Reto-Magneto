// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      message: json['message'] as String,
      recipientId: json['recipientId'] as String,
      senderName: json['senderName'] as String?,
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'recipientId': instance.recipientId,
      'senderName': instance.senderName,
    };

_$SendMessageRequestImpl _$$SendMessageRequestImplFromJson(
  Map<String, dynamic> json,
) => _$SendMessageRequestImpl(
  message: json['message'] as String,
  recipient_id: json['recipient_id'] as String,
  sender_name: json['sender_name'] as String?,
);

Map<String, dynamic> _$$SendMessageRequestImplToJson(
  _$SendMessageRequestImpl instance,
) => <String, dynamic>{
  'message': instance.message,
  'recipient_id': instance.recipient_id,
  'sender_name': instance.sender_name,
};

_$SendMessageResponseImpl _$$SendMessageResponseImplFromJson(
  Map<String, dynamic> json,
) => _$SendMessageResponseImpl(
  success: json['success'] as bool,
  message: json['message'] as String?,
  error: json['error'] as String?,
);

Map<String, dynamic> _$$SendMessageResponseImplToJson(
  _$SendMessageResponseImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'error': instance.error,
};

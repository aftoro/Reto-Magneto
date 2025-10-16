// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreatePostRequestImpl _$$CreatePostRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreatePostRequestImpl(
  topic: json['topic'] as String,
  style: json['style'] as String?,
  target_audience: json['target_audience'] as String?,
  reference_image: json['reference_image'] as String?,
);

Map<String, dynamic> _$$CreatePostRequestImplToJson(
  _$CreatePostRequestImpl instance,
) => <String, dynamic>{
  'topic': instance.topic,
  'style': instance.style,
  'target_audience': instance.target_audience,
  'reference_image': instance.reference_image,
};

_$CreatePostResponseImpl _$$CreatePostResponseImplFromJson(
  Map<String, dynamic> json,
) => _$CreatePostResponseImpl(
  success: json['success'] as bool,
  message: json['message'] as String?,
  error: json['error'] as String?,
  post_url: json['post_url'] as String?,
  story_url: json['story_url'] as String?,
);

Map<String, dynamic> _$$CreatePostResponseImplToJson(
  _$CreatePostResponseImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'error': instance.error,
  'post_url': instance.post_url,
  'story_url': instance.story_url,
};

_$CreateStoryRequestImpl _$$CreateStoryRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateStoryRequestImpl(
  topic: json['topic'] as String,
  style: json['style'] as String?,
  target_audience: json['target_audience'] as String?,
  reference_image: json['reference_image'] as String?,
);

Map<String, dynamic> _$$CreateStoryRequestImplToJson(
  _$CreateStoryRequestImpl instance,
) => <String, dynamic>{
  'topic': instance.topic,
  'style': instance.style,
  'target_audience': instance.target_audience,
  'reference_image': instance.reference_image,
};

_$CreateStoryResponseImpl _$$CreateStoryResponseImplFromJson(
  Map<String, dynamic> json,
) => _$CreateStoryResponseImpl(
  success: json['success'] as bool,
  message: json['message'] as String?,
  error: json['error'] as String?,
  story_url: json['story_url'] as String?,
);

Map<String, dynamic> _$$CreateStoryResponseImplToJson(
  _$CreateStoryResponseImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'error': instance.error,
  'story_url': instance.story_url,
};

_$PostModelImpl _$$PostModelImplFromJson(Map<String, dynamic> json) =>
    _$PostModelImpl(
      topic: json['topic'] as String,
      style: json['style'] as String?,
      targetAudience: json['targetAudience'] as String?,
      referenceImagePath: json['referenceImagePath'] as String?,
    );

Map<String, dynamic> _$$PostModelImplToJson(_$PostModelImpl instance) =>
    <String, dynamic>{
      'topic': instance.topic,
      'style': instance.style,
      'targetAudience': instance.targetAudience,
      'referenceImagePath': instance.referenceImagePath,
    };

_$StoryModelImpl _$$StoryModelImplFromJson(Map<String, dynamic> json) =>
    _$StoryModelImpl(
      topic: json['topic'] as String,
      style: json['style'] as String?,
      targetAudience: json['targetAudience'] as String?,
      referenceImagePath: json['referenceImagePath'] as String?,
    );

Map<String, dynamic> _$$StoryModelImplToJson(_$StoryModelImpl instance) =>
    <String, dynamic>{
      'topic': instance.topic,
      'style': instance.style,
      'targetAudience': instance.targetAudience,
      'referenceImagePath': instance.referenceImagePath,
    };

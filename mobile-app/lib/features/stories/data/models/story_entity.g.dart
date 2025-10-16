// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoryEntityImpl _$$StoryEntityImplFromJson(Map<String, dynamic> json) =>
    _$StoryEntityImpl(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      aiGenerated: json['aiGenerated'] as bool,
      aiPrompt: json['aiPrompt'] as String?,
      status: json['status'] as String,
      instagramStoryId: json['instagramStoryId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
      createdBy: json['createdBy'] as String,
    );

Map<String, dynamic> _$$StoryEntityImplToJson(_$StoryEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'aiGenerated': instance.aiGenerated,
      'aiPrompt': instance.aiPrompt,
      'status': instance.status,
      'instagramStoryId': instance.instagramStoryId,
      'createdAt': instance.createdAt.toIso8601String(),
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
    };

_$StoriesResponseImpl _$$StoriesResponseImplFromJson(
  Map<String, dynamic> json,
) => _$StoriesResponseImpl(
  stories: (json['stories'] as List<dynamic>)
      .map((e) => StoryEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  offset: (json['offset'] as num).toInt(),
);

Map<String, dynamic> _$$StoriesResponseImplToJson(
  _$StoriesResponseImpl instance,
) => <String, dynamic>{
  'stories': instance.stories,
  'total': instance.total,
  'limit': instance.limit,
  'offset': instance.offset,
};

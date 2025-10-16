import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_entity.freezed.dart';
part 'story_entity.g.dart';

@freezed
class StoryEntity with _$StoryEntity {
  const factory StoryEntity({
    required String id,
    required String imageUrl,
    required bool aiGenerated,
    String? aiPrompt,
    required String status,
    String? instagramStoryId,
    required DateTime createdAt,
    DateTime? publishedAt,
    required String createdBy,
  }) = _StoryEntity;

  factory StoryEntity.fromJson(Map<String, dynamic> json) =>
      _$StoryEntityFromJson(json);

  factory StoryEntity.fromApiJson(Map<String, dynamic> data) {
    return StoryEntity(
      id: data['id']?.toString() ?? '',
      imageUrl: data['image_url']?.toString() ?? '',
      aiGenerated: data['ai_generated'] as bool? ?? false,
      aiPrompt: data['ai_prompt']?.toString(),
      status: data['status']?.toString() ?? 'created',
      instagramStoryId: data['instagram_story_id']?.toString(),
      createdAt: data['created_at'] != null 
          ? DateTime.tryParse(data['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      publishedAt: data['published_at'] != null 
          ? DateTime.tryParse(data['published_at'].toString())
          : null,
      createdBy: data['created_by']?.toString() ?? 'ai_system',
    );
  }
}

@freezed
class StoriesResponse with _$StoriesResponse {
  const factory StoriesResponse({
    required List<StoryEntity> stories,
    required int total,
    required int limit,
    required int offset,
  }) = _StoriesResponse;

  factory StoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$StoriesResponseFromJson(json);

  factory StoriesResponse.fromApiJson(Map<String, dynamic> data) {
    try {
      final storiesList = data['stories'] as List? ?? [];
      final stories = <StoryEntity>[];
      
      for (final storyData in storiesList) {
        if (storyData != null && storyData is Map<String, dynamic>) {
          try {
            final story = StoryEntity.fromApiJson(storyData);
            stories.add(story);
          } catch (e) {
            print('Error al procesar story individual: $e');
          }
        }
      }

      return StoriesResponse(
        stories: stories,
        total: data['total'] as int? ?? 0,
        limit: data['limit'] as int? ?? 20,
        offset: data['offset'] as int? ?? 0,
      );
    } catch (e) {
      print('Error al procesar respuesta de stories: $e');
      return StoriesResponse(
        stories: [],
        total: 0,
        limit: 20,
        offset: 0,
      );
    }
  }
}

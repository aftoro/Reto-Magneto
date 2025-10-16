import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class CreatePostRequest with _$CreatePostRequest {
  const factory CreatePostRequest({
    required String topic,
    String? style,
    String? target_audience,
    String? reference_image,
  }) = _CreatePostRequest;

  factory CreatePostRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePostRequestFromJson(json);
}

@freezed
class CreatePostResponse with _$CreatePostResponse {
  const factory CreatePostResponse({
    required bool success,
    String? message,
    String? error,
    String? post_url,
    String? story_url,
  }) = _CreatePostResponse;

  factory CreatePostResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatePostResponseFromJson(json);
}

@freezed
class CreateStoryRequest with _$CreateStoryRequest {
  const factory CreateStoryRequest({
    required String topic,
    String? style,
    String? target_audience,
    String? reference_image,
  }) = _CreateStoryRequest;

  factory CreateStoryRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateStoryRequestFromJson(json);
}

@freezed
class CreateStoryResponse with _$CreateStoryResponse {
  const factory CreateStoryResponse({
    required bool success,
    String? message,
    String? error,
    String? story_url,
  }) = _CreateStoryResponse;

  factory CreateStoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateStoryResponseFromJson(json);
}

@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required String topic,
    String? style,
    String? targetAudience,
    String? referenceImagePath,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}

@freezed
class StoryModel with _$StoryModel {
  const factory StoryModel({
    required String topic,
    String? style,
    String? targetAudience,
    String? referenceImagePath,
  }) = _StoryModel;

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'instagram_post_entity.freezed.dart';
part 'instagram_post_entity.g.dart';

@freezed
class InstagramPostEntity with _$InstagramPostEntity {
  const factory InstagramPostEntity({
    required String id,
    required String mediaId,
    required String instagramPostId,
    required String mediaType,
    required String imageUrl,
    required String mediaUrl,
    required String caption,
    required String permalink,
    required DateTime timestamp,
    required DateTime createdAt,
    int? commentsCount,
    int? likesCount,
    int? sharesCount,
  }) = _InstagramPostEntity;

  factory InstagramPostEntity.fromJson(Map<String, dynamic> json) =>
      _$InstagramPostEntityFromJson(json);

  factory InstagramPostEntity.fromApiJson(Map<String, dynamic> data) {
    // Extraer estadísticas del objeto stats si existe
    final stats = data['stats'] as Map<String, dynamic>?;
    
    return InstagramPostEntity(
      id: data['id']?.toString() ?? '',
      mediaId: data['media_id']?.toString() ?? '',
      instagramPostId: data['instagram_post_id']?.toString() ?? '',
      mediaType: data['media_type']?.toString() ?? 'IMAGE',
      imageUrl: data['image_url']?.toString() ?? '',
      mediaUrl: data['media_url']?.toString() ?? '',
      caption: data['caption']?.toString() ?? '',
      permalink: data['permalink']?.toString() ?? '',
      timestamp: data['timestamp'] != null 
          ? DateTime.tryParse(data['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      createdAt: data['created_at'] != null 
          ? DateTime.tryParse(data['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      // Usar estadísticas del objeto stats si está disponible, sino usar valores directos
      commentsCount: stats?['total_comments'] as int? ?? data['comments_count'] as int?,
      likesCount: stats?['likes'] as int? ?? data['likes_count'] as int?,
      sharesCount: data['shares_count'] as int?,
    );
  }
}

@freezed
class InstagramCommentEntity with _$InstagramCommentEntity {
  const factory InstagramCommentEntity({
    required String id,
    required String postId,
    required String instagramCommentId,
    required String userId,
    required String username,
    required String commentText,
    required bool isAiResponse,
    String? aiModel,
    required DateTime createdAt,
    List<InstagramCommentEntity>? replies,
  }) = _InstagramCommentEntity;

  factory InstagramCommentEntity.fromJson(Map<String, dynamic> json) =>
      _$InstagramCommentEntityFromJson(json);

  factory InstagramCommentEntity.fromApiJson(Map<String, dynamic> data) {
    return InstagramCommentEntity(
      id: data['id']?.toString() ?? '',
      postId: data['post_id']?.toString() ?? '',
      instagramCommentId: data['instagram_comment_id']?.toString() ?? '',
      userId: data['user_id']?.toString() ?? '',
      username: data['username']?.toString() ?? '',
      commentText: data['comment_text']?.toString() ?? '',
      isAiResponse: data['is_ai_response'] as bool? ?? false,
      aiModel: data['ai_model']?.toString(),
      createdAt: data['created_at'] != null 
          ? DateTime.tryParse(data['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      replies: data['replies'] != null 
          ? (data['replies'] as List)
              .map((reply) => InstagramCommentEntity.fromApiJson(reply))
              .toList()
          : null,
    );
  }
}

@freezed
class InstagramPostsResponse with _$InstagramPostsResponse {
  const factory InstagramPostsResponse({
    required bool success,
    required List<InstagramPostEntity> data,
    required InstagramPagination pagination,
  }) = _InstagramPostsResponse;

  factory InstagramPostsResponse.fromJson(Map<String, dynamic> json) =>
      _$InstagramPostsResponseFromJson(json);

  factory InstagramPostsResponse.fromApiJson(Map<String, dynamic> data) {
    try {
      final postsList = data['data'] as List? ?? [];
      final posts = <InstagramPostEntity>[];
      
      for (final postData in postsList) {
        if (postData != null && postData is Map<String, dynamic>) {
          try {
            final post = InstagramPostEntity.fromApiJson(postData);
            posts.add(post);
          } catch (e) {
            print('Error al procesar post individual: $e');
          }
        }
      }

      final pagination = InstagramPagination.fromApiJson(data['pagination'] ?? {});

      return InstagramPostsResponse(
        success: data['success'] ?? true,
        data: posts,
        pagination: pagination,
      );
    } catch (e) {
      print('Error al procesar respuesta de posts: $e');
      return InstagramPostsResponse(
        success: false,
        data: [],
        pagination: InstagramPagination(
          page: 1,
          limit: 20,
          total: 0,
        ),
      );
    }
  }
}

@freezed
class InstagramCommentsResponse with _$InstagramCommentsResponse {
  const factory InstagramCommentsResponse({
    required bool success,
    required List<InstagramCommentEntity> data,
    required int count,
  }) = _InstagramCommentsResponse;

  factory InstagramCommentsResponse.fromJson(Map<String, dynamic> json) =>
      _$InstagramCommentsResponseFromJson(json);

  factory InstagramCommentsResponse.fromApiJson(Map<String, dynamic> data) {
    try {
      final commentsList = data['data'] as List? ?? [];
      final comments = <InstagramCommentEntity>[];
      
      for (final commentData in commentsList) {
        if (commentData != null && commentData is Map<String, dynamic>) {
          try {
            final comment = InstagramCommentEntity.fromApiJson(commentData);
            comments.add(comment);
          } catch (e) {
            print('Error al procesar comentario individual: $e');
          }
        }
      }

      return InstagramCommentsResponse(
        success: data['success'] ?? true,
        data: comments,
        count: data['count'] ?? comments.length,
      );
    } catch (e) {
      print('Error al procesar respuesta de comentarios: $e');
      return InstagramCommentsResponse(
        success: false,
        data: [],
        count: 0,
      );
    }
  }
}

@freezed
class InstagramPagination with _$InstagramPagination {
  const factory InstagramPagination({
    required int page,
    required int limit,
    required int total,
  }) = _InstagramPagination;

  factory InstagramPagination.fromJson(Map<String, dynamic> json) =>
      _$InstagramPaginationFromJson(json);

  factory InstagramPagination.fromApiJson(Map<String, dynamic> data) {
    return InstagramPagination(
      page: data['page'] ?? 1,
      limit: data['limit'] ?? 20,
      total: data['total'] ?? 0,
    );
  }
}

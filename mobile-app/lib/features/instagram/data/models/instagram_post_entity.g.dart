// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instagram_post_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InstagramPostEntityImpl _$$InstagramPostEntityImplFromJson(
  Map<String, dynamic> json,
) => _$InstagramPostEntityImpl(
  id: json['id'] as String,
  mediaId: json['mediaId'] as String,
  instagramPostId: json['instagramPostId'] as String,
  mediaType: json['mediaType'] as String,
  imageUrl: json['imageUrl'] as String,
  mediaUrl: json['mediaUrl'] as String,
  caption: json['caption'] as String,
  permalink: json['permalink'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  commentsCount: (json['commentsCount'] as num?)?.toInt(),
  likesCount: (json['likesCount'] as num?)?.toInt(),
  sharesCount: (json['sharesCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$$InstagramPostEntityImplToJson(
  _$InstagramPostEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'mediaId': instance.mediaId,
  'instagramPostId': instance.instagramPostId,
  'mediaType': instance.mediaType,
  'imageUrl': instance.imageUrl,
  'mediaUrl': instance.mediaUrl,
  'caption': instance.caption,
  'permalink': instance.permalink,
  'timestamp': instance.timestamp.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'commentsCount': instance.commentsCount,
  'likesCount': instance.likesCount,
  'sharesCount': instance.sharesCount,
};

_$InstagramCommentEntityImpl _$$InstagramCommentEntityImplFromJson(
  Map<String, dynamic> json,
) => _$InstagramCommentEntityImpl(
  id: json['id'] as String,
  postId: json['postId'] as String,
  instagramCommentId: json['instagramCommentId'] as String,
  userId: json['userId'] as String,
  username: json['username'] as String,
  commentText: json['commentText'] as String,
  isAiResponse: json['isAiResponse'] as bool,
  aiModel: json['aiModel'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  replies: (json['replies'] as List<dynamic>?)
      ?.map((e) => InstagramCommentEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$InstagramCommentEntityImplToJson(
  _$InstagramCommentEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'postId': instance.postId,
  'instagramCommentId': instance.instagramCommentId,
  'userId': instance.userId,
  'username': instance.username,
  'commentText': instance.commentText,
  'isAiResponse': instance.isAiResponse,
  'aiModel': instance.aiModel,
  'createdAt': instance.createdAt.toIso8601String(),
  'replies': instance.replies,
};

_$InstagramPostsResponseImpl _$$InstagramPostsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$InstagramPostsResponseImpl(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => InstagramPostEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
  pagination: InstagramPagination.fromJson(
    json['pagination'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$InstagramPostsResponseImplToJson(
  _$InstagramPostsResponseImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'pagination': instance.pagination,
};

_$InstagramCommentsResponseImpl _$$InstagramCommentsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$InstagramCommentsResponseImpl(
  success: json['success'] as bool,
  data: (json['data'] as List<dynamic>)
      .map((e) => InstagramCommentEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$$InstagramCommentsResponseImplToJson(
  _$InstagramCommentsResponseImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data,
  'count': instance.count,
};

_$InstagramPaginationImpl _$$InstagramPaginationImplFromJson(
  Map<String, dynamic> json,
) => _$InstagramPaginationImpl(
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$$InstagramPaginationImplToJson(
  _$InstagramPaginationImpl instance,
) => <String, dynamic>{
  'page': instance.page,
  'limit': instance.limit,
  'total': instance.total,
};

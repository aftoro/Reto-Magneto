// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'instagram_post_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

InstagramPostEntity _$InstagramPostEntityFromJson(Map<String, dynamic> json) {
  return _InstagramPostEntity.fromJson(json);
}

/// @nodoc
mixin _$InstagramPostEntity {
  String get id => throw _privateConstructorUsedError;
  String get mediaId => throw _privateConstructorUsedError;
  String get instagramPostId => throw _privateConstructorUsedError;
  String get mediaType => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get mediaUrl => throw _privateConstructorUsedError;
  String get caption => throw _privateConstructorUsedError;
  String get permalink => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  int? get commentsCount => throw _privateConstructorUsedError;
  int? get likesCount => throw _privateConstructorUsedError;
  int? get sharesCount => throw _privateConstructorUsedError;

  /// Serializes this InstagramPostEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InstagramPostEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InstagramPostEntityCopyWith<InstagramPostEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstagramPostEntityCopyWith<$Res> {
  factory $InstagramPostEntityCopyWith(
    InstagramPostEntity value,
    $Res Function(InstagramPostEntity) then,
  ) = _$InstagramPostEntityCopyWithImpl<$Res, InstagramPostEntity>;
  @useResult
  $Res call({
    String id,
    String mediaId,
    String instagramPostId,
    String mediaType,
    String imageUrl,
    String mediaUrl,
    String caption,
    String permalink,
    DateTime timestamp,
    DateTime createdAt,
    int? commentsCount,
    int? likesCount,
    int? sharesCount,
  });
}

/// @nodoc
class _$InstagramPostEntityCopyWithImpl<$Res, $Val extends InstagramPostEntity>
    implements $InstagramPostEntityCopyWith<$Res> {
  _$InstagramPostEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InstagramPostEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mediaId = null,
    Object? instagramPostId = null,
    Object? mediaType = null,
    Object? imageUrl = null,
    Object? mediaUrl = null,
    Object? caption = null,
    Object? permalink = null,
    Object? timestamp = null,
    Object? createdAt = null,
    Object? commentsCount = freezed,
    Object? likesCount = freezed,
    Object? sharesCount = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            mediaId: null == mediaId
                ? _value.mediaId
                : mediaId // ignore: cast_nullable_to_non_nullable
                      as String,
            instagramPostId: null == instagramPostId
                ? _value.instagramPostId
                : instagramPostId // ignore: cast_nullable_to_non_nullable
                      as String,
            mediaType: null == mediaType
                ? _value.mediaType
                : mediaType // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            mediaUrl: null == mediaUrl
                ? _value.mediaUrl
                : mediaUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            caption: null == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String,
            permalink: null == permalink
                ? _value.permalink
                : permalink // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            commentsCount: freezed == commentsCount
                ? _value.commentsCount
                : commentsCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            likesCount: freezed == likesCount
                ? _value.likesCount
                : likesCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            sharesCount: freezed == sharesCount
                ? _value.sharesCount
                : sharesCount // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InstagramPostEntityImplCopyWith<$Res>
    implements $InstagramPostEntityCopyWith<$Res> {
  factory _$$InstagramPostEntityImplCopyWith(
    _$InstagramPostEntityImpl value,
    $Res Function(_$InstagramPostEntityImpl) then,
  ) = __$$InstagramPostEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String mediaId,
    String instagramPostId,
    String mediaType,
    String imageUrl,
    String mediaUrl,
    String caption,
    String permalink,
    DateTime timestamp,
    DateTime createdAt,
    int? commentsCount,
    int? likesCount,
    int? sharesCount,
  });
}

/// @nodoc
class __$$InstagramPostEntityImplCopyWithImpl<$Res>
    extends _$InstagramPostEntityCopyWithImpl<$Res, _$InstagramPostEntityImpl>
    implements _$$InstagramPostEntityImplCopyWith<$Res> {
  __$$InstagramPostEntityImplCopyWithImpl(
    _$InstagramPostEntityImpl _value,
    $Res Function(_$InstagramPostEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InstagramPostEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? mediaId = null,
    Object? instagramPostId = null,
    Object? mediaType = null,
    Object? imageUrl = null,
    Object? mediaUrl = null,
    Object? caption = null,
    Object? permalink = null,
    Object? timestamp = null,
    Object? createdAt = null,
    Object? commentsCount = freezed,
    Object? likesCount = freezed,
    Object? sharesCount = freezed,
  }) {
    return _then(
      _$InstagramPostEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        mediaId: null == mediaId
            ? _value.mediaId
            : mediaId // ignore: cast_nullable_to_non_nullable
                  as String,
        instagramPostId: null == instagramPostId
            ? _value.instagramPostId
            : instagramPostId // ignore: cast_nullable_to_non_nullable
                  as String,
        mediaType: null == mediaType
            ? _value.mediaType
            : mediaType // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        mediaUrl: null == mediaUrl
            ? _value.mediaUrl
            : mediaUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        caption: null == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String,
        permalink: null == permalink
            ? _value.permalink
            : permalink // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        commentsCount: freezed == commentsCount
            ? _value.commentsCount
            : commentsCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        likesCount: freezed == likesCount
            ? _value.likesCount
            : likesCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        sharesCount: freezed == sharesCount
            ? _value.sharesCount
            : sharesCount // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InstagramPostEntityImpl implements _InstagramPostEntity {
  const _$InstagramPostEntityImpl({
    required this.id,
    required this.mediaId,
    required this.instagramPostId,
    required this.mediaType,
    required this.imageUrl,
    required this.mediaUrl,
    required this.caption,
    required this.permalink,
    required this.timestamp,
    required this.createdAt,
    this.commentsCount,
    this.likesCount,
    this.sharesCount,
  });

  factory _$InstagramPostEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$InstagramPostEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String mediaId;
  @override
  final String instagramPostId;
  @override
  final String mediaType;
  @override
  final String imageUrl;
  @override
  final String mediaUrl;
  @override
  final String caption;
  @override
  final String permalink;
  @override
  final DateTime timestamp;
  @override
  final DateTime createdAt;
  @override
  final int? commentsCount;
  @override
  final int? likesCount;
  @override
  final int? sharesCount;

  @override
  String toString() {
    return 'InstagramPostEntity(id: $id, mediaId: $mediaId, instagramPostId: $instagramPostId, mediaType: $mediaType, imageUrl: $imageUrl, mediaUrl: $mediaUrl, caption: $caption, permalink: $permalink, timestamp: $timestamp, createdAt: $createdAt, commentsCount: $commentsCount, likesCount: $likesCount, sharesCount: $sharesCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstagramPostEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mediaId, mediaId) || other.mediaId == mediaId) &&
            (identical(other.instagramPostId, instagramPostId) ||
                other.instagramPostId == instagramPostId) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.permalink, permalink) ||
                other.permalink == permalink) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.commentsCount, commentsCount) ||
                other.commentsCount == commentsCount) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.sharesCount, sharesCount) ||
                other.sharesCount == sharesCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    mediaId,
    instagramPostId,
    mediaType,
    imageUrl,
    mediaUrl,
    caption,
    permalink,
    timestamp,
    createdAt,
    commentsCount,
    likesCount,
    sharesCount,
  );

  /// Create a copy of InstagramPostEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InstagramPostEntityImplCopyWith<_$InstagramPostEntityImpl> get copyWith =>
      __$$InstagramPostEntityImplCopyWithImpl<_$InstagramPostEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InstagramPostEntityImplToJson(this);
  }
}

abstract class _InstagramPostEntity implements InstagramPostEntity {
  const factory _InstagramPostEntity({
    required final String id,
    required final String mediaId,
    required final String instagramPostId,
    required final String mediaType,
    required final String imageUrl,
    required final String mediaUrl,
    required final String caption,
    required final String permalink,
    required final DateTime timestamp,
    required final DateTime createdAt,
    final int? commentsCount,
    final int? likesCount,
    final int? sharesCount,
  }) = _$InstagramPostEntityImpl;

  factory _InstagramPostEntity.fromJson(Map<String, dynamic> json) =
      _$InstagramPostEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get mediaId;
  @override
  String get instagramPostId;
  @override
  String get mediaType;
  @override
  String get imageUrl;
  @override
  String get mediaUrl;
  @override
  String get caption;
  @override
  String get permalink;
  @override
  DateTime get timestamp;
  @override
  DateTime get createdAt;
  @override
  int? get commentsCount;
  @override
  int? get likesCount;
  @override
  int? get sharesCount;

  /// Create a copy of InstagramPostEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InstagramPostEntityImplCopyWith<_$InstagramPostEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InstagramCommentEntity _$InstagramCommentEntityFromJson(
  Map<String, dynamic> json,
) {
  return _InstagramCommentEntity.fromJson(json);
}

/// @nodoc
mixin _$InstagramCommentEntity {
  String get id => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  String get instagramCommentId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get commentText => throw _privateConstructorUsedError;
  bool get isAiResponse => throw _privateConstructorUsedError;
  String? get aiModel => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  List<InstagramCommentEntity>? get replies =>
      throw _privateConstructorUsedError;

  /// Serializes this InstagramCommentEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InstagramCommentEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InstagramCommentEntityCopyWith<InstagramCommentEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstagramCommentEntityCopyWith<$Res> {
  factory $InstagramCommentEntityCopyWith(
    InstagramCommentEntity value,
    $Res Function(InstagramCommentEntity) then,
  ) = _$InstagramCommentEntityCopyWithImpl<$Res, InstagramCommentEntity>;
  @useResult
  $Res call({
    String id,
    String postId,
    String instagramCommentId,
    String userId,
    String username,
    String commentText,
    bool isAiResponse,
    String? aiModel,
    DateTime createdAt,
    List<InstagramCommentEntity>? replies,
  });
}

/// @nodoc
class _$InstagramCommentEntityCopyWithImpl<
  $Res,
  $Val extends InstagramCommentEntity
>
    implements $InstagramCommentEntityCopyWith<$Res> {
  _$InstagramCommentEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InstagramCommentEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? instagramCommentId = null,
    Object? userId = null,
    Object? username = null,
    Object? commentText = null,
    Object? isAiResponse = null,
    Object? aiModel = freezed,
    Object? createdAt = null,
    Object? replies = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            postId: null == postId
                ? _value.postId
                : postId // ignore: cast_nullable_to_non_nullable
                      as String,
            instagramCommentId: null == instagramCommentId
                ? _value.instagramCommentId
                : instagramCommentId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            commentText: null == commentText
                ? _value.commentText
                : commentText // ignore: cast_nullable_to_non_nullable
                      as String,
            isAiResponse: null == isAiResponse
                ? _value.isAiResponse
                : isAiResponse // ignore: cast_nullable_to_non_nullable
                      as bool,
            aiModel: freezed == aiModel
                ? _value.aiModel
                : aiModel // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            replies: freezed == replies
                ? _value.replies
                : replies // ignore: cast_nullable_to_non_nullable
                      as List<InstagramCommentEntity>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InstagramCommentEntityImplCopyWith<$Res>
    implements $InstagramCommentEntityCopyWith<$Res> {
  factory _$$InstagramCommentEntityImplCopyWith(
    _$InstagramCommentEntityImpl value,
    $Res Function(_$InstagramCommentEntityImpl) then,
  ) = __$$InstagramCommentEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String postId,
    String instagramCommentId,
    String userId,
    String username,
    String commentText,
    bool isAiResponse,
    String? aiModel,
    DateTime createdAt,
    List<InstagramCommentEntity>? replies,
  });
}

/// @nodoc
class __$$InstagramCommentEntityImplCopyWithImpl<$Res>
    extends
        _$InstagramCommentEntityCopyWithImpl<$Res, _$InstagramCommentEntityImpl>
    implements _$$InstagramCommentEntityImplCopyWith<$Res> {
  __$$InstagramCommentEntityImplCopyWithImpl(
    _$InstagramCommentEntityImpl _value,
    $Res Function(_$InstagramCommentEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InstagramCommentEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? instagramCommentId = null,
    Object? userId = null,
    Object? username = null,
    Object? commentText = null,
    Object? isAiResponse = null,
    Object? aiModel = freezed,
    Object? createdAt = null,
    Object? replies = freezed,
  }) {
    return _then(
      _$InstagramCommentEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        postId: null == postId
            ? _value.postId
            : postId // ignore: cast_nullable_to_non_nullable
                  as String,
        instagramCommentId: null == instagramCommentId
            ? _value.instagramCommentId
            : instagramCommentId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        commentText: null == commentText
            ? _value.commentText
            : commentText // ignore: cast_nullable_to_non_nullable
                  as String,
        isAiResponse: null == isAiResponse
            ? _value.isAiResponse
            : isAiResponse // ignore: cast_nullable_to_non_nullable
                  as bool,
        aiModel: freezed == aiModel
            ? _value.aiModel
            : aiModel // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        replies: freezed == replies
            ? _value._replies
            : replies // ignore: cast_nullable_to_non_nullable
                  as List<InstagramCommentEntity>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InstagramCommentEntityImpl implements _InstagramCommentEntity {
  const _$InstagramCommentEntityImpl({
    required this.id,
    required this.postId,
    required this.instagramCommentId,
    required this.userId,
    required this.username,
    required this.commentText,
    required this.isAiResponse,
    this.aiModel,
    required this.createdAt,
    final List<InstagramCommentEntity>? replies,
  }) : _replies = replies;

  factory _$InstagramCommentEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$InstagramCommentEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String postId;
  @override
  final String instagramCommentId;
  @override
  final String userId;
  @override
  final String username;
  @override
  final String commentText;
  @override
  final bool isAiResponse;
  @override
  final String? aiModel;
  @override
  final DateTime createdAt;
  final List<InstagramCommentEntity>? _replies;
  @override
  List<InstagramCommentEntity>? get replies {
    final value = _replies;
    if (value == null) return null;
    if (_replies is EqualUnmodifiableListView) return _replies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'InstagramCommentEntity(id: $id, postId: $postId, instagramCommentId: $instagramCommentId, userId: $userId, username: $username, commentText: $commentText, isAiResponse: $isAiResponse, aiModel: $aiModel, createdAt: $createdAt, replies: $replies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstagramCommentEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.instagramCommentId, instagramCommentId) ||
                other.instagramCommentId == instagramCommentId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.commentText, commentText) ||
                other.commentText == commentText) &&
            (identical(other.isAiResponse, isAiResponse) ||
                other.isAiResponse == isAiResponse) &&
            (identical(other.aiModel, aiModel) || other.aiModel == aiModel) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._replies, _replies));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    postId,
    instagramCommentId,
    userId,
    username,
    commentText,
    isAiResponse,
    aiModel,
    createdAt,
    const DeepCollectionEquality().hash(_replies),
  );

  /// Create a copy of InstagramCommentEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InstagramCommentEntityImplCopyWith<_$InstagramCommentEntityImpl>
  get copyWith =>
      __$$InstagramCommentEntityImplCopyWithImpl<_$InstagramCommentEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InstagramCommentEntityImplToJson(this);
  }
}

abstract class _InstagramCommentEntity implements InstagramCommentEntity {
  const factory _InstagramCommentEntity({
    required final String id,
    required final String postId,
    required final String instagramCommentId,
    required final String userId,
    required final String username,
    required final String commentText,
    required final bool isAiResponse,
    final String? aiModel,
    required final DateTime createdAt,
    final List<InstagramCommentEntity>? replies,
  }) = _$InstagramCommentEntityImpl;

  factory _InstagramCommentEntity.fromJson(Map<String, dynamic> json) =
      _$InstagramCommentEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get postId;
  @override
  String get instagramCommentId;
  @override
  String get userId;
  @override
  String get username;
  @override
  String get commentText;
  @override
  bool get isAiResponse;
  @override
  String? get aiModel;
  @override
  DateTime get createdAt;
  @override
  List<InstagramCommentEntity>? get replies;

  /// Create a copy of InstagramCommentEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InstagramCommentEntityImplCopyWith<_$InstagramCommentEntityImpl>
  get copyWith => throw _privateConstructorUsedError;
}

InstagramPostsResponse _$InstagramPostsResponseFromJson(
  Map<String, dynamic> json,
) {
  return _InstagramPostsResponse.fromJson(json);
}

/// @nodoc
mixin _$InstagramPostsResponse {
  bool get success => throw _privateConstructorUsedError;
  List<InstagramPostEntity> get data => throw _privateConstructorUsedError;
  InstagramPagination get pagination => throw _privateConstructorUsedError;

  /// Serializes this InstagramPostsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InstagramPostsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InstagramPostsResponseCopyWith<InstagramPostsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstagramPostsResponseCopyWith<$Res> {
  factory $InstagramPostsResponseCopyWith(
    InstagramPostsResponse value,
    $Res Function(InstagramPostsResponse) then,
  ) = _$InstagramPostsResponseCopyWithImpl<$Res, InstagramPostsResponse>;
  @useResult
  $Res call({
    bool success,
    List<InstagramPostEntity> data,
    InstagramPagination pagination,
  });

  $InstagramPaginationCopyWith<$Res> get pagination;
}

/// @nodoc
class _$InstagramPostsResponseCopyWithImpl<
  $Res,
  $Val extends InstagramPostsResponse
>
    implements $InstagramPostsResponseCopyWith<$Res> {
  _$InstagramPostsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InstagramPostsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? pagination = null,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<InstagramPostEntity>,
            pagination: null == pagination
                ? _value.pagination
                : pagination // ignore: cast_nullable_to_non_nullable
                      as InstagramPagination,
          )
          as $Val,
    );
  }

  /// Create a copy of InstagramPostsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InstagramPaginationCopyWith<$Res> get pagination {
    return $InstagramPaginationCopyWith<$Res>(_value.pagination, (value) {
      return _then(_value.copyWith(pagination: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InstagramPostsResponseImplCopyWith<$Res>
    implements $InstagramPostsResponseCopyWith<$Res> {
  factory _$$InstagramPostsResponseImplCopyWith(
    _$InstagramPostsResponseImpl value,
    $Res Function(_$InstagramPostsResponseImpl) then,
  ) = __$$InstagramPostsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool success,
    List<InstagramPostEntity> data,
    InstagramPagination pagination,
  });

  @override
  $InstagramPaginationCopyWith<$Res> get pagination;
}

/// @nodoc
class __$$InstagramPostsResponseImplCopyWithImpl<$Res>
    extends
        _$InstagramPostsResponseCopyWithImpl<$Res, _$InstagramPostsResponseImpl>
    implements _$$InstagramPostsResponseImplCopyWith<$Res> {
  __$$InstagramPostsResponseImplCopyWithImpl(
    _$InstagramPostsResponseImpl _value,
    $Res Function(_$InstagramPostsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InstagramPostsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? pagination = null,
  }) {
    return _then(
      _$InstagramPostsResponseImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<InstagramPostEntity>,
        pagination: null == pagination
            ? _value.pagination
            : pagination // ignore: cast_nullable_to_non_nullable
                  as InstagramPagination,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InstagramPostsResponseImpl implements _InstagramPostsResponse {
  const _$InstagramPostsResponseImpl({
    required this.success,
    required final List<InstagramPostEntity> data,
    required this.pagination,
  }) : _data = data;

  factory _$InstagramPostsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$InstagramPostsResponseImplFromJson(json);

  @override
  final bool success;
  final List<InstagramPostEntity> _data;
  @override
  List<InstagramPostEntity> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final InstagramPagination pagination;

  @override
  String toString() {
    return 'InstagramPostsResponse(success: $success, data: $data, pagination: $pagination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstagramPostsResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    const DeepCollectionEquality().hash(_data),
    pagination,
  );

  /// Create a copy of InstagramPostsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InstagramPostsResponseImplCopyWith<_$InstagramPostsResponseImpl>
  get copyWith =>
      __$$InstagramPostsResponseImplCopyWithImpl<_$InstagramPostsResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InstagramPostsResponseImplToJson(this);
  }
}

abstract class _InstagramPostsResponse implements InstagramPostsResponse {
  const factory _InstagramPostsResponse({
    required final bool success,
    required final List<InstagramPostEntity> data,
    required final InstagramPagination pagination,
  }) = _$InstagramPostsResponseImpl;

  factory _InstagramPostsResponse.fromJson(Map<String, dynamic> json) =
      _$InstagramPostsResponseImpl.fromJson;

  @override
  bool get success;
  @override
  List<InstagramPostEntity> get data;
  @override
  InstagramPagination get pagination;

  /// Create a copy of InstagramPostsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InstagramPostsResponseImplCopyWith<_$InstagramPostsResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

InstagramCommentsResponse _$InstagramCommentsResponseFromJson(
  Map<String, dynamic> json,
) {
  return _InstagramCommentsResponse.fromJson(json);
}

/// @nodoc
mixin _$InstagramCommentsResponse {
  bool get success => throw _privateConstructorUsedError;
  List<InstagramCommentEntity> get data => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this InstagramCommentsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InstagramCommentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InstagramCommentsResponseCopyWith<InstagramCommentsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstagramCommentsResponseCopyWith<$Res> {
  factory $InstagramCommentsResponseCopyWith(
    InstagramCommentsResponse value,
    $Res Function(InstagramCommentsResponse) then,
  ) = _$InstagramCommentsResponseCopyWithImpl<$Res, InstagramCommentsResponse>;
  @useResult
  $Res call({bool success, List<InstagramCommentEntity> data, int count});
}

/// @nodoc
class _$InstagramCommentsResponseCopyWithImpl<
  $Res,
  $Val extends InstagramCommentsResponse
>
    implements $InstagramCommentsResponseCopyWith<$Res> {
  _$InstagramCommentsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InstagramCommentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? count = null,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            data: null == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as List<InstagramCommentEntity>,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InstagramCommentsResponseImplCopyWith<$Res>
    implements $InstagramCommentsResponseCopyWith<$Res> {
  factory _$$InstagramCommentsResponseImplCopyWith(
    _$InstagramCommentsResponseImpl value,
    $Res Function(_$InstagramCommentsResponseImpl) then,
  ) = __$$InstagramCommentsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, List<InstagramCommentEntity> data, int count});
}

/// @nodoc
class __$$InstagramCommentsResponseImplCopyWithImpl<$Res>
    extends
        _$InstagramCommentsResponseCopyWithImpl<
          $Res,
          _$InstagramCommentsResponseImpl
        >
    implements _$$InstagramCommentsResponseImplCopyWith<$Res> {
  __$$InstagramCommentsResponseImplCopyWithImpl(
    _$InstagramCommentsResponseImpl _value,
    $Res Function(_$InstagramCommentsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InstagramCommentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? count = null,
  }) {
    return _then(
      _$InstagramCommentsResponseImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        data: null == data
            ? _value._data
            : data // ignore: cast_nullable_to_non_nullable
                  as List<InstagramCommentEntity>,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InstagramCommentsResponseImpl implements _InstagramCommentsResponse {
  const _$InstagramCommentsResponseImpl({
    required this.success,
    required final List<InstagramCommentEntity> data,
    required this.count,
  }) : _data = data;

  factory _$InstagramCommentsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$InstagramCommentsResponseImplFromJson(json);

  @override
  final bool success;
  final List<InstagramCommentEntity> _data;
  @override
  List<InstagramCommentEntity> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final int count;

  @override
  String toString() {
    return 'InstagramCommentsResponse(success: $success, data: $data, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstagramCommentsResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    success,
    const DeepCollectionEquality().hash(_data),
    count,
  );

  /// Create a copy of InstagramCommentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InstagramCommentsResponseImplCopyWith<_$InstagramCommentsResponseImpl>
  get copyWith =>
      __$$InstagramCommentsResponseImplCopyWithImpl<
        _$InstagramCommentsResponseImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InstagramCommentsResponseImplToJson(this);
  }
}

abstract class _InstagramCommentsResponse implements InstagramCommentsResponse {
  const factory _InstagramCommentsResponse({
    required final bool success,
    required final List<InstagramCommentEntity> data,
    required final int count,
  }) = _$InstagramCommentsResponseImpl;

  factory _InstagramCommentsResponse.fromJson(Map<String, dynamic> json) =
      _$InstagramCommentsResponseImpl.fromJson;

  @override
  bool get success;
  @override
  List<InstagramCommentEntity> get data;
  @override
  int get count;

  /// Create a copy of InstagramCommentsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InstagramCommentsResponseImplCopyWith<_$InstagramCommentsResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

InstagramPagination _$InstagramPaginationFromJson(Map<String, dynamic> json) {
  return _InstagramPagination.fromJson(json);
}

/// @nodoc
mixin _$InstagramPagination {
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  /// Serializes this InstagramPagination to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InstagramPagination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InstagramPaginationCopyWith<InstagramPagination> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstagramPaginationCopyWith<$Res> {
  factory $InstagramPaginationCopyWith(
    InstagramPagination value,
    $Res Function(InstagramPagination) then,
  ) = _$InstagramPaginationCopyWithImpl<$Res, InstagramPagination>;
  @useResult
  $Res call({int page, int limit, int total});
}

/// @nodoc
class _$InstagramPaginationCopyWithImpl<$Res, $Val extends InstagramPagination>
    implements $InstagramPaginationCopyWith<$Res> {
  _$InstagramPaginationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InstagramPagination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? page = null, Object? limit = null, Object? total = null}) {
    return _then(
      _value.copyWith(
            page: null == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InstagramPaginationImplCopyWith<$Res>
    implements $InstagramPaginationCopyWith<$Res> {
  factory _$$InstagramPaginationImplCopyWith(
    _$InstagramPaginationImpl value,
    $Res Function(_$InstagramPaginationImpl) then,
  ) = __$$InstagramPaginationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int page, int limit, int total});
}

/// @nodoc
class __$$InstagramPaginationImplCopyWithImpl<$Res>
    extends _$InstagramPaginationCopyWithImpl<$Res, _$InstagramPaginationImpl>
    implements _$$InstagramPaginationImplCopyWith<$Res> {
  __$$InstagramPaginationImplCopyWithImpl(
    _$InstagramPaginationImpl _value,
    $Res Function(_$InstagramPaginationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InstagramPagination
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? page = null, Object? limit = null, Object? total = null}) {
    return _then(
      _$InstagramPaginationImpl(
        page: null == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InstagramPaginationImpl implements _InstagramPagination {
  const _$InstagramPaginationImpl({
    required this.page,
    required this.limit,
    required this.total,
  });

  factory _$InstagramPaginationImpl.fromJson(Map<String, dynamic> json) =>
      _$$InstagramPaginationImplFromJson(json);

  @override
  final int page;
  @override
  final int limit;
  @override
  final int total;

  @override
  String toString() {
    return 'InstagramPagination(page: $page, limit: $limit, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstagramPaginationImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, page, limit, total);

  /// Create a copy of InstagramPagination
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InstagramPaginationImplCopyWith<_$InstagramPaginationImpl> get copyWith =>
      __$$InstagramPaginationImplCopyWithImpl<_$InstagramPaginationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$InstagramPaginationImplToJson(this);
  }
}

abstract class _InstagramPagination implements InstagramPagination {
  const factory _InstagramPagination({
    required final int page,
    required final int limit,
    required final int total,
  }) = _$InstagramPaginationImpl;

  factory _InstagramPagination.fromJson(Map<String, dynamic> json) =
      _$InstagramPaginationImpl.fromJson;

  @override
  int get page;
  @override
  int get limit;
  @override
  int get total;

  /// Create a copy of InstagramPagination
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InstagramPaginationImplCopyWith<_$InstagramPaginationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

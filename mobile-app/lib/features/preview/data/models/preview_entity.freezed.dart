// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preview_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PreviewEntity _$PreviewEntityFromJson(Map<String, dynamic> json) {
  return _PreviewEntity.fromJson(json);
}

/// @nodoc
mixin _$PreviewEntity {
  String get id => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'post', 'story', or 'reel'
  String get topic => throw _privateConstructorUsedError;
  String get style => throw _privateConstructorUsedError;
  String get targetAudience => throw _privateConstructorUsedError;
  String? get referenceImage => throw _privateConstructorUsedError;
  String get previewImage => throw _privateConstructorUsedError;
  String? get videoUrl => throw _privateConstructorUsedError; // For reels
  String get caption => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'draft', 'published', 'processing'
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  DateTime? get publishedAt => throw _privateConstructorUsedError;
  List<CorrectionEntity>? get corrections => throw _privateConstructorUsedError;
  int? get views => throw _privateConstructorUsedError;
  int? get likes => throw _privateConstructorUsedError;
  int? get comments => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this PreviewEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PreviewEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PreviewEntityCopyWith<PreviewEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PreviewEntityCopyWith<$Res> {
  factory $PreviewEntityCopyWith(
    PreviewEntity value,
    $Res Function(PreviewEntity) then,
  ) = _$PreviewEntityCopyWithImpl<$Res, PreviewEntity>;
  @useResult
  $Res call({
    String id,
    String type,
    String topic,
    String style,
    String targetAudience,
    String? referenceImage,
    String previewImage,
    String? videoUrl,
    String caption,
    String status,
    DateTime createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt,
    List<CorrectionEntity>? corrections,
    int? views,
    int? likes,
    int? comments,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class _$PreviewEntityCopyWithImpl<$Res, $Val extends PreviewEntity>
    implements $PreviewEntityCopyWith<$Res> {
  _$PreviewEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PreviewEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? topic = null,
    Object? style = null,
    Object? targetAudience = null,
    Object? referenceImage = freezed,
    Object? previewImage = null,
    Object? videoUrl = freezed,
    Object? caption = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? publishedAt = freezed,
    Object? corrections = freezed,
    Object? views = freezed,
    Object? likes = freezed,
    Object? comments = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            topic: null == topic
                ? _value.topic
                : topic // ignore: cast_nullable_to_non_nullable
                      as String,
            style: null == style
                ? _value.style
                : style // ignore: cast_nullable_to_non_nullable
                      as String,
            targetAudience: null == targetAudience
                ? _value.targetAudience
                : targetAudience // ignore: cast_nullable_to_non_nullable
                      as String,
            referenceImage: freezed == referenceImage
                ? _value.referenceImage
                : referenceImage // ignore: cast_nullable_to_non_nullable
                      as String?,
            previewImage: null == previewImage
                ? _value.previewImage
                : previewImage // ignore: cast_nullable_to_non_nullable
                      as String,
            videoUrl: freezed == videoUrl
                ? _value.videoUrl
                : videoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            caption: null == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            publishedAt: freezed == publishedAt
                ? _value.publishedAt
                : publishedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            corrections: freezed == corrections
                ? _value.corrections
                : corrections // ignore: cast_nullable_to_non_nullable
                      as List<CorrectionEntity>?,
            views: freezed == views
                ? _value.views
                : views // ignore: cast_nullable_to_non_nullable
                      as int?,
            likes: freezed == likes
                ? _value.likes
                : likes // ignore: cast_nullable_to_non_nullable
                      as int?,
            comments: freezed == comments
                ? _value.comments
                : comments // ignore: cast_nullable_to_non_nullable
                      as int?,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PreviewEntityImplCopyWith<$Res>
    implements $PreviewEntityCopyWith<$Res> {
  factory _$$PreviewEntityImplCopyWith(
    _$PreviewEntityImpl value,
    $Res Function(_$PreviewEntityImpl) then,
  ) = __$$PreviewEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String type,
    String topic,
    String style,
    String targetAudience,
    String? referenceImage,
    String previewImage,
    String? videoUrl,
    String caption,
    String status,
    DateTime createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt,
    List<CorrectionEntity>? corrections,
    int? views,
    int? likes,
    int? comments,
    Map<String, dynamic>? metadata,
  });
}

/// @nodoc
class __$$PreviewEntityImplCopyWithImpl<$Res>
    extends _$PreviewEntityCopyWithImpl<$Res, _$PreviewEntityImpl>
    implements _$$PreviewEntityImplCopyWith<$Res> {
  __$$PreviewEntityImplCopyWithImpl(
    _$PreviewEntityImpl _value,
    $Res Function(_$PreviewEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PreviewEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? topic = null,
    Object? style = null,
    Object? targetAudience = null,
    Object? referenceImage = freezed,
    Object? previewImage = null,
    Object? videoUrl = freezed,
    Object? caption = null,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? publishedAt = freezed,
    Object? corrections = freezed,
    Object? views = freezed,
    Object? likes = freezed,
    Object? comments = freezed,
    Object? metadata = freezed,
  }) {
    return _then(
      _$PreviewEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        topic: null == topic
            ? _value.topic
            : topic // ignore: cast_nullable_to_non_nullable
                  as String,
        style: null == style
            ? _value.style
            : style // ignore: cast_nullable_to_non_nullable
                  as String,
        targetAudience: null == targetAudience
            ? _value.targetAudience
            : targetAudience // ignore: cast_nullable_to_non_nullable
                  as String,
        referenceImage: freezed == referenceImage
            ? _value.referenceImage
            : referenceImage // ignore: cast_nullable_to_non_nullable
                  as String?,
        previewImage: null == previewImage
            ? _value.previewImage
            : previewImage // ignore: cast_nullable_to_non_nullable
                  as String,
        videoUrl: freezed == videoUrl
            ? _value.videoUrl
            : videoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        caption: null == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        publishedAt: freezed == publishedAt
            ? _value.publishedAt
            : publishedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        corrections: freezed == corrections
            ? _value._corrections
            : corrections // ignore: cast_nullable_to_non_nullable
                  as List<CorrectionEntity>?,
        views: freezed == views
            ? _value.views
            : views // ignore: cast_nullable_to_non_nullable
                  as int?,
        likes: freezed == likes
            ? _value.likes
            : likes // ignore: cast_nullable_to_non_nullable
                  as int?,
        comments: freezed == comments
            ? _value.comments
            : comments // ignore: cast_nullable_to_non_nullable
                  as int?,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PreviewEntityImpl implements _PreviewEntity {
  const _$PreviewEntityImpl({
    required this.id,
    required this.type,
    required this.topic,
    required this.style,
    required this.targetAudience,
    this.referenceImage,
    required this.previewImage,
    this.videoUrl,
    required this.caption,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.publishedAt,
    final List<CorrectionEntity>? corrections,
    this.views,
    this.likes,
    this.comments,
    final Map<String, dynamic>? metadata,
  }) : _corrections = corrections,
       _metadata = metadata;

  factory _$PreviewEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$PreviewEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
  // 'post', 'story', or 'reel'
  @override
  final String topic;
  @override
  final String style;
  @override
  final String targetAudience;
  @override
  final String? referenceImage;
  @override
  final String previewImage;
  @override
  final String? videoUrl;
  // For reels
  @override
  final String caption;
  @override
  final String status;
  // 'draft', 'published', 'processing'
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final DateTime? publishedAt;
  final List<CorrectionEntity>? _corrections;
  @override
  List<CorrectionEntity>? get corrections {
    final value = _corrections;
    if (value == null) return null;
    if (_corrections is EqualUnmodifiableListView) return _corrections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? views;
  @override
  final int? likes;
  @override
  final int? comments;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'PreviewEntity(id: $id, type: $type, topic: $topic, style: $style, targetAudience: $targetAudience, referenceImage: $referenceImage, previewImage: $previewImage, videoUrl: $videoUrl, caption: $caption, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, publishedAt: $publishedAt, corrections: $corrections, views: $views, likes: $likes, comments: $comments, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PreviewEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.targetAudience, targetAudience) ||
                other.targetAudience == targetAudience) &&
            (identical(other.referenceImage, referenceImage) ||
                other.referenceImage == referenceImage) &&
            (identical(other.previewImage, previewImage) ||
                other.previewImage == previewImage) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            const DeepCollectionEquality().equals(
              other._corrections,
              _corrections,
            ) &&
            (identical(other.views, views) || other.views == views) &&
            (identical(other.likes, likes) || other.likes == likes) &&
            (identical(other.comments, comments) ||
                other.comments == comments) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    topic,
    style,
    targetAudience,
    referenceImage,
    previewImage,
    videoUrl,
    caption,
    status,
    createdAt,
    updatedAt,
    publishedAt,
    const DeepCollectionEquality().hash(_corrections),
    views,
    likes,
    comments,
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of PreviewEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PreviewEntityImplCopyWith<_$PreviewEntityImpl> get copyWith =>
      __$$PreviewEntityImplCopyWithImpl<_$PreviewEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PreviewEntityImplToJson(this);
  }
}

abstract class _PreviewEntity implements PreviewEntity {
  const factory _PreviewEntity({
    required final String id,
    required final String type,
    required final String topic,
    required final String style,
    required final String targetAudience,
    final String? referenceImage,
    required final String previewImage,
    final String? videoUrl,
    required final String caption,
    required final String status,
    required final DateTime createdAt,
    final DateTime? updatedAt,
    final DateTime? publishedAt,
    final List<CorrectionEntity>? corrections,
    final int? views,
    final int? likes,
    final int? comments,
    final Map<String, dynamic>? metadata,
  }) = _$PreviewEntityImpl;

  factory _PreviewEntity.fromJson(Map<String, dynamic> json) =
      _$PreviewEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get type; // 'post', 'story', or 'reel'
  @override
  String get topic;
  @override
  String get style;
  @override
  String get targetAudience;
  @override
  String? get referenceImage;
  @override
  String get previewImage;
  @override
  String? get videoUrl; // For reels
  @override
  String get caption;
  @override
  String get status; // 'draft', 'published', 'processing'
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  DateTime? get publishedAt;
  @override
  List<CorrectionEntity>? get corrections;
  @override
  int? get views;
  @override
  int? get likes;
  @override
  int? get comments;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of PreviewEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PreviewEntityImplCopyWith<_$PreviewEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CorrectionEntity _$CorrectionEntityFromJson(Map<String, dynamic> json) {
  return _CorrectionEntity.fromJson(json);
}

/// @nodoc
mixin _$CorrectionEntity {
  String get id => throw _privateConstructorUsedError;
  String get previewId => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'text', 'visual', 'style', 'general'
  String get description => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // 'pending', 'applied', 'rejected'
  String? get visualFeedback => throw _privateConstructorUsedError;
  String? get textChanges => throw _privateConstructorUsedError;
  String? get styleChanges => throw _privateConstructorUsedError;
  Map<String, dynamic>? get visualData =>
      throw _privateConstructorUsedError; // Para datos específicos de selección visual
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get appliedAt => throw _privateConstructorUsedError;

  /// Serializes this CorrectionEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CorrectionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CorrectionEntityCopyWith<CorrectionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CorrectionEntityCopyWith<$Res> {
  factory $CorrectionEntityCopyWith(
    CorrectionEntity value,
    $Res Function(CorrectionEntity) then,
  ) = _$CorrectionEntityCopyWithImpl<$Res, CorrectionEntity>;
  @useResult
  $Res call({
    String id,
    String previewId,
    String type,
    String description,
    String status,
    String? visualFeedback,
    String? textChanges,
    String? styleChanges,
    Map<String, dynamic>? visualData,
    DateTime createdAt,
    DateTime? appliedAt,
  });
}

/// @nodoc
class _$CorrectionEntityCopyWithImpl<$Res, $Val extends CorrectionEntity>
    implements $CorrectionEntityCopyWith<$Res> {
  _$CorrectionEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CorrectionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? previewId = null,
    Object? type = null,
    Object? description = null,
    Object? status = null,
    Object? visualFeedback = freezed,
    Object? textChanges = freezed,
    Object? styleChanges = freezed,
    Object? visualData = freezed,
    Object? createdAt = null,
    Object? appliedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            previewId: null == previewId
                ? _value.previewId
                : previewId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            visualFeedback: freezed == visualFeedback
                ? _value.visualFeedback
                : visualFeedback // ignore: cast_nullable_to_non_nullable
                      as String?,
            textChanges: freezed == textChanges
                ? _value.textChanges
                : textChanges // ignore: cast_nullable_to_non_nullable
                      as String?,
            styleChanges: freezed == styleChanges
                ? _value.styleChanges
                : styleChanges // ignore: cast_nullable_to_non_nullable
                      as String?,
            visualData: freezed == visualData
                ? _value.visualData
                : visualData // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            appliedAt: freezed == appliedAt
                ? _value.appliedAt
                : appliedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CorrectionEntityImplCopyWith<$Res>
    implements $CorrectionEntityCopyWith<$Res> {
  factory _$$CorrectionEntityImplCopyWith(
    _$CorrectionEntityImpl value,
    $Res Function(_$CorrectionEntityImpl) then,
  ) = __$$CorrectionEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String previewId,
    String type,
    String description,
    String status,
    String? visualFeedback,
    String? textChanges,
    String? styleChanges,
    Map<String, dynamic>? visualData,
    DateTime createdAt,
    DateTime? appliedAt,
  });
}

/// @nodoc
class __$$CorrectionEntityImplCopyWithImpl<$Res>
    extends _$CorrectionEntityCopyWithImpl<$Res, _$CorrectionEntityImpl>
    implements _$$CorrectionEntityImplCopyWith<$Res> {
  __$$CorrectionEntityImplCopyWithImpl(
    _$CorrectionEntityImpl _value,
    $Res Function(_$CorrectionEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CorrectionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? previewId = null,
    Object? type = null,
    Object? description = null,
    Object? status = null,
    Object? visualFeedback = freezed,
    Object? textChanges = freezed,
    Object? styleChanges = freezed,
    Object? visualData = freezed,
    Object? createdAt = null,
    Object? appliedAt = freezed,
  }) {
    return _then(
      _$CorrectionEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        previewId: null == previewId
            ? _value.previewId
            : previewId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        visualFeedback: freezed == visualFeedback
            ? _value.visualFeedback
            : visualFeedback // ignore: cast_nullable_to_non_nullable
                  as String?,
        textChanges: freezed == textChanges
            ? _value.textChanges
            : textChanges // ignore: cast_nullable_to_non_nullable
                  as String?,
        styleChanges: freezed == styleChanges
            ? _value.styleChanges
            : styleChanges // ignore: cast_nullable_to_non_nullable
                  as String?,
        visualData: freezed == visualData
            ? _value._visualData
            : visualData // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        appliedAt: freezed == appliedAt
            ? _value.appliedAt
            : appliedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CorrectionEntityImpl implements _CorrectionEntity {
  const _$CorrectionEntityImpl({
    required this.id,
    required this.previewId,
    required this.type,
    required this.description,
    required this.status,
    this.visualFeedback,
    this.textChanges,
    this.styleChanges,
    final Map<String, dynamic>? visualData,
    required this.createdAt,
    this.appliedAt,
  }) : _visualData = visualData;

  factory _$CorrectionEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$CorrectionEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String previewId;
  @override
  final String type;
  // 'text', 'visual', 'style', 'general'
  @override
  final String description;
  @override
  final String status;
  // 'pending', 'applied', 'rejected'
  @override
  final String? visualFeedback;
  @override
  final String? textChanges;
  @override
  final String? styleChanges;
  final Map<String, dynamic>? _visualData;
  @override
  Map<String, dynamic>? get visualData {
    final value = _visualData;
    if (value == null) return null;
    if (_visualData is EqualUnmodifiableMapView) return _visualData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  // Para datos específicos de selección visual
  @override
  final DateTime createdAt;
  @override
  final DateTime? appliedAt;

  @override
  String toString() {
    return 'CorrectionEntity(id: $id, previewId: $previewId, type: $type, description: $description, status: $status, visualFeedback: $visualFeedback, textChanges: $textChanges, styleChanges: $styleChanges, visualData: $visualData, createdAt: $createdAt, appliedAt: $appliedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CorrectionEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.previewId, previewId) ||
                other.previewId == previewId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.visualFeedback, visualFeedback) ||
                other.visualFeedback == visualFeedback) &&
            (identical(other.textChanges, textChanges) ||
                other.textChanges == textChanges) &&
            (identical(other.styleChanges, styleChanges) ||
                other.styleChanges == styleChanges) &&
            const DeepCollectionEquality().equals(
              other._visualData,
              _visualData,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.appliedAt, appliedAt) ||
                other.appliedAt == appliedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    previewId,
    type,
    description,
    status,
    visualFeedback,
    textChanges,
    styleChanges,
    const DeepCollectionEquality().hash(_visualData),
    createdAt,
    appliedAt,
  );

  /// Create a copy of CorrectionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CorrectionEntityImplCopyWith<_$CorrectionEntityImpl> get copyWith =>
      __$$CorrectionEntityImplCopyWithImpl<_$CorrectionEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CorrectionEntityImplToJson(this);
  }
}

abstract class _CorrectionEntity implements CorrectionEntity {
  const factory _CorrectionEntity({
    required final String id,
    required final String previewId,
    required final String type,
    required final String description,
    required final String status,
    final String? visualFeedback,
    final String? textChanges,
    final String? styleChanges,
    final Map<String, dynamic>? visualData,
    required final DateTime createdAt,
    final DateTime? appliedAt,
  }) = _$CorrectionEntityImpl;

  factory _CorrectionEntity.fromJson(Map<String, dynamic> json) =
      _$CorrectionEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get previewId;
  @override
  String get type; // 'text', 'visual', 'style', 'general'
  @override
  String get description;
  @override
  String get status; // 'pending', 'applied', 'rejected'
  @override
  String? get visualFeedback;
  @override
  String? get textChanges;
  @override
  String? get styleChanges;
  @override
  Map<String, dynamic>? get visualData; // Para datos específicos de selección visual
  @override
  DateTime get createdAt;
  @override
  DateTime? get appliedAt;

  /// Create a copy of CorrectionEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CorrectionEntityImplCopyWith<_$CorrectionEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatePreviewRequest _$CreatePreviewRequestFromJson(Map<String, dynamic> json) {
  return _CreatePreviewRequest.fromJson(json);
}

/// @nodoc
mixin _$CreatePreviewRequest {
  String get topic => throw _privateConstructorUsedError;
  String get style => throw _privateConstructorUsedError;
  String get targetAudience => throw _privateConstructorUsedError;
  String? get referenceImage => throw _privateConstructorUsedError;

  /// Serializes this CreatePreviewRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatePreviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatePreviewRequestCopyWith<CreatePreviewRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePreviewRequestCopyWith<$Res> {
  factory $CreatePreviewRequestCopyWith(
    CreatePreviewRequest value,
    $Res Function(CreatePreviewRequest) then,
  ) = _$CreatePreviewRequestCopyWithImpl<$Res, CreatePreviewRequest>;
  @useResult
  $Res call({
    String topic,
    String style,
    String targetAudience,
    String? referenceImage,
  });
}

/// @nodoc
class _$CreatePreviewRequestCopyWithImpl<
  $Res,
  $Val extends CreatePreviewRequest
>
    implements $CreatePreviewRequestCopyWith<$Res> {
  _$CreatePreviewRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatePreviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topic = null,
    Object? style = null,
    Object? targetAudience = null,
    Object? referenceImage = freezed,
  }) {
    return _then(
      _value.copyWith(
            topic: null == topic
                ? _value.topic
                : topic // ignore: cast_nullable_to_non_nullable
                      as String,
            style: null == style
                ? _value.style
                : style // ignore: cast_nullable_to_non_nullable
                      as String,
            targetAudience: null == targetAudience
                ? _value.targetAudience
                : targetAudience // ignore: cast_nullable_to_non_nullable
                      as String,
            referenceImage: freezed == referenceImage
                ? _value.referenceImage
                : referenceImage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreatePreviewRequestImplCopyWith<$Res>
    implements $CreatePreviewRequestCopyWith<$Res> {
  factory _$$CreatePreviewRequestImplCopyWith(
    _$CreatePreviewRequestImpl value,
    $Res Function(_$CreatePreviewRequestImpl) then,
  ) = __$$CreatePreviewRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String topic,
    String style,
    String targetAudience,
    String? referenceImage,
  });
}

/// @nodoc
class __$$CreatePreviewRequestImplCopyWithImpl<$Res>
    extends _$CreatePreviewRequestCopyWithImpl<$Res, _$CreatePreviewRequestImpl>
    implements _$$CreatePreviewRequestImplCopyWith<$Res> {
  __$$CreatePreviewRequestImplCopyWithImpl(
    _$CreatePreviewRequestImpl _value,
    $Res Function(_$CreatePreviewRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreatePreviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topic = null,
    Object? style = null,
    Object? targetAudience = null,
    Object? referenceImage = freezed,
  }) {
    return _then(
      _$CreatePreviewRequestImpl(
        topic: null == topic
            ? _value.topic
            : topic // ignore: cast_nullable_to_non_nullable
                  as String,
        style: null == style
            ? _value.style
            : style // ignore: cast_nullable_to_non_nullable
                  as String,
        targetAudience: null == targetAudience
            ? _value.targetAudience
            : targetAudience // ignore: cast_nullable_to_non_nullable
                  as String,
        referenceImage: freezed == referenceImage
            ? _value.referenceImage
            : referenceImage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatePreviewRequestImpl implements _CreatePreviewRequest {
  const _$CreatePreviewRequestImpl({
    required this.topic,
    required this.style,
    required this.targetAudience,
    this.referenceImage,
  });

  factory _$CreatePreviewRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatePreviewRequestImplFromJson(json);

  @override
  final String topic;
  @override
  final String style;
  @override
  final String targetAudience;
  @override
  final String? referenceImage;

  @override
  String toString() {
    return 'CreatePreviewRequest(topic: $topic, style: $style, targetAudience: $targetAudience, referenceImage: $referenceImage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePreviewRequestImpl &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.targetAudience, targetAudience) ||
                other.targetAudience == targetAudience) &&
            (identical(other.referenceImage, referenceImage) ||
                other.referenceImage == referenceImage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, topic, style, targetAudience, referenceImage);

  /// Create a copy of CreatePreviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePreviewRequestImplCopyWith<_$CreatePreviewRequestImpl>
  get copyWith =>
      __$$CreatePreviewRequestImplCopyWithImpl<_$CreatePreviewRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatePreviewRequestImplToJson(this);
  }
}

abstract class _CreatePreviewRequest implements CreatePreviewRequest {
  const factory _CreatePreviewRequest({
    required final String topic,
    required final String style,
    required final String targetAudience,
    final String? referenceImage,
  }) = _$CreatePreviewRequestImpl;

  factory _CreatePreviewRequest.fromJson(Map<String, dynamic> json) =
      _$CreatePreviewRequestImpl.fromJson;

  @override
  String get topic;
  @override
  String get style;
  @override
  String get targetAudience;
  @override
  String? get referenceImage;

  /// Create a copy of CreatePreviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatePreviewRequestImplCopyWith<_$CreatePreviewRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CreateReelRequest _$CreateReelRequestFromJson(Map<String, dynamic> json) {
  return _CreateReelRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateReelRequest {
  String get prompt =>
      throw _privateConstructorUsedError; // Tema/contenido del reel
  String? get accent =>
      throw _privateConstructorUsedError; // Acento del audio (default: "neutral")
  String? get style =>
      throw _privateConstructorUsedError; // Estilo visual (default: "realista")
  int? get duration =>
      throw _privateConstructorUsedError; // Duración en segundos (default: 8, range: 3-8)
  String? get targetAudience => throw _privateConstructorUsedError;

  /// Serializes this CreateReelRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateReelRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateReelRequestCopyWith<CreateReelRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateReelRequestCopyWith<$Res> {
  factory $CreateReelRequestCopyWith(
    CreateReelRequest value,
    $Res Function(CreateReelRequest) then,
  ) = _$CreateReelRequestCopyWithImpl<$Res, CreateReelRequest>;
  @useResult
  $Res call({
    String prompt,
    String? accent,
    String? style,
    int? duration,
    String? targetAudience,
  });
}

/// @nodoc
class _$CreateReelRequestCopyWithImpl<$Res, $Val extends CreateReelRequest>
    implements $CreateReelRequestCopyWith<$Res> {
  _$CreateReelRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateReelRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prompt = null,
    Object? accent = freezed,
    Object? style = freezed,
    Object? duration = freezed,
    Object? targetAudience = freezed,
  }) {
    return _then(
      _value.copyWith(
            prompt: null == prompt
                ? _value.prompt
                : prompt // ignore: cast_nullable_to_non_nullable
                      as String,
            accent: freezed == accent
                ? _value.accent
                : accent // ignore: cast_nullable_to_non_nullable
                      as String?,
            style: freezed == style
                ? _value.style
                : style // ignore: cast_nullable_to_non_nullable
                      as String?,
            duration: freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int?,
            targetAudience: freezed == targetAudience
                ? _value.targetAudience
                : targetAudience // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateReelRequestImplCopyWith<$Res>
    implements $CreateReelRequestCopyWith<$Res> {
  factory _$$CreateReelRequestImplCopyWith(
    _$CreateReelRequestImpl value,
    $Res Function(_$CreateReelRequestImpl) then,
  ) = __$$CreateReelRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String prompt,
    String? accent,
    String? style,
    int? duration,
    String? targetAudience,
  });
}

/// @nodoc
class __$$CreateReelRequestImplCopyWithImpl<$Res>
    extends _$CreateReelRequestCopyWithImpl<$Res, _$CreateReelRequestImpl>
    implements _$$CreateReelRequestImplCopyWith<$Res> {
  __$$CreateReelRequestImplCopyWithImpl(
    _$CreateReelRequestImpl _value,
    $Res Function(_$CreateReelRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateReelRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? prompt = null,
    Object? accent = freezed,
    Object? style = freezed,
    Object? duration = freezed,
    Object? targetAudience = freezed,
  }) {
    return _then(
      _$CreateReelRequestImpl(
        prompt: null == prompt
            ? _value.prompt
            : prompt // ignore: cast_nullable_to_non_nullable
                  as String,
        accent: freezed == accent
            ? _value.accent
            : accent // ignore: cast_nullable_to_non_nullable
                  as String?,
        style: freezed == style
            ? _value.style
            : style // ignore: cast_nullable_to_non_nullable
                  as String?,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int?,
        targetAudience: freezed == targetAudience
            ? _value.targetAudience
            : targetAudience // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateReelRequestImpl implements _CreateReelRequest {
  const _$CreateReelRequestImpl({
    required this.prompt,
    this.accent,
    this.style,
    this.duration,
    this.targetAudience,
  });

  factory _$CreateReelRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateReelRequestImplFromJson(json);

  @override
  final String prompt;
  // Tema/contenido del reel
  @override
  final String? accent;
  // Acento del audio (default: "neutral")
  @override
  final String? style;
  // Estilo visual (default: "realista")
  @override
  final int? duration;
  // Duración en segundos (default: 8, range: 3-8)
  @override
  final String? targetAudience;

  @override
  String toString() {
    return 'CreateReelRequest(prompt: $prompt, accent: $accent, style: $style, duration: $duration, targetAudience: $targetAudience)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateReelRequestImpl &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            (identical(other.accent, accent) || other.accent == accent) &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.targetAudience, targetAudience) ||
                other.targetAudience == targetAudience));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, prompt, accent, style, duration, targetAudience);

  /// Create a copy of CreateReelRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateReelRequestImplCopyWith<_$CreateReelRequestImpl> get copyWith =>
      __$$CreateReelRequestImplCopyWithImpl<_$CreateReelRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateReelRequestImplToJson(this);
  }
}

abstract class _CreateReelRequest implements CreateReelRequest {
  const factory _CreateReelRequest({
    required final String prompt,
    final String? accent,
    final String? style,
    final int? duration,
    final String? targetAudience,
  }) = _$CreateReelRequestImpl;

  factory _CreateReelRequest.fromJson(Map<String, dynamic> json) =
      _$CreateReelRequestImpl.fromJson;

  @override
  String get prompt; // Tema/contenido del reel
  @override
  String? get accent; // Acento del audio (default: "neutral")
  @override
  String? get style; // Estilo visual (default: "realista")
  @override
  int? get duration; // Duración en segundos (default: 8, range: 3-8)
  @override
  String? get targetAudience;

  /// Create a copy of CreateReelRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateReelRequestImplCopyWith<_$CreateReelRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApplyCorrectionsRequest _$ApplyCorrectionsRequestFromJson(
  Map<String, dynamic> json,
) {
  return _ApplyCorrectionsRequest.fromJson(json);
}

/// @nodoc
mixin _$ApplyCorrectionsRequest {
  List<String> get corrections => throw _privateConstructorUsedError;
  String? get visualFeedback => throw _privateConstructorUsedError;
  String? get textChanges => throw _privateConstructorUsedError;
  String? get styleChanges => throw _privateConstructorUsedError;

  /// Serializes this ApplyCorrectionsRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ApplyCorrectionsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApplyCorrectionsRequestCopyWith<ApplyCorrectionsRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplyCorrectionsRequestCopyWith<$Res> {
  factory $ApplyCorrectionsRequestCopyWith(
    ApplyCorrectionsRequest value,
    $Res Function(ApplyCorrectionsRequest) then,
  ) = _$ApplyCorrectionsRequestCopyWithImpl<$Res, ApplyCorrectionsRequest>;
  @useResult
  $Res call({
    List<String> corrections,
    String? visualFeedback,
    String? textChanges,
    String? styleChanges,
  });
}

/// @nodoc
class _$ApplyCorrectionsRequestCopyWithImpl<
  $Res,
  $Val extends ApplyCorrectionsRequest
>
    implements $ApplyCorrectionsRequestCopyWith<$Res> {
  _$ApplyCorrectionsRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApplyCorrectionsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? corrections = null,
    Object? visualFeedback = freezed,
    Object? textChanges = freezed,
    Object? styleChanges = freezed,
  }) {
    return _then(
      _value.copyWith(
            corrections: null == corrections
                ? _value.corrections
                : corrections // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            visualFeedback: freezed == visualFeedback
                ? _value.visualFeedback
                : visualFeedback // ignore: cast_nullable_to_non_nullable
                      as String?,
            textChanges: freezed == textChanges
                ? _value.textChanges
                : textChanges // ignore: cast_nullable_to_non_nullable
                      as String?,
            styleChanges: freezed == styleChanges
                ? _value.styleChanges
                : styleChanges // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ApplyCorrectionsRequestImplCopyWith<$Res>
    implements $ApplyCorrectionsRequestCopyWith<$Res> {
  factory _$$ApplyCorrectionsRequestImplCopyWith(
    _$ApplyCorrectionsRequestImpl value,
    $Res Function(_$ApplyCorrectionsRequestImpl) then,
  ) = __$$ApplyCorrectionsRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<String> corrections,
    String? visualFeedback,
    String? textChanges,
    String? styleChanges,
  });
}

/// @nodoc
class __$$ApplyCorrectionsRequestImplCopyWithImpl<$Res>
    extends
        _$ApplyCorrectionsRequestCopyWithImpl<
          $Res,
          _$ApplyCorrectionsRequestImpl
        >
    implements _$$ApplyCorrectionsRequestImplCopyWith<$Res> {
  __$$ApplyCorrectionsRequestImplCopyWithImpl(
    _$ApplyCorrectionsRequestImpl _value,
    $Res Function(_$ApplyCorrectionsRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ApplyCorrectionsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? corrections = null,
    Object? visualFeedback = freezed,
    Object? textChanges = freezed,
    Object? styleChanges = freezed,
  }) {
    return _then(
      _$ApplyCorrectionsRequestImpl(
        corrections: null == corrections
            ? _value._corrections
            : corrections // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        visualFeedback: freezed == visualFeedback
            ? _value.visualFeedback
            : visualFeedback // ignore: cast_nullable_to_non_nullable
                  as String?,
        textChanges: freezed == textChanges
            ? _value.textChanges
            : textChanges // ignore: cast_nullable_to_non_nullable
                  as String?,
        styleChanges: freezed == styleChanges
            ? _value.styleChanges
            : styleChanges // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ApplyCorrectionsRequestImpl implements _ApplyCorrectionsRequest {
  const _$ApplyCorrectionsRequestImpl({
    required final List<String> corrections,
    this.visualFeedback,
    this.textChanges,
    this.styleChanges,
  }) : _corrections = corrections;

  factory _$ApplyCorrectionsRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplyCorrectionsRequestImplFromJson(json);

  final List<String> _corrections;
  @override
  List<String> get corrections {
    if (_corrections is EqualUnmodifiableListView) return _corrections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_corrections);
  }

  @override
  final String? visualFeedback;
  @override
  final String? textChanges;
  @override
  final String? styleChanges;

  @override
  String toString() {
    return 'ApplyCorrectionsRequest(corrections: $corrections, visualFeedback: $visualFeedback, textChanges: $textChanges, styleChanges: $styleChanges)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplyCorrectionsRequestImpl &&
            const DeepCollectionEquality().equals(
              other._corrections,
              _corrections,
            ) &&
            (identical(other.visualFeedback, visualFeedback) ||
                other.visualFeedback == visualFeedback) &&
            (identical(other.textChanges, textChanges) ||
                other.textChanges == textChanges) &&
            (identical(other.styleChanges, styleChanges) ||
                other.styleChanges == styleChanges));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_corrections),
    visualFeedback,
    textChanges,
    styleChanges,
  );

  /// Create a copy of ApplyCorrectionsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplyCorrectionsRequestImplCopyWith<_$ApplyCorrectionsRequestImpl>
  get copyWith =>
      __$$ApplyCorrectionsRequestImplCopyWithImpl<
        _$ApplyCorrectionsRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplyCorrectionsRequestImplToJson(this);
  }
}

abstract class _ApplyCorrectionsRequest implements ApplyCorrectionsRequest {
  const factory _ApplyCorrectionsRequest({
    required final List<String> corrections,
    final String? visualFeedback,
    final String? textChanges,
    final String? styleChanges,
  }) = _$ApplyCorrectionsRequestImpl;

  factory _ApplyCorrectionsRequest.fromJson(Map<String, dynamic> json) =
      _$ApplyCorrectionsRequestImpl.fromJson;

  @override
  List<String> get corrections;
  @override
  String? get visualFeedback;
  @override
  String? get textChanges;
  @override
  String? get styleChanges;

  /// Create a copy of ApplyCorrectionsRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplyCorrectionsRequestImplCopyWith<_$ApplyCorrectionsRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PublishPreviewRequest _$PublishPreviewRequestFromJson(
  Map<String, dynamic> json,
) {
  return _PublishPreviewRequest.fromJson(json);
}

/// @nodoc
mixin _$PublishPreviewRequest {
  String? get finalCaption => throw _privateConstructorUsedError;

  /// Serializes this PublishPreviewRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PublishPreviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PublishPreviewRequestCopyWith<PublishPreviewRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PublishPreviewRequestCopyWith<$Res> {
  factory $PublishPreviewRequestCopyWith(
    PublishPreviewRequest value,
    $Res Function(PublishPreviewRequest) then,
  ) = _$PublishPreviewRequestCopyWithImpl<$Res, PublishPreviewRequest>;
  @useResult
  $Res call({String? finalCaption});
}

/// @nodoc
class _$PublishPreviewRequestCopyWithImpl<
  $Res,
  $Val extends PublishPreviewRequest
>
    implements $PublishPreviewRequestCopyWith<$Res> {
  _$PublishPreviewRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PublishPreviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? finalCaption = freezed}) {
    return _then(
      _value.copyWith(
            finalCaption: freezed == finalCaption
                ? _value.finalCaption
                : finalCaption // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PublishPreviewRequestImplCopyWith<$Res>
    implements $PublishPreviewRequestCopyWith<$Res> {
  factory _$$PublishPreviewRequestImplCopyWith(
    _$PublishPreviewRequestImpl value,
    $Res Function(_$PublishPreviewRequestImpl) then,
  ) = __$$PublishPreviewRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? finalCaption});
}

/// @nodoc
class __$$PublishPreviewRequestImplCopyWithImpl<$Res>
    extends
        _$PublishPreviewRequestCopyWithImpl<$Res, _$PublishPreviewRequestImpl>
    implements _$$PublishPreviewRequestImplCopyWith<$Res> {
  __$$PublishPreviewRequestImplCopyWithImpl(
    _$PublishPreviewRequestImpl _value,
    $Res Function(_$PublishPreviewRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PublishPreviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? finalCaption = freezed}) {
    return _then(
      _$PublishPreviewRequestImpl(
        finalCaption: freezed == finalCaption
            ? _value.finalCaption
            : finalCaption // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PublishPreviewRequestImpl implements _PublishPreviewRequest {
  const _$PublishPreviewRequestImpl({this.finalCaption});

  factory _$PublishPreviewRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PublishPreviewRequestImplFromJson(json);

  @override
  final String? finalCaption;

  @override
  String toString() {
    return 'PublishPreviewRequest(finalCaption: $finalCaption)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PublishPreviewRequestImpl &&
            (identical(other.finalCaption, finalCaption) ||
                other.finalCaption == finalCaption));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, finalCaption);

  /// Create a copy of PublishPreviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PublishPreviewRequestImplCopyWith<_$PublishPreviewRequestImpl>
  get copyWith =>
      __$$PublishPreviewRequestImplCopyWithImpl<_$PublishPreviewRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PublishPreviewRequestImplToJson(this);
  }
}

abstract class _PublishPreviewRequest implements PublishPreviewRequest {
  const factory _PublishPreviewRequest({final String? finalCaption}) =
      _$PublishPreviewRequestImpl;

  factory _PublishPreviewRequest.fromJson(Map<String, dynamic> json) =
      _$PublishPreviewRequestImpl.fromJson;

  @override
  String? get finalCaption;

  /// Create a copy of PublishPreviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PublishPreviewRequestImplCopyWith<_$PublishPreviewRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PreviewsResponse _$PreviewsResponseFromJson(Map<String, dynamic> json) {
  return _PreviewsResponse.fromJson(json);
}

/// @nodoc
mixin _$PreviewsResponse {
  List<PreviewEntity> get previews => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get offset => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  /// Serializes this PreviewsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PreviewsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PreviewsResponseCopyWith<PreviewsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PreviewsResponseCopyWith<$Res> {
  factory $PreviewsResponseCopyWith(
    PreviewsResponse value,
    $Res Function(PreviewsResponse) then,
  ) = _$PreviewsResponseCopyWithImpl<$Res, PreviewsResponse>;
  @useResult
  $Res call({
    List<PreviewEntity> previews,
    int total,
    int limit,
    int offset,
    bool hasMore,
  });
}

/// @nodoc
class _$PreviewsResponseCopyWithImpl<$Res, $Val extends PreviewsResponse>
    implements $PreviewsResponseCopyWith<$Res> {
  _$PreviewsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PreviewsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? previews = null,
    Object? total = null,
    Object? limit = null,
    Object? offset = null,
    Object? hasMore = null,
  }) {
    return _then(
      _value.copyWith(
            previews: null == previews
                ? _value.previews
                : previews // ignore: cast_nullable_to_non_nullable
                      as List<PreviewEntity>,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            limit: null == limit
                ? _value.limit
                : limit // ignore: cast_nullable_to_non_nullable
                      as int,
            offset: null == offset
                ? _value.offset
                : offset // ignore: cast_nullable_to_non_nullable
                      as int,
            hasMore: null == hasMore
                ? _value.hasMore
                : hasMore // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PreviewsResponseImplCopyWith<$Res>
    implements $PreviewsResponseCopyWith<$Res> {
  factory _$$PreviewsResponseImplCopyWith(
    _$PreviewsResponseImpl value,
    $Res Function(_$PreviewsResponseImpl) then,
  ) = __$$PreviewsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<PreviewEntity> previews,
    int total,
    int limit,
    int offset,
    bool hasMore,
  });
}

/// @nodoc
class __$$PreviewsResponseImplCopyWithImpl<$Res>
    extends _$PreviewsResponseCopyWithImpl<$Res, _$PreviewsResponseImpl>
    implements _$$PreviewsResponseImplCopyWith<$Res> {
  __$$PreviewsResponseImplCopyWithImpl(
    _$PreviewsResponseImpl _value,
    $Res Function(_$PreviewsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PreviewsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? previews = null,
    Object? total = null,
    Object? limit = null,
    Object? offset = null,
    Object? hasMore = null,
  }) {
    return _then(
      _$PreviewsResponseImpl(
        previews: null == previews
            ? _value._previews
            : previews // ignore: cast_nullable_to_non_nullable
                  as List<PreviewEntity>,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        offset: null == offset
            ? _value.offset
            : offset // ignore: cast_nullable_to_non_nullable
                  as int,
        hasMore: null == hasMore
            ? _value.hasMore
            : hasMore // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PreviewsResponseImpl implements _PreviewsResponse {
  const _$PreviewsResponseImpl({
    required final List<PreviewEntity> previews,
    required this.total,
    required this.limit,
    required this.offset,
    required this.hasMore,
  }) : _previews = previews;

  factory _$PreviewsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PreviewsResponseImplFromJson(json);

  final List<PreviewEntity> _previews;
  @override
  List<PreviewEntity> get previews {
    if (_previews is EqualUnmodifiableListView) return _previews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_previews);
  }

  @override
  final int total;
  @override
  final int limit;
  @override
  final int offset;
  @override
  final bool hasMore;

  @override
  String toString() {
    return 'PreviewsResponse(previews: $previews, total: $total, limit: $limit, offset: $offset, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PreviewsResponseImpl &&
            const DeepCollectionEquality().equals(other._previews, _previews) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_previews),
    total,
    limit,
    offset,
    hasMore,
  );

  /// Create a copy of PreviewsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PreviewsResponseImplCopyWith<_$PreviewsResponseImpl> get copyWith =>
      __$$PreviewsResponseImplCopyWithImpl<_$PreviewsResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PreviewsResponseImplToJson(this);
  }
}

abstract class _PreviewsResponse implements PreviewsResponse {
  const factory _PreviewsResponse({
    required final List<PreviewEntity> previews,
    required final int total,
    required final int limit,
    required final int offset,
    required final bool hasMore,
  }) = _$PreviewsResponseImpl;

  factory _PreviewsResponse.fromJson(Map<String, dynamic> json) =
      _$PreviewsResponseImpl.fromJson;

  @override
  List<PreviewEntity> get previews;
  @override
  int get total;
  @override
  int get limit;
  @override
  int get offset;
  @override
  bool get hasMore;

  /// Create a copy of PreviewsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PreviewsResponseImplCopyWith<_$PreviewsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PreviewResponse _$PreviewResponseFromJson(Map<String, dynamic> json) {
  return _PreviewResponse.fromJson(json);
}

/// @nodoc
mixin _$PreviewResponse {
  PreviewEntity get preview => throw _privateConstructorUsedError;
  List<String> get suggestedCorrections => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this PreviewResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PreviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PreviewResponseCopyWith<PreviewResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PreviewResponseCopyWith<$Res> {
  factory $PreviewResponseCopyWith(
    PreviewResponse value,
    $Res Function(PreviewResponse) then,
  ) = _$PreviewResponseCopyWithImpl<$Res, PreviewResponse>;
  @useResult
  $Res call({
    PreviewEntity preview,
    List<String> suggestedCorrections,
    Map<String, dynamic>? metadata,
  });

  $PreviewEntityCopyWith<$Res> get preview;
}

/// @nodoc
class _$PreviewResponseCopyWithImpl<$Res, $Val extends PreviewResponse>
    implements $PreviewResponseCopyWith<$Res> {
  _$PreviewResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PreviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preview = null,
    Object? suggestedCorrections = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _value.copyWith(
            preview: null == preview
                ? _value.preview
                : preview // ignore: cast_nullable_to_non_nullable
                      as PreviewEntity,
            suggestedCorrections: null == suggestedCorrections
                ? _value.suggestedCorrections
                : suggestedCorrections // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            metadata: freezed == metadata
                ? _value.metadata
                : metadata // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }

  /// Create a copy of PreviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PreviewEntityCopyWith<$Res> get preview {
    return $PreviewEntityCopyWith<$Res>(_value.preview, (value) {
      return _then(_value.copyWith(preview: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PreviewResponseImplCopyWith<$Res>
    implements $PreviewResponseCopyWith<$Res> {
  factory _$$PreviewResponseImplCopyWith(
    _$PreviewResponseImpl value,
    $Res Function(_$PreviewResponseImpl) then,
  ) = __$$PreviewResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    PreviewEntity preview,
    List<String> suggestedCorrections,
    Map<String, dynamic>? metadata,
  });

  @override
  $PreviewEntityCopyWith<$Res> get preview;
}

/// @nodoc
class __$$PreviewResponseImplCopyWithImpl<$Res>
    extends _$PreviewResponseCopyWithImpl<$Res, _$PreviewResponseImpl>
    implements _$$PreviewResponseImplCopyWith<$Res> {
  __$$PreviewResponseImplCopyWithImpl(
    _$PreviewResponseImpl _value,
    $Res Function(_$PreviewResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PreviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? preview = null,
    Object? suggestedCorrections = null,
    Object? metadata = freezed,
  }) {
    return _then(
      _$PreviewResponseImpl(
        preview: null == preview
            ? _value.preview
            : preview // ignore: cast_nullable_to_non_nullable
                  as PreviewEntity,
        suggestedCorrections: null == suggestedCorrections
            ? _value._suggestedCorrections
            : suggestedCorrections // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        metadata: freezed == metadata
            ? _value._metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PreviewResponseImpl implements _PreviewResponse {
  const _$PreviewResponseImpl({
    required this.preview,
    required final List<String> suggestedCorrections,
    final Map<String, dynamic>? metadata,
  }) : _suggestedCorrections = suggestedCorrections,
       _metadata = metadata;

  factory _$PreviewResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PreviewResponseImplFromJson(json);

  @override
  final PreviewEntity preview;
  final List<String> _suggestedCorrections;
  @override
  List<String> get suggestedCorrections {
    if (_suggestedCorrections is EqualUnmodifiableListView)
      return _suggestedCorrections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestedCorrections);
  }

  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'PreviewResponse(preview: $preview, suggestedCorrections: $suggestedCorrections, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PreviewResponseImpl &&
            (identical(other.preview, preview) || other.preview == preview) &&
            const DeepCollectionEquality().equals(
              other._suggestedCorrections,
              _suggestedCorrections,
            ) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    preview,
    const DeepCollectionEquality().hash(_suggestedCorrections),
    const DeepCollectionEquality().hash(_metadata),
  );

  /// Create a copy of PreviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PreviewResponseImplCopyWith<_$PreviewResponseImpl> get copyWith =>
      __$$PreviewResponseImplCopyWithImpl<_$PreviewResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PreviewResponseImplToJson(this);
  }
}

abstract class _PreviewResponse implements PreviewResponse {
  const factory _PreviewResponse({
    required final PreviewEntity preview,
    required final List<String> suggestedCorrections,
    final Map<String, dynamic>? metadata,
  }) = _$PreviewResponseImpl;

  factory _PreviewResponse.fromJson(Map<String, dynamic> json) =
      _$PreviewResponseImpl.fromJson;

  @override
  PreviewEntity get preview;
  @override
  List<String> get suggestedCorrections;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of PreviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PreviewResponseImplCopyWith<_$PreviewResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BackendPreviewResponse _$BackendPreviewResponseFromJson(
  Map<String, dynamic> json,
) {
  return _BackendPreviewResponse.fromJson(json);
}

/// @nodoc
mixin _$BackendPreviewResponse {
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  BackendPreviewData get preview => throw _privateConstructorUsedError;

  /// Serializes this BackendPreviewResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BackendPreviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BackendPreviewResponseCopyWith<BackendPreviewResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackendPreviewResponseCopyWith<$Res> {
  factory $BackendPreviewResponseCopyWith(
    BackendPreviewResponse value,
    $Res Function(BackendPreviewResponse) then,
  ) = _$BackendPreviewResponseCopyWithImpl<$Res, BackendPreviewResponse>;
  @useResult
  $Res call({bool success, String message, BackendPreviewData preview});

  $BackendPreviewDataCopyWith<$Res> get preview;
}

/// @nodoc
class _$BackendPreviewResponseCopyWithImpl<
  $Res,
  $Val extends BackendPreviewResponse
>
    implements $BackendPreviewResponseCopyWith<$Res> {
  _$BackendPreviewResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BackendPreviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? preview = null,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            preview: null == preview
                ? _value.preview
                : preview // ignore: cast_nullable_to_non_nullable
                      as BackendPreviewData,
          )
          as $Val,
    );
  }

  /// Create a copy of BackendPreviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BackendPreviewDataCopyWith<$Res> get preview {
    return $BackendPreviewDataCopyWith<$Res>(_value.preview, (value) {
      return _then(_value.copyWith(preview: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BackendPreviewResponseImplCopyWith<$Res>
    implements $BackendPreviewResponseCopyWith<$Res> {
  factory _$$BackendPreviewResponseImplCopyWith(
    _$BackendPreviewResponseImpl value,
    $Res Function(_$BackendPreviewResponseImpl) then,
  ) = __$$BackendPreviewResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String message, BackendPreviewData preview});

  @override
  $BackendPreviewDataCopyWith<$Res> get preview;
}

/// @nodoc
class __$$BackendPreviewResponseImplCopyWithImpl<$Res>
    extends
        _$BackendPreviewResponseCopyWithImpl<$Res, _$BackendPreviewResponseImpl>
    implements _$$BackendPreviewResponseImplCopyWith<$Res> {
  __$$BackendPreviewResponseImplCopyWithImpl(
    _$BackendPreviewResponseImpl _value,
    $Res Function(_$BackendPreviewResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BackendPreviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? preview = null,
  }) {
    return _then(
      _$BackendPreviewResponseImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        preview: null == preview
            ? _value.preview
            : preview // ignore: cast_nullable_to_non_nullable
                  as BackendPreviewData,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BackendPreviewResponseImpl implements _BackendPreviewResponse {
  const _$BackendPreviewResponseImpl({
    required this.success,
    required this.message,
    required this.preview,
  });

  factory _$BackendPreviewResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$BackendPreviewResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String message;
  @override
  final BackendPreviewData preview;

  @override
  String toString() {
    return 'BackendPreviewResponse(success: $success, message: $message, preview: $preview)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackendPreviewResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.preview, preview) || other.preview == preview));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, message, preview);

  /// Create a copy of BackendPreviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BackendPreviewResponseImplCopyWith<_$BackendPreviewResponseImpl>
  get copyWith =>
      __$$BackendPreviewResponseImplCopyWithImpl<_$BackendPreviewResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BackendPreviewResponseImplToJson(this);
  }
}

abstract class _BackendPreviewResponse implements BackendPreviewResponse {
  const factory _BackendPreviewResponse({
    required final bool success,
    required final String message,
    required final BackendPreviewData preview,
  }) = _$BackendPreviewResponseImpl;

  factory _BackendPreviewResponse.fromJson(Map<String, dynamic> json) =
      _$BackendPreviewResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String get message;
  @override
  BackendPreviewData get preview;

  /// Create a copy of BackendPreviewResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BackendPreviewResponseImplCopyWith<_$BackendPreviewResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}

BackendPreviewData _$BackendPreviewDataFromJson(Map<String, dynamic> json) {
  return _BackendPreviewData.fromJson(json);
}

/// @nodoc
mixin _$BackendPreviewData {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get image_url => throw _privateConstructorUsedError;
  String? get video_url => throw _privateConstructorUsedError; // For reels
  dynamic get suggested_caption => throw _privateConstructorUsedError;

  /// Serializes this BackendPreviewData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BackendPreviewData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BackendPreviewDataCopyWith<BackendPreviewData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackendPreviewDataCopyWith<$Res> {
  factory $BackendPreviewDataCopyWith(
    BackendPreviewData value,
    $Res Function(BackendPreviewData) then,
  ) = _$BackendPreviewDataCopyWithImpl<$Res, BackendPreviewData>;
  @useResult
  $Res call({
    String id,
    String type,
    String image_url,
    String? video_url,
    dynamic suggested_caption,
  });
}

/// @nodoc
class _$BackendPreviewDataCopyWithImpl<$Res, $Val extends BackendPreviewData>
    implements $BackendPreviewDataCopyWith<$Res> {
  _$BackendPreviewDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BackendPreviewData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? image_url = null,
    Object? video_url = freezed,
    Object? suggested_caption = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            image_url: null == image_url
                ? _value.image_url
                : image_url // ignore: cast_nullable_to_non_nullable
                      as String,
            video_url: freezed == video_url
                ? _value.video_url
                : video_url // ignore: cast_nullable_to_non_nullable
                      as String?,
            suggested_caption: freezed == suggested_caption
                ? _value.suggested_caption
                : suggested_caption // ignore: cast_nullable_to_non_nullable
                      as dynamic,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BackendPreviewDataImplCopyWith<$Res>
    implements $BackendPreviewDataCopyWith<$Res> {
  factory _$$BackendPreviewDataImplCopyWith(
    _$BackendPreviewDataImpl value,
    $Res Function(_$BackendPreviewDataImpl) then,
  ) = __$$BackendPreviewDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String type,
    String image_url,
    String? video_url,
    dynamic suggested_caption,
  });
}

/// @nodoc
class __$$BackendPreviewDataImplCopyWithImpl<$Res>
    extends _$BackendPreviewDataCopyWithImpl<$Res, _$BackendPreviewDataImpl>
    implements _$$BackendPreviewDataImplCopyWith<$Res> {
  __$$BackendPreviewDataImplCopyWithImpl(
    _$BackendPreviewDataImpl _value,
    $Res Function(_$BackendPreviewDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BackendPreviewData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? image_url = null,
    Object? video_url = freezed,
    Object? suggested_caption = freezed,
  }) {
    return _then(
      _$BackendPreviewDataImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        image_url: null == image_url
            ? _value.image_url
            : image_url // ignore: cast_nullable_to_non_nullable
                  as String,
        video_url: freezed == video_url
            ? _value.video_url
            : video_url // ignore: cast_nullable_to_non_nullable
                  as String?,
        suggested_caption: freezed == suggested_caption
            ? _value.suggested_caption
            : suggested_caption // ignore: cast_nullable_to_non_nullable
                  as dynamic,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BackendPreviewDataImpl implements _BackendPreviewData {
  const _$BackendPreviewDataImpl({
    required this.id,
    required this.type,
    required this.image_url,
    this.video_url,
    required this.suggested_caption,
  });

  factory _$BackendPreviewDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$BackendPreviewDataImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
  @override
  final String image_url;
  @override
  final String? video_url;
  // For reels
  @override
  final dynamic suggested_caption;

  @override
  String toString() {
    return 'BackendPreviewData(id: $id, type: $type, image_url: $image_url, video_url: $video_url, suggested_caption: $suggested_caption)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackendPreviewDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.image_url, image_url) ||
                other.image_url == image_url) &&
            (identical(other.video_url, video_url) ||
                other.video_url == video_url) &&
            const DeepCollectionEquality().equals(
              other.suggested_caption,
              suggested_caption,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    image_url,
    video_url,
    const DeepCollectionEquality().hash(suggested_caption),
  );

  /// Create a copy of BackendPreviewData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BackendPreviewDataImplCopyWith<_$BackendPreviewDataImpl> get copyWith =>
      __$$BackendPreviewDataImplCopyWithImpl<_$BackendPreviewDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BackendPreviewDataImplToJson(this);
  }
}

abstract class _BackendPreviewData implements BackendPreviewData {
  const factory _BackendPreviewData({
    required final String id,
    required final String type,
    required final String image_url,
    final String? video_url,
    required final dynamic suggested_caption,
  }) = _$BackendPreviewDataImpl;

  factory _BackendPreviewData.fromJson(Map<String, dynamic> json) =
      _$BackendPreviewDataImpl.fromJson;

  @override
  String get id;
  @override
  String get type;
  @override
  String get image_url;
  @override
  String? get video_url; // For reels
  @override
  dynamic get suggested_caption;

  /// Create a copy of BackendPreviewData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BackendPreviewDataImplCopyWith<_$BackendPreviewDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

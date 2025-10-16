// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StoryEntity _$StoryEntityFromJson(Map<String, dynamic> json) {
  return _StoryEntity.fromJson(json);
}

/// @nodoc
mixin _$StoryEntity {
  String get id => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  bool get aiGenerated => throw _privateConstructorUsedError;
  String? get aiPrompt => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get instagramStoryId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get publishedAt => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;

  /// Serializes this StoryEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryEntityCopyWith<StoryEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryEntityCopyWith<$Res> {
  factory $StoryEntityCopyWith(
    StoryEntity value,
    $Res Function(StoryEntity) then,
  ) = _$StoryEntityCopyWithImpl<$Res, StoryEntity>;
  @useResult
  $Res call({
    String id,
    String imageUrl,
    bool aiGenerated,
    String? aiPrompt,
    String status,
    String? instagramStoryId,
    DateTime createdAt,
    DateTime? publishedAt,
    String createdBy,
  });
}

/// @nodoc
class _$StoryEntityCopyWithImpl<$Res, $Val extends StoryEntity>
    implements $StoryEntityCopyWith<$Res> {
  _$StoryEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? aiGenerated = null,
    Object? aiPrompt = freezed,
    Object? status = null,
    Object? instagramStoryId = freezed,
    Object? createdAt = null,
    Object? publishedAt = freezed,
    Object? createdBy = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrl: null == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            aiGenerated: null == aiGenerated
                ? _value.aiGenerated
                : aiGenerated // ignore: cast_nullable_to_non_nullable
                      as bool,
            aiPrompt: freezed == aiPrompt
                ? _value.aiPrompt
                : aiPrompt // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            instagramStoryId: freezed == instagramStoryId
                ? _value.instagramStoryId
                : instagramStoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            publishedAt: freezed == publishedAt
                ? _value.publishedAt
                : publishedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            createdBy: null == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StoryEntityImplCopyWith<$Res>
    implements $StoryEntityCopyWith<$Res> {
  factory _$$StoryEntityImplCopyWith(
    _$StoryEntityImpl value,
    $Res Function(_$StoryEntityImpl) then,
  ) = __$$StoryEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String imageUrl,
    bool aiGenerated,
    String? aiPrompt,
    String status,
    String? instagramStoryId,
    DateTime createdAt,
    DateTime? publishedAt,
    String createdBy,
  });
}

/// @nodoc
class __$$StoryEntityImplCopyWithImpl<$Res>
    extends _$StoryEntityCopyWithImpl<$Res, _$StoryEntityImpl>
    implements _$$StoryEntityImplCopyWith<$Res> {
  __$$StoryEntityImplCopyWithImpl(
    _$StoryEntityImpl _value,
    $Res Function(_$StoryEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? aiGenerated = null,
    Object? aiPrompt = freezed,
    Object? status = null,
    Object? instagramStoryId = freezed,
    Object? createdAt = null,
    Object? publishedAt = freezed,
    Object? createdBy = null,
  }) {
    return _then(
      _$StoryEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrl: null == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        aiGenerated: null == aiGenerated
            ? _value.aiGenerated
            : aiGenerated // ignore: cast_nullable_to_non_nullable
                  as bool,
        aiPrompt: freezed == aiPrompt
            ? _value.aiPrompt
            : aiPrompt // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        instagramStoryId: freezed == instagramStoryId
            ? _value.instagramStoryId
            : instagramStoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        publishedAt: freezed == publishedAt
            ? _value.publishedAt
            : publishedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdBy: null == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryEntityImpl implements _StoryEntity {
  const _$StoryEntityImpl({
    required this.id,
    required this.imageUrl,
    required this.aiGenerated,
    this.aiPrompt,
    required this.status,
    this.instagramStoryId,
    required this.createdAt,
    this.publishedAt,
    required this.createdBy,
  });

  factory _$StoryEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String imageUrl;
  @override
  final bool aiGenerated;
  @override
  final String? aiPrompt;
  @override
  final String status;
  @override
  final String? instagramStoryId;
  @override
  final DateTime createdAt;
  @override
  final DateTime? publishedAt;
  @override
  final String createdBy;

  @override
  String toString() {
    return 'StoryEntity(id: $id, imageUrl: $imageUrl, aiGenerated: $aiGenerated, aiPrompt: $aiPrompt, status: $status, instagramStoryId: $instagramStoryId, createdAt: $createdAt, publishedAt: $publishedAt, createdBy: $createdBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.aiGenerated, aiGenerated) ||
                other.aiGenerated == aiGenerated) &&
            (identical(other.aiPrompt, aiPrompt) ||
                other.aiPrompt == aiPrompt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.instagramStoryId, instagramStoryId) ||
                other.instagramStoryId == instagramStoryId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    imageUrl,
    aiGenerated,
    aiPrompt,
    status,
    instagramStoryId,
    createdAt,
    publishedAt,
    createdBy,
  );

  /// Create a copy of StoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryEntityImplCopyWith<_$StoryEntityImpl> get copyWith =>
      __$$StoryEntityImplCopyWithImpl<_$StoryEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryEntityImplToJson(this);
  }
}

abstract class _StoryEntity implements StoryEntity {
  const factory _StoryEntity({
    required final String id,
    required final String imageUrl,
    required final bool aiGenerated,
    final String? aiPrompt,
    required final String status,
    final String? instagramStoryId,
    required final DateTime createdAt,
    final DateTime? publishedAt,
    required final String createdBy,
  }) = _$StoryEntityImpl;

  factory _StoryEntity.fromJson(Map<String, dynamic> json) =
      _$StoryEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get imageUrl;
  @override
  bool get aiGenerated;
  @override
  String? get aiPrompt;
  @override
  String get status;
  @override
  String? get instagramStoryId;
  @override
  DateTime get createdAt;
  @override
  DateTime? get publishedAt;
  @override
  String get createdBy;

  /// Create a copy of StoryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryEntityImplCopyWith<_$StoryEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoriesResponse _$StoriesResponseFromJson(Map<String, dynamic> json) {
  return _StoriesResponse.fromJson(json);
}

/// @nodoc
mixin _$StoriesResponse {
  List<StoryEntity> get stories => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  int get offset => throw _privateConstructorUsedError;

  /// Serializes this StoriesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoriesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoriesResponseCopyWith<StoriesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoriesResponseCopyWith<$Res> {
  factory $StoriesResponseCopyWith(
    StoriesResponse value,
    $Res Function(StoriesResponse) then,
  ) = _$StoriesResponseCopyWithImpl<$Res, StoriesResponse>;
  @useResult
  $Res call({List<StoryEntity> stories, int total, int limit, int offset});
}

/// @nodoc
class _$StoriesResponseCopyWithImpl<$Res, $Val extends StoriesResponse>
    implements $StoriesResponseCopyWith<$Res> {
  _$StoriesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoriesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stories = null,
    Object? total = null,
    Object? limit = null,
    Object? offset = null,
  }) {
    return _then(
      _value.copyWith(
            stories: null == stories
                ? _value.stories
                : stories // ignore: cast_nullable_to_non_nullable
                      as List<StoryEntity>,
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StoriesResponseImplCopyWith<$Res>
    implements $StoriesResponseCopyWith<$Res> {
  factory _$$StoriesResponseImplCopyWith(
    _$StoriesResponseImpl value,
    $Res Function(_$StoriesResponseImpl) then,
  ) = __$$StoriesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<StoryEntity> stories, int total, int limit, int offset});
}

/// @nodoc
class __$$StoriesResponseImplCopyWithImpl<$Res>
    extends _$StoriesResponseCopyWithImpl<$Res, _$StoriesResponseImpl>
    implements _$$StoriesResponseImplCopyWith<$Res> {
  __$$StoriesResponseImplCopyWithImpl(
    _$StoriesResponseImpl _value,
    $Res Function(_$StoriesResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StoriesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stories = null,
    Object? total = null,
    Object? limit = null,
    Object? offset = null,
  }) {
    return _then(
      _$StoriesResponseImpl(
        stories: null == stories
            ? _value._stories
            : stories // ignore: cast_nullable_to_non_nullable
                  as List<StoryEntity>,
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StoriesResponseImpl implements _StoriesResponse {
  const _$StoriesResponseImpl({
    required final List<StoryEntity> stories,
    required this.total,
    required this.limit,
    required this.offset,
  }) : _stories = stories;

  factory _$StoriesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoriesResponseImplFromJson(json);

  final List<StoryEntity> _stories;
  @override
  List<StoryEntity> get stories {
    if (_stories is EqualUnmodifiableListView) return _stories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stories);
  }

  @override
  final int total;
  @override
  final int limit;
  @override
  final int offset;

  @override
  String toString() {
    return 'StoriesResponse(stories: $stories, total: $total, limit: $limit, offset: $offset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoriesResponseImpl &&
            const DeepCollectionEquality().equals(other._stories, _stories) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_stories),
    total,
    limit,
    offset,
  );

  /// Create a copy of StoriesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoriesResponseImplCopyWith<_$StoriesResponseImpl> get copyWith =>
      __$$StoriesResponseImplCopyWithImpl<_$StoriesResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StoriesResponseImplToJson(this);
  }
}

abstract class _StoriesResponse implements StoriesResponse {
  const factory _StoriesResponse({
    required final List<StoryEntity> stories,
    required final int total,
    required final int limit,
    required final int offset,
  }) = _$StoriesResponseImpl;

  factory _StoriesResponse.fromJson(Map<String, dynamic> json) =
      _$StoriesResponseImpl.fromJson;

  @override
  List<StoryEntity> get stories;
  @override
  int get total;
  @override
  int get limit;
  @override
  int get offset;

  /// Create a copy of StoriesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoriesResponseImplCopyWith<_$StoriesResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

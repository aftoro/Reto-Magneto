// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnalyticsEntity _$AnalyticsEntityFromJson(Map<String, dynamic> json) {
  return _AnalyticsEntity.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsEntity {
  String get timestamp => throw _privateConstructorUsedError;
  DataRangeEntity get dataRange => throw _privateConstructorUsedError;
  PostsAnalyticsEntity get posts => throw _privateConstructorUsedError;
  ConversationsAnalyticsEntity get conversations =>
      throw _privateConstructorUsedError;
  AIInsightsEntity get aiInsights => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsEntityCopyWith<AnalyticsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsEntityCopyWith<$Res> {
  factory $AnalyticsEntityCopyWith(
    AnalyticsEntity value,
    $Res Function(AnalyticsEntity) then,
  ) = _$AnalyticsEntityCopyWithImpl<$Res, AnalyticsEntity>;
  @useResult
  $Res call({
    String timestamp,
    DataRangeEntity dataRange,
    PostsAnalyticsEntity posts,
    ConversationsAnalyticsEntity conversations,
    AIInsightsEntity aiInsights,
  });

  $DataRangeEntityCopyWith<$Res> get dataRange;
  $PostsAnalyticsEntityCopyWith<$Res> get posts;
  $ConversationsAnalyticsEntityCopyWith<$Res> get conversations;
  $AIInsightsEntityCopyWith<$Res> get aiInsights;
}

/// @nodoc
class _$AnalyticsEntityCopyWithImpl<$Res, $Val extends AnalyticsEntity>
    implements $AnalyticsEntityCopyWith<$Res> {
  _$AnalyticsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? dataRange = null,
    Object? posts = null,
    Object? conversations = null,
    Object? aiInsights = null,
  }) {
    return _then(
      _value.copyWith(
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as String,
            dataRange: null == dataRange
                ? _value.dataRange
                : dataRange // ignore: cast_nullable_to_non_nullable
                      as DataRangeEntity,
            posts: null == posts
                ? _value.posts
                : posts // ignore: cast_nullable_to_non_nullable
                      as PostsAnalyticsEntity,
            conversations: null == conversations
                ? _value.conversations
                : conversations // ignore: cast_nullable_to_non_nullable
                      as ConversationsAnalyticsEntity,
            aiInsights: null == aiInsights
                ? _value.aiInsights
                : aiInsights // ignore: cast_nullable_to_non_nullable
                      as AIInsightsEntity,
          )
          as $Val,
    );
  }

  /// Create a copy of AnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DataRangeEntityCopyWith<$Res> get dataRange {
    return $DataRangeEntityCopyWith<$Res>(_value.dataRange, (value) {
      return _then(_value.copyWith(dataRange: value) as $Val);
    });
  }

  /// Create a copy of AnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PostsAnalyticsEntityCopyWith<$Res> get posts {
    return $PostsAnalyticsEntityCopyWith<$Res>(_value.posts, (value) {
      return _then(_value.copyWith(posts: value) as $Val);
    });
  }

  /// Create a copy of AnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConversationsAnalyticsEntityCopyWith<$Res> get conversations {
    return $ConversationsAnalyticsEntityCopyWith<$Res>(_value.conversations, (
      value,
    ) {
      return _then(_value.copyWith(conversations: value) as $Val);
    });
  }

  /// Create a copy of AnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AIInsightsEntityCopyWith<$Res> get aiInsights {
    return $AIInsightsEntityCopyWith<$Res>(_value.aiInsights, (value) {
      return _then(_value.copyWith(aiInsights: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnalyticsEntityImplCopyWith<$Res>
    implements $AnalyticsEntityCopyWith<$Res> {
  factory _$$AnalyticsEntityImplCopyWith(
    _$AnalyticsEntityImpl value,
    $Res Function(_$AnalyticsEntityImpl) then,
  ) = __$$AnalyticsEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String timestamp,
    DataRangeEntity dataRange,
    PostsAnalyticsEntity posts,
    ConversationsAnalyticsEntity conversations,
    AIInsightsEntity aiInsights,
  });

  @override
  $DataRangeEntityCopyWith<$Res> get dataRange;
  @override
  $PostsAnalyticsEntityCopyWith<$Res> get posts;
  @override
  $ConversationsAnalyticsEntityCopyWith<$Res> get conversations;
  @override
  $AIInsightsEntityCopyWith<$Res> get aiInsights;
}

/// @nodoc
class __$$AnalyticsEntityImplCopyWithImpl<$Res>
    extends _$AnalyticsEntityCopyWithImpl<$Res, _$AnalyticsEntityImpl>
    implements _$$AnalyticsEntityImplCopyWith<$Res> {
  __$$AnalyticsEntityImplCopyWithImpl(
    _$AnalyticsEntityImpl _value,
    $Res Function(_$AnalyticsEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? dataRange = null,
    Object? posts = null,
    Object? conversations = null,
    Object? aiInsights = null,
  }) {
    return _then(
      _$AnalyticsEntityImpl(
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as String,
        dataRange: null == dataRange
            ? _value.dataRange
            : dataRange // ignore: cast_nullable_to_non_nullable
                  as DataRangeEntity,
        posts: null == posts
            ? _value.posts
            : posts // ignore: cast_nullable_to_non_nullable
                  as PostsAnalyticsEntity,
        conversations: null == conversations
            ? _value.conversations
            : conversations // ignore: cast_nullable_to_non_nullable
                  as ConversationsAnalyticsEntity,
        aiInsights: null == aiInsights
            ? _value.aiInsights
            : aiInsights // ignore: cast_nullable_to_non_nullable
                  as AIInsightsEntity,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsEntityImpl implements _AnalyticsEntity {
  const _$AnalyticsEntityImpl({
    required this.timestamp,
    required this.dataRange,
    required this.posts,
    required this.conversations,
    required this.aiInsights,
  });

  factory _$AnalyticsEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsEntityImplFromJson(json);

  @override
  final String timestamp;
  @override
  final DataRangeEntity dataRange;
  @override
  final PostsAnalyticsEntity posts;
  @override
  final ConversationsAnalyticsEntity conversations;
  @override
  final AIInsightsEntity aiInsights;

  @override
  String toString() {
    return 'AnalyticsEntity(timestamp: $timestamp, dataRange: $dataRange, posts: $posts, conversations: $conversations, aiInsights: $aiInsights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsEntityImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.dataRange, dataRange) ||
                other.dataRange == dataRange) &&
            (identical(other.posts, posts) || other.posts == posts) &&
            (identical(other.conversations, conversations) ||
                other.conversations == conversations) &&
            (identical(other.aiInsights, aiInsights) ||
                other.aiInsights == aiInsights));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    timestamp,
    dataRange,
    posts,
    conversations,
    aiInsights,
  );

  /// Create a copy of AnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsEntityImplCopyWith<_$AnalyticsEntityImpl> get copyWith =>
      __$$AnalyticsEntityImplCopyWithImpl<_$AnalyticsEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsEntityImplToJson(this);
  }
}

abstract class _AnalyticsEntity implements AnalyticsEntity {
  const factory _AnalyticsEntity({
    required final String timestamp,
    required final DataRangeEntity dataRange,
    required final PostsAnalyticsEntity posts,
    required final ConversationsAnalyticsEntity conversations,
    required final AIInsightsEntity aiInsights,
  }) = _$AnalyticsEntityImpl;

  factory _AnalyticsEntity.fromJson(Map<String, dynamic> json) =
      _$AnalyticsEntityImpl.fromJson;

  @override
  String get timestamp;
  @override
  DataRangeEntity get dataRange;
  @override
  PostsAnalyticsEntity get posts;
  @override
  ConversationsAnalyticsEntity get conversations;
  @override
  AIInsightsEntity get aiInsights;

  /// Create a copy of AnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsEntityImplCopyWith<_$AnalyticsEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DataRangeEntity _$DataRangeEntityFromJson(Map<String, dynamic> json) {
  return _DataRangeEntity.fromJson(json);
}

/// @nodoc
mixin _$DataRangeEntity {
  int get postsAnalyzed => throw _privateConstructorUsedError;
  int get conversationsAnalyzed => throw _privateConstructorUsedError;
  String get period => throw _privateConstructorUsedError;

  /// Serializes this DataRangeEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DataRangeEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DataRangeEntityCopyWith<DataRangeEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataRangeEntityCopyWith<$Res> {
  factory $DataRangeEntityCopyWith(
    DataRangeEntity value,
    $Res Function(DataRangeEntity) then,
  ) = _$DataRangeEntityCopyWithImpl<$Res, DataRangeEntity>;
  @useResult
  $Res call({int postsAnalyzed, int conversationsAnalyzed, String period});
}

/// @nodoc
class _$DataRangeEntityCopyWithImpl<$Res, $Val extends DataRangeEntity>
    implements $DataRangeEntityCopyWith<$Res> {
  _$DataRangeEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DataRangeEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postsAnalyzed = null,
    Object? conversationsAnalyzed = null,
    Object? period = null,
  }) {
    return _then(
      _value.copyWith(
            postsAnalyzed: null == postsAnalyzed
                ? _value.postsAnalyzed
                : postsAnalyzed // ignore: cast_nullable_to_non_nullable
                      as int,
            conversationsAnalyzed: null == conversationsAnalyzed
                ? _value.conversationsAnalyzed
                : conversationsAnalyzed // ignore: cast_nullable_to_non_nullable
                      as int,
            period: null == period
                ? _value.period
                : period // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DataRangeEntityImplCopyWith<$Res>
    implements $DataRangeEntityCopyWith<$Res> {
  factory _$$DataRangeEntityImplCopyWith(
    _$DataRangeEntityImpl value,
    $Res Function(_$DataRangeEntityImpl) then,
  ) = __$$DataRangeEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int postsAnalyzed, int conversationsAnalyzed, String period});
}

/// @nodoc
class __$$DataRangeEntityImplCopyWithImpl<$Res>
    extends _$DataRangeEntityCopyWithImpl<$Res, _$DataRangeEntityImpl>
    implements _$$DataRangeEntityImplCopyWith<$Res> {
  __$$DataRangeEntityImplCopyWithImpl(
    _$DataRangeEntityImpl _value,
    $Res Function(_$DataRangeEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DataRangeEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postsAnalyzed = null,
    Object? conversationsAnalyzed = null,
    Object? period = null,
  }) {
    return _then(
      _$DataRangeEntityImpl(
        postsAnalyzed: null == postsAnalyzed
            ? _value.postsAnalyzed
            : postsAnalyzed // ignore: cast_nullable_to_non_nullable
                  as int,
        conversationsAnalyzed: null == conversationsAnalyzed
            ? _value.conversationsAnalyzed
            : conversationsAnalyzed // ignore: cast_nullable_to_non_nullable
                  as int,
        period: null == period
            ? _value.period
            : period // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DataRangeEntityImpl implements _DataRangeEntity {
  const _$DataRangeEntityImpl({
    required this.postsAnalyzed,
    required this.conversationsAnalyzed,
    required this.period,
  });

  factory _$DataRangeEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$DataRangeEntityImplFromJson(json);

  @override
  final int postsAnalyzed;
  @override
  final int conversationsAnalyzed;
  @override
  final String period;

  @override
  String toString() {
    return 'DataRangeEntity(postsAnalyzed: $postsAnalyzed, conversationsAnalyzed: $conversationsAnalyzed, period: $period)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataRangeEntityImpl &&
            (identical(other.postsAnalyzed, postsAnalyzed) ||
                other.postsAnalyzed == postsAnalyzed) &&
            (identical(other.conversationsAnalyzed, conversationsAnalyzed) ||
                other.conversationsAnalyzed == conversationsAnalyzed) &&
            (identical(other.period, period) || other.period == period));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, postsAnalyzed, conversationsAnalyzed, period);

  /// Create a copy of DataRangeEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DataRangeEntityImplCopyWith<_$DataRangeEntityImpl> get copyWith =>
      __$$DataRangeEntityImplCopyWithImpl<_$DataRangeEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DataRangeEntityImplToJson(this);
  }
}

abstract class _DataRangeEntity implements DataRangeEntity {
  const factory _DataRangeEntity({
    required final int postsAnalyzed,
    required final int conversationsAnalyzed,
    required final String period,
  }) = _$DataRangeEntityImpl;

  factory _DataRangeEntity.fromJson(Map<String, dynamic> json) =
      _$DataRangeEntityImpl.fromJson;

  @override
  int get postsAnalyzed;
  @override
  int get conversationsAnalyzed;
  @override
  String get period;

  /// Create a copy of DataRangeEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DataRangeEntityImplCopyWith<_$DataRangeEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PostsAnalyticsEntity _$PostsAnalyticsEntityFromJson(Map<String, dynamic> json) {
  return _PostsAnalyticsEntity.fromJson(json);
}

/// @nodoc
mixin _$PostsAnalyticsEntity {
  PostsSummaryEntity get summary => throw _privateConstructorUsedError;
  List<TopSectorEntity> get topSectors => throw _privateConstructorUsedError;
  List<TopPositionEntity> get topPositions =>
      throw _privateConstructorUsedError;
  List<RecentPostEntity> get recentPosts => throw _privateConstructorUsedError;

  /// Serializes this PostsAnalyticsEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostsAnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostsAnalyticsEntityCopyWith<PostsAnalyticsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostsAnalyticsEntityCopyWith<$Res> {
  factory $PostsAnalyticsEntityCopyWith(
    PostsAnalyticsEntity value,
    $Res Function(PostsAnalyticsEntity) then,
  ) = _$PostsAnalyticsEntityCopyWithImpl<$Res, PostsAnalyticsEntity>;
  @useResult
  $Res call({
    PostsSummaryEntity summary,
    List<TopSectorEntity> topSectors,
    List<TopPositionEntity> topPositions,
    List<RecentPostEntity> recentPosts,
  });

  $PostsSummaryEntityCopyWith<$Res> get summary;
}

/// @nodoc
class _$PostsAnalyticsEntityCopyWithImpl<
  $Res,
  $Val extends PostsAnalyticsEntity
>
    implements $PostsAnalyticsEntityCopyWith<$Res> {
  _$PostsAnalyticsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostsAnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? topSectors = null,
    Object? topPositions = null,
    Object? recentPosts = null,
  }) {
    return _then(
      _value.copyWith(
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as PostsSummaryEntity,
            topSectors: null == topSectors
                ? _value.topSectors
                : topSectors // ignore: cast_nullable_to_non_nullable
                      as List<TopSectorEntity>,
            topPositions: null == topPositions
                ? _value.topPositions
                : topPositions // ignore: cast_nullable_to_non_nullable
                      as List<TopPositionEntity>,
            recentPosts: null == recentPosts
                ? _value.recentPosts
                : recentPosts // ignore: cast_nullable_to_non_nullable
                      as List<RecentPostEntity>,
          )
          as $Val,
    );
  }

  /// Create a copy of PostsAnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PostsSummaryEntityCopyWith<$Res> get summary {
    return $PostsSummaryEntityCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PostsAnalyticsEntityImplCopyWith<$Res>
    implements $PostsAnalyticsEntityCopyWith<$Res> {
  factory _$$PostsAnalyticsEntityImplCopyWith(
    _$PostsAnalyticsEntityImpl value,
    $Res Function(_$PostsAnalyticsEntityImpl) then,
  ) = __$$PostsAnalyticsEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    PostsSummaryEntity summary,
    List<TopSectorEntity> topSectors,
    List<TopPositionEntity> topPositions,
    List<RecentPostEntity> recentPosts,
  });

  @override
  $PostsSummaryEntityCopyWith<$Res> get summary;
}

/// @nodoc
class __$$PostsAnalyticsEntityImplCopyWithImpl<$Res>
    extends _$PostsAnalyticsEntityCopyWithImpl<$Res, _$PostsAnalyticsEntityImpl>
    implements _$$PostsAnalyticsEntityImplCopyWith<$Res> {
  __$$PostsAnalyticsEntityImplCopyWithImpl(
    _$PostsAnalyticsEntityImpl _value,
    $Res Function(_$PostsAnalyticsEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostsAnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? topSectors = null,
    Object? topPositions = null,
    Object? recentPosts = null,
  }) {
    return _then(
      _$PostsAnalyticsEntityImpl(
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as PostsSummaryEntity,
        topSectors: null == topSectors
            ? _value._topSectors
            : topSectors // ignore: cast_nullable_to_non_nullable
                  as List<TopSectorEntity>,
        topPositions: null == topPositions
            ? _value._topPositions
            : topPositions // ignore: cast_nullable_to_non_nullable
                  as List<TopPositionEntity>,
        recentPosts: null == recentPosts
            ? _value._recentPosts
            : recentPosts // ignore: cast_nullable_to_non_nullable
                  as List<RecentPostEntity>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PostsAnalyticsEntityImpl implements _PostsAnalyticsEntity {
  const _$PostsAnalyticsEntityImpl({
    required this.summary,
    required final List<TopSectorEntity> topSectors,
    required final List<TopPositionEntity> topPositions,
    required final List<RecentPostEntity> recentPosts,
  }) : _topSectors = topSectors,
       _topPositions = topPositions,
       _recentPosts = recentPosts;

  factory _$PostsAnalyticsEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostsAnalyticsEntityImplFromJson(json);

  @override
  final PostsSummaryEntity summary;
  final List<TopSectorEntity> _topSectors;
  @override
  List<TopSectorEntity> get topSectors {
    if (_topSectors is EqualUnmodifiableListView) return _topSectors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topSectors);
  }

  final List<TopPositionEntity> _topPositions;
  @override
  List<TopPositionEntity> get topPositions {
    if (_topPositions is EqualUnmodifiableListView) return _topPositions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topPositions);
  }

  final List<RecentPostEntity> _recentPosts;
  @override
  List<RecentPostEntity> get recentPosts {
    if (_recentPosts is EqualUnmodifiableListView) return _recentPosts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentPosts);
  }

  @override
  String toString() {
    return 'PostsAnalyticsEntity(summary: $summary, topSectors: $topSectors, topPositions: $topPositions, recentPosts: $recentPosts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostsAnalyticsEntityImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(
              other._topSectors,
              _topSectors,
            ) &&
            const DeepCollectionEquality().equals(
              other._topPositions,
              _topPositions,
            ) &&
            const DeepCollectionEquality().equals(
              other._recentPosts,
              _recentPosts,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    summary,
    const DeepCollectionEquality().hash(_topSectors),
    const DeepCollectionEquality().hash(_topPositions),
    const DeepCollectionEquality().hash(_recentPosts),
  );

  /// Create a copy of PostsAnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostsAnalyticsEntityImplCopyWith<_$PostsAnalyticsEntityImpl>
  get copyWith =>
      __$$PostsAnalyticsEntityImplCopyWithImpl<_$PostsAnalyticsEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PostsAnalyticsEntityImplToJson(this);
  }
}

abstract class _PostsAnalyticsEntity implements PostsAnalyticsEntity {
  const factory _PostsAnalyticsEntity({
    required final PostsSummaryEntity summary,
    required final List<TopSectorEntity> topSectors,
    required final List<TopPositionEntity> topPositions,
    required final List<RecentPostEntity> recentPosts,
  }) = _$PostsAnalyticsEntityImpl;

  factory _PostsAnalyticsEntity.fromJson(Map<String, dynamic> json) =
      _$PostsAnalyticsEntityImpl.fromJson;

  @override
  PostsSummaryEntity get summary;
  @override
  List<TopSectorEntity> get topSectors;
  @override
  List<TopPositionEntity> get topPositions;
  @override
  List<RecentPostEntity> get recentPosts;

  /// Create a copy of PostsAnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostsAnalyticsEntityImplCopyWith<_$PostsAnalyticsEntityImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PostsSummaryEntity _$PostsSummaryEntityFromJson(Map<String, dynamic> json) {
  return _PostsSummaryEntity.fromJson(json);
}

/// @nodoc
mixin _$PostsSummaryEntity {
  int get totalPosts => throw _privateConstructorUsedError;
  int get totalComments => throw _privateConstructorUsedError;
  int get totalLikes => throw _privateConstructorUsedError;
  double get avgEngagement => throw _privateConstructorUsedError;
  int get aiResponses => throw _privateConstructorUsedError;
  int get userComments => throw _privateConstructorUsedError;

  /// Serializes this PostsSummaryEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostsSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostsSummaryEntityCopyWith<PostsSummaryEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostsSummaryEntityCopyWith<$Res> {
  factory $PostsSummaryEntityCopyWith(
    PostsSummaryEntity value,
    $Res Function(PostsSummaryEntity) then,
  ) = _$PostsSummaryEntityCopyWithImpl<$Res, PostsSummaryEntity>;
  @useResult
  $Res call({
    int totalPosts,
    int totalComments,
    int totalLikes,
    double avgEngagement,
    int aiResponses,
    int userComments,
  });
}

/// @nodoc
class _$PostsSummaryEntityCopyWithImpl<$Res, $Val extends PostsSummaryEntity>
    implements $PostsSummaryEntityCopyWith<$Res> {
  _$PostsSummaryEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostsSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPosts = null,
    Object? totalComments = null,
    Object? totalLikes = null,
    Object? avgEngagement = null,
    Object? aiResponses = null,
    Object? userComments = null,
  }) {
    return _then(
      _value.copyWith(
            totalPosts: null == totalPosts
                ? _value.totalPosts
                : totalPosts // ignore: cast_nullable_to_non_nullable
                      as int,
            totalComments: null == totalComments
                ? _value.totalComments
                : totalComments // ignore: cast_nullable_to_non_nullable
                      as int,
            totalLikes: null == totalLikes
                ? _value.totalLikes
                : totalLikes // ignore: cast_nullable_to_non_nullable
                      as int,
            avgEngagement: null == avgEngagement
                ? _value.avgEngagement
                : avgEngagement // ignore: cast_nullable_to_non_nullable
                      as double,
            aiResponses: null == aiResponses
                ? _value.aiResponses
                : aiResponses // ignore: cast_nullable_to_non_nullable
                      as int,
            userComments: null == userComments
                ? _value.userComments
                : userComments // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PostsSummaryEntityImplCopyWith<$Res>
    implements $PostsSummaryEntityCopyWith<$Res> {
  factory _$$PostsSummaryEntityImplCopyWith(
    _$PostsSummaryEntityImpl value,
    $Res Function(_$PostsSummaryEntityImpl) then,
  ) = __$$PostsSummaryEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalPosts,
    int totalComments,
    int totalLikes,
    double avgEngagement,
    int aiResponses,
    int userComments,
  });
}

/// @nodoc
class __$$PostsSummaryEntityImplCopyWithImpl<$Res>
    extends _$PostsSummaryEntityCopyWithImpl<$Res, _$PostsSummaryEntityImpl>
    implements _$$PostsSummaryEntityImplCopyWith<$Res> {
  __$$PostsSummaryEntityImplCopyWithImpl(
    _$PostsSummaryEntityImpl _value,
    $Res Function(_$PostsSummaryEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostsSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPosts = null,
    Object? totalComments = null,
    Object? totalLikes = null,
    Object? avgEngagement = null,
    Object? aiResponses = null,
    Object? userComments = null,
  }) {
    return _then(
      _$PostsSummaryEntityImpl(
        totalPosts: null == totalPosts
            ? _value.totalPosts
            : totalPosts // ignore: cast_nullable_to_non_nullable
                  as int,
        totalComments: null == totalComments
            ? _value.totalComments
            : totalComments // ignore: cast_nullable_to_non_nullable
                  as int,
        totalLikes: null == totalLikes
            ? _value.totalLikes
            : totalLikes // ignore: cast_nullable_to_non_nullable
                  as int,
        avgEngagement: null == avgEngagement
            ? _value.avgEngagement
            : avgEngagement // ignore: cast_nullable_to_non_nullable
                  as double,
        aiResponses: null == aiResponses
            ? _value.aiResponses
            : aiResponses // ignore: cast_nullable_to_non_nullable
                  as int,
        userComments: null == userComments
            ? _value.userComments
            : userComments // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PostsSummaryEntityImpl implements _PostsSummaryEntity {
  const _$PostsSummaryEntityImpl({
    required this.totalPosts,
    required this.totalComments,
    required this.totalLikes,
    required this.avgEngagement,
    required this.aiResponses,
    required this.userComments,
  });

  factory _$PostsSummaryEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostsSummaryEntityImplFromJson(json);

  @override
  final int totalPosts;
  @override
  final int totalComments;
  @override
  final int totalLikes;
  @override
  final double avgEngagement;
  @override
  final int aiResponses;
  @override
  final int userComments;

  @override
  String toString() {
    return 'PostsSummaryEntity(totalPosts: $totalPosts, totalComments: $totalComments, totalLikes: $totalLikes, avgEngagement: $avgEngagement, aiResponses: $aiResponses, userComments: $userComments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostsSummaryEntityImpl &&
            (identical(other.totalPosts, totalPosts) ||
                other.totalPosts == totalPosts) &&
            (identical(other.totalComments, totalComments) ||
                other.totalComments == totalComments) &&
            (identical(other.totalLikes, totalLikes) ||
                other.totalLikes == totalLikes) &&
            (identical(other.avgEngagement, avgEngagement) ||
                other.avgEngagement == avgEngagement) &&
            (identical(other.aiResponses, aiResponses) ||
                other.aiResponses == aiResponses) &&
            (identical(other.userComments, userComments) ||
                other.userComments == userComments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalPosts,
    totalComments,
    totalLikes,
    avgEngagement,
    aiResponses,
    userComments,
  );

  /// Create a copy of PostsSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostsSummaryEntityImplCopyWith<_$PostsSummaryEntityImpl> get copyWith =>
      __$$PostsSummaryEntityImplCopyWithImpl<_$PostsSummaryEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PostsSummaryEntityImplToJson(this);
  }
}

abstract class _PostsSummaryEntity implements PostsSummaryEntity {
  const factory _PostsSummaryEntity({
    required final int totalPosts,
    required final int totalComments,
    required final int totalLikes,
    required final double avgEngagement,
    required final int aiResponses,
    required final int userComments,
  }) = _$PostsSummaryEntityImpl;

  factory _PostsSummaryEntity.fromJson(Map<String, dynamic> json) =
      _$PostsSummaryEntityImpl.fromJson;

  @override
  int get totalPosts;
  @override
  int get totalComments;
  @override
  int get totalLikes;
  @override
  double get avgEngagement;
  @override
  int get aiResponses;
  @override
  int get userComments;

  /// Create a copy of PostsSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostsSummaryEntityImplCopyWith<_$PostsSummaryEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopSectorEntity _$TopSectorEntityFromJson(Map<String, dynamic> json) {
  return _TopSectorEntity.fromJson(json);
}

/// @nodoc
mixin _$TopSectorEntity {
  String get sector => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this TopSectorEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopSectorEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopSectorEntityCopyWith<TopSectorEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopSectorEntityCopyWith<$Res> {
  factory $TopSectorEntityCopyWith(
    TopSectorEntity value,
    $Res Function(TopSectorEntity) then,
  ) = _$TopSectorEntityCopyWithImpl<$Res, TopSectorEntity>;
  @useResult
  $Res call({String sector, int count});
}

/// @nodoc
class _$TopSectorEntityCopyWithImpl<$Res, $Val extends TopSectorEntity>
    implements $TopSectorEntityCopyWith<$Res> {
  _$TopSectorEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopSectorEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sector = null, Object? count = null}) {
    return _then(
      _value.copyWith(
            sector: null == sector
                ? _value.sector
                : sector // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$TopSectorEntityImplCopyWith<$Res>
    implements $TopSectorEntityCopyWith<$Res> {
  factory _$$TopSectorEntityImplCopyWith(
    _$TopSectorEntityImpl value,
    $Res Function(_$TopSectorEntityImpl) then,
  ) = __$$TopSectorEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String sector, int count});
}

/// @nodoc
class __$$TopSectorEntityImplCopyWithImpl<$Res>
    extends _$TopSectorEntityCopyWithImpl<$Res, _$TopSectorEntityImpl>
    implements _$$TopSectorEntityImplCopyWith<$Res> {
  __$$TopSectorEntityImplCopyWithImpl(
    _$TopSectorEntityImpl _value,
    $Res Function(_$TopSectorEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TopSectorEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sector = null, Object? count = null}) {
    return _then(
      _$TopSectorEntityImpl(
        sector: null == sector
            ? _value.sector
            : sector // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$TopSectorEntityImpl implements _TopSectorEntity {
  const _$TopSectorEntityImpl({required this.sector, required this.count});

  factory _$TopSectorEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopSectorEntityImplFromJson(json);

  @override
  final String sector;
  @override
  final int count;

  @override
  String toString() {
    return 'TopSectorEntity(sector: $sector, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopSectorEntityImpl &&
            (identical(other.sector, sector) || other.sector == sector) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sector, count);

  /// Create a copy of TopSectorEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopSectorEntityImplCopyWith<_$TopSectorEntityImpl> get copyWith =>
      __$$TopSectorEntityImplCopyWithImpl<_$TopSectorEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TopSectorEntityImplToJson(this);
  }
}

abstract class _TopSectorEntity implements TopSectorEntity {
  const factory _TopSectorEntity({
    required final String sector,
    required final int count,
  }) = _$TopSectorEntityImpl;

  factory _TopSectorEntity.fromJson(Map<String, dynamic> json) =
      _$TopSectorEntityImpl.fromJson;

  @override
  String get sector;
  @override
  int get count;

  /// Create a copy of TopSectorEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopSectorEntityImplCopyWith<_$TopSectorEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopPositionEntity _$TopPositionEntityFromJson(Map<String, dynamic> json) {
  return _TopPositionEntity.fromJson(json);
}

/// @nodoc
mixin _$TopPositionEntity {
  String get position => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this TopPositionEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopPositionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopPositionEntityCopyWith<TopPositionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopPositionEntityCopyWith<$Res> {
  factory $TopPositionEntityCopyWith(
    TopPositionEntity value,
    $Res Function(TopPositionEntity) then,
  ) = _$TopPositionEntityCopyWithImpl<$Res, TopPositionEntity>;
  @useResult
  $Res call({String position, int count});
}

/// @nodoc
class _$TopPositionEntityCopyWithImpl<$Res, $Val extends TopPositionEntity>
    implements $TopPositionEntityCopyWith<$Res> {
  _$TopPositionEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopPositionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? position = null, Object? count = null}) {
    return _then(
      _value.copyWith(
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$TopPositionEntityImplCopyWith<$Res>
    implements $TopPositionEntityCopyWith<$Res> {
  factory _$$TopPositionEntityImplCopyWith(
    _$TopPositionEntityImpl value,
    $Res Function(_$TopPositionEntityImpl) then,
  ) = __$$TopPositionEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String position, int count});
}

/// @nodoc
class __$$TopPositionEntityImplCopyWithImpl<$Res>
    extends _$TopPositionEntityCopyWithImpl<$Res, _$TopPositionEntityImpl>
    implements _$$TopPositionEntityImplCopyWith<$Res> {
  __$$TopPositionEntityImplCopyWithImpl(
    _$TopPositionEntityImpl _value,
    $Res Function(_$TopPositionEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TopPositionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? position = null, Object? count = null}) {
    return _then(
      _$TopPositionEntityImpl(
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$TopPositionEntityImpl implements _TopPositionEntity {
  const _$TopPositionEntityImpl({required this.position, required this.count});

  factory _$TopPositionEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopPositionEntityImplFromJson(json);

  @override
  final String position;
  @override
  final int count;

  @override
  String toString() {
    return 'TopPositionEntity(position: $position, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopPositionEntityImpl &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, position, count);

  /// Create a copy of TopPositionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopPositionEntityImplCopyWith<_$TopPositionEntityImpl> get copyWith =>
      __$$TopPositionEntityImplCopyWithImpl<_$TopPositionEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TopPositionEntityImplToJson(this);
  }
}

abstract class _TopPositionEntity implements TopPositionEntity {
  const factory _TopPositionEntity({
    required final String position,
    required final int count,
  }) = _$TopPositionEntityImpl;

  factory _TopPositionEntity.fromJson(Map<String, dynamic> json) =
      _$TopPositionEntityImpl.fromJson;

  @override
  String get position;
  @override
  int get count;

  /// Create a copy of TopPositionEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopPositionEntityImplCopyWith<_$TopPositionEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecentPostEntity _$RecentPostEntityFromJson(Map<String, dynamic> json) {
  return _RecentPostEntity.fromJson(json);
}

/// @nodoc
mixin _$RecentPostEntity {
  String get id => throw _privateConstructorUsedError;
  String get caption => throw _privateConstructorUsedError;
  int get comments => throw _privateConstructorUsedError;
  int get likes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this RecentPostEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecentPostEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecentPostEntityCopyWith<RecentPostEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecentPostEntityCopyWith<$Res> {
  factory $RecentPostEntityCopyWith(
    RecentPostEntity value,
    $Res Function(RecentPostEntity) then,
  ) = _$RecentPostEntityCopyWithImpl<$Res, RecentPostEntity>;
  @useResult
  $Res call({
    String id,
    String caption,
    int comments,
    int likes,
    DateTime createdAt,
  });
}

/// @nodoc
class _$RecentPostEntityCopyWithImpl<$Res, $Val extends RecentPostEntity>
    implements $RecentPostEntityCopyWith<$Res> {
  _$RecentPostEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecentPostEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? caption = null,
    Object? comments = null,
    Object? likes = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            caption: null == caption
                ? _value.caption
                : caption // ignore: cast_nullable_to_non_nullable
                      as String,
            comments: null == comments
                ? _value.comments
                : comments // ignore: cast_nullable_to_non_nullable
                      as int,
            likes: null == likes
                ? _value.likes
                : likes // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecentPostEntityImplCopyWith<$Res>
    implements $RecentPostEntityCopyWith<$Res> {
  factory _$$RecentPostEntityImplCopyWith(
    _$RecentPostEntityImpl value,
    $Res Function(_$RecentPostEntityImpl) then,
  ) = __$$RecentPostEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String caption,
    int comments,
    int likes,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$RecentPostEntityImplCopyWithImpl<$Res>
    extends _$RecentPostEntityCopyWithImpl<$Res, _$RecentPostEntityImpl>
    implements _$$RecentPostEntityImplCopyWith<$Res> {
  __$$RecentPostEntityImplCopyWithImpl(
    _$RecentPostEntityImpl _value,
    $Res Function(_$RecentPostEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecentPostEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? caption = null,
    Object? comments = null,
    Object? likes = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$RecentPostEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        caption: null == caption
            ? _value.caption
            : caption // ignore: cast_nullable_to_non_nullable
                  as String,
        comments: null == comments
            ? _value.comments
            : comments // ignore: cast_nullable_to_non_nullable
                  as int,
        likes: null == likes
            ? _value.likes
            : likes // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RecentPostEntityImpl implements _RecentPostEntity {
  const _$RecentPostEntityImpl({
    required this.id,
    required this.caption,
    required this.comments,
    required this.likes,
    required this.createdAt,
  });

  factory _$RecentPostEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecentPostEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String caption;
  @override
  final int comments;
  @override
  final int likes;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'RecentPostEntity(id: $id, caption: $caption, comments: $comments, likes: $likes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecentPostEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.comments, comments) ||
                other.comments == comments) &&
            (identical(other.likes, likes) || other.likes == likes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, caption, comments, likes, createdAt);

  /// Create a copy of RecentPostEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecentPostEntityImplCopyWith<_$RecentPostEntityImpl> get copyWith =>
      __$$RecentPostEntityImplCopyWithImpl<_$RecentPostEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RecentPostEntityImplToJson(this);
  }
}

abstract class _RecentPostEntity implements RecentPostEntity {
  const factory _RecentPostEntity({
    required final String id,
    required final String caption,
    required final int comments,
    required final int likes,
    required final DateTime createdAt,
  }) = _$RecentPostEntityImpl;

  factory _RecentPostEntity.fromJson(Map<String, dynamic> json) =
      _$RecentPostEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get caption;
  @override
  int get comments;
  @override
  int get likes;
  @override
  DateTime get createdAt;

  /// Create a copy of RecentPostEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecentPostEntityImplCopyWith<_$RecentPostEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConversationsAnalyticsEntity _$ConversationsAnalyticsEntityFromJson(
  Map<String, dynamic> json,
) {
  return _ConversationsAnalyticsEntity.fromJson(json);
}

/// @nodoc
mixin _$ConversationsAnalyticsEntity {
  ConversationsSummaryEntity get summary => throw _privateConstructorUsedError;
  List<TopProfessionEntity> get topProfessions =>
      throw _privateConstructorUsedError;
  List<TopLocationEntity> get topLocations =>
      throw _privateConstructorUsedError;
  List<ExperienceDistributionEntity> get experienceDistribution =>
      throw _privateConstructorUsedError;

  /// Serializes this ConversationsAnalyticsEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationsAnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationsAnalyticsEntityCopyWith<ConversationsAnalyticsEntity>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationsAnalyticsEntityCopyWith<$Res> {
  factory $ConversationsAnalyticsEntityCopyWith(
    ConversationsAnalyticsEntity value,
    $Res Function(ConversationsAnalyticsEntity) then,
  ) =
      _$ConversationsAnalyticsEntityCopyWithImpl<
        $Res,
        ConversationsAnalyticsEntity
      >;
  @useResult
  $Res call({
    ConversationsSummaryEntity summary,
    List<TopProfessionEntity> topProfessions,
    List<TopLocationEntity> topLocations,
    List<ExperienceDistributionEntity> experienceDistribution,
  });

  $ConversationsSummaryEntityCopyWith<$Res> get summary;
}

/// @nodoc
class _$ConversationsAnalyticsEntityCopyWithImpl<
  $Res,
  $Val extends ConversationsAnalyticsEntity
>
    implements $ConversationsAnalyticsEntityCopyWith<$Res> {
  _$ConversationsAnalyticsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationsAnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? topProfessions = null,
    Object? topLocations = null,
    Object? experienceDistribution = null,
  }) {
    return _then(
      _value.copyWith(
            summary: null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                      as ConversationsSummaryEntity,
            topProfessions: null == topProfessions
                ? _value.topProfessions
                : topProfessions // ignore: cast_nullable_to_non_nullable
                      as List<TopProfessionEntity>,
            topLocations: null == topLocations
                ? _value.topLocations
                : topLocations // ignore: cast_nullable_to_non_nullable
                      as List<TopLocationEntity>,
            experienceDistribution: null == experienceDistribution
                ? _value.experienceDistribution
                : experienceDistribution // ignore: cast_nullable_to_non_nullable
                      as List<ExperienceDistributionEntity>,
          )
          as $Val,
    );
  }

  /// Create a copy of ConversationsAnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConversationsSummaryEntityCopyWith<$Res> get summary {
    return $ConversationsSummaryEntityCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationsAnalyticsEntityImplCopyWith<$Res>
    implements $ConversationsAnalyticsEntityCopyWith<$Res> {
  factory _$$ConversationsAnalyticsEntityImplCopyWith(
    _$ConversationsAnalyticsEntityImpl value,
    $Res Function(_$ConversationsAnalyticsEntityImpl) then,
  ) = __$$ConversationsAnalyticsEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ConversationsSummaryEntity summary,
    List<TopProfessionEntity> topProfessions,
    List<TopLocationEntity> topLocations,
    List<ExperienceDistributionEntity> experienceDistribution,
  });

  @override
  $ConversationsSummaryEntityCopyWith<$Res> get summary;
}

/// @nodoc
class __$$ConversationsAnalyticsEntityImplCopyWithImpl<$Res>
    extends
        _$ConversationsAnalyticsEntityCopyWithImpl<
          $Res,
          _$ConversationsAnalyticsEntityImpl
        >
    implements _$$ConversationsAnalyticsEntityImplCopyWith<$Res> {
  __$$ConversationsAnalyticsEntityImplCopyWithImpl(
    _$ConversationsAnalyticsEntityImpl _value,
    $Res Function(_$ConversationsAnalyticsEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConversationsAnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? topProfessions = null,
    Object? topLocations = null,
    Object? experienceDistribution = null,
  }) {
    return _then(
      _$ConversationsAnalyticsEntityImpl(
        summary: null == summary
            ? _value.summary
            : summary // ignore: cast_nullable_to_non_nullable
                  as ConversationsSummaryEntity,
        topProfessions: null == topProfessions
            ? _value._topProfessions
            : topProfessions // ignore: cast_nullable_to_non_nullable
                  as List<TopProfessionEntity>,
        topLocations: null == topLocations
            ? _value._topLocations
            : topLocations // ignore: cast_nullable_to_non_nullable
                  as List<TopLocationEntity>,
        experienceDistribution: null == experienceDistribution
            ? _value._experienceDistribution
            : experienceDistribution // ignore: cast_nullable_to_non_nullable
                  as List<ExperienceDistributionEntity>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationsAnalyticsEntityImpl
    implements _ConversationsAnalyticsEntity {
  const _$ConversationsAnalyticsEntityImpl({
    required this.summary,
    required final List<TopProfessionEntity> topProfessions,
    required final List<TopLocationEntity> topLocations,
    required final List<ExperienceDistributionEntity> experienceDistribution,
  }) : _topProfessions = topProfessions,
       _topLocations = topLocations,
       _experienceDistribution = experienceDistribution;

  factory _$ConversationsAnalyticsEntityImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$ConversationsAnalyticsEntityImplFromJson(json);

  @override
  final ConversationsSummaryEntity summary;
  final List<TopProfessionEntity> _topProfessions;
  @override
  List<TopProfessionEntity> get topProfessions {
    if (_topProfessions is EqualUnmodifiableListView) return _topProfessions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topProfessions);
  }

  final List<TopLocationEntity> _topLocations;
  @override
  List<TopLocationEntity> get topLocations {
    if (_topLocations is EqualUnmodifiableListView) return _topLocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topLocations);
  }

  final List<ExperienceDistributionEntity> _experienceDistribution;
  @override
  List<ExperienceDistributionEntity> get experienceDistribution {
    if (_experienceDistribution is EqualUnmodifiableListView)
      return _experienceDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_experienceDistribution);
  }

  @override
  String toString() {
    return 'ConversationsAnalyticsEntity(summary: $summary, topProfessions: $topProfessions, topLocations: $topLocations, experienceDistribution: $experienceDistribution)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationsAnalyticsEntityImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(
              other._topProfessions,
              _topProfessions,
            ) &&
            const DeepCollectionEquality().equals(
              other._topLocations,
              _topLocations,
            ) &&
            const DeepCollectionEquality().equals(
              other._experienceDistribution,
              _experienceDistribution,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    summary,
    const DeepCollectionEquality().hash(_topProfessions),
    const DeepCollectionEquality().hash(_topLocations),
    const DeepCollectionEquality().hash(_experienceDistribution),
  );

  /// Create a copy of ConversationsAnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationsAnalyticsEntityImplCopyWith<
    _$ConversationsAnalyticsEntityImpl
  >
  get copyWith =>
      __$$ConversationsAnalyticsEntityImplCopyWithImpl<
        _$ConversationsAnalyticsEntityImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationsAnalyticsEntityImplToJson(this);
  }
}

abstract class _ConversationsAnalyticsEntity
    implements ConversationsAnalyticsEntity {
  const factory _ConversationsAnalyticsEntity({
    required final ConversationsSummaryEntity summary,
    required final List<TopProfessionEntity> topProfessions,
    required final List<TopLocationEntity> topLocations,
    required final List<ExperienceDistributionEntity> experienceDistribution,
  }) = _$ConversationsAnalyticsEntityImpl;

  factory _ConversationsAnalyticsEntity.fromJson(Map<String, dynamic> json) =
      _$ConversationsAnalyticsEntityImpl.fromJson;

  @override
  ConversationsSummaryEntity get summary;
  @override
  List<TopProfessionEntity> get topProfessions;
  @override
  List<TopLocationEntity> get topLocations;
  @override
  List<ExperienceDistributionEntity> get experienceDistribution;

  /// Create a copy of ConversationsAnalyticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationsAnalyticsEntityImplCopyWith<
    _$ConversationsAnalyticsEntityImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

ConversationsSummaryEntity _$ConversationsSummaryEntityFromJson(
  Map<String, dynamic> json,
) {
  return _ConversationsSummaryEntity.fromJson(json);
}

/// @nodoc
mixin _$ConversationsSummaryEntity {
  int get totalConversations => throw _privateConstructorUsedError;
  int get activeConversations => throw _privateConstructorUsedError;
  double get avgCompletion => throw _privateConstructorUsedError;
  MessageStatsEntity get messageStats => throw _privateConstructorUsedError;

  /// Serializes this ConversationsSummaryEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationsSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationsSummaryEntityCopyWith<ConversationsSummaryEntity>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationsSummaryEntityCopyWith<$Res> {
  factory $ConversationsSummaryEntityCopyWith(
    ConversationsSummaryEntity value,
    $Res Function(ConversationsSummaryEntity) then,
  ) =
      _$ConversationsSummaryEntityCopyWithImpl<
        $Res,
        ConversationsSummaryEntity
      >;
  @useResult
  $Res call({
    int totalConversations,
    int activeConversations,
    double avgCompletion,
    MessageStatsEntity messageStats,
  });

  $MessageStatsEntityCopyWith<$Res> get messageStats;
}

/// @nodoc
class _$ConversationsSummaryEntityCopyWithImpl<
  $Res,
  $Val extends ConversationsSummaryEntity
>
    implements $ConversationsSummaryEntityCopyWith<$Res> {
  _$ConversationsSummaryEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationsSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalConversations = null,
    Object? activeConversations = null,
    Object? avgCompletion = null,
    Object? messageStats = null,
  }) {
    return _then(
      _value.copyWith(
            totalConversations: null == totalConversations
                ? _value.totalConversations
                : totalConversations // ignore: cast_nullable_to_non_nullable
                      as int,
            activeConversations: null == activeConversations
                ? _value.activeConversations
                : activeConversations // ignore: cast_nullable_to_non_nullable
                      as int,
            avgCompletion: null == avgCompletion
                ? _value.avgCompletion
                : avgCompletion // ignore: cast_nullable_to_non_nullable
                      as double,
            messageStats: null == messageStats
                ? _value.messageStats
                : messageStats // ignore: cast_nullable_to_non_nullable
                      as MessageStatsEntity,
          )
          as $Val,
    );
  }

  /// Create a copy of ConversationsSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MessageStatsEntityCopyWith<$Res> get messageStats {
    return $MessageStatsEntityCopyWith<$Res>(_value.messageStats, (value) {
      return _then(_value.copyWith(messageStats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationsSummaryEntityImplCopyWith<$Res>
    implements $ConversationsSummaryEntityCopyWith<$Res> {
  factory _$$ConversationsSummaryEntityImplCopyWith(
    _$ConversationsSummaryEntityImpl value,
    $Res Function(_$ConversationsSummaryEntityImpl) then,
  ) = __$$ConversationsSummaryEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalConversations,
    int activeConversations,
    double avgCompletion,
    MessageStatsEntity messageStats,
  });

  @override
  $MessageStatsEntityCopyWith<$Res> get messageStats;
}

/// @nodoc
class __$$ConversationsSummaryEntityImplCopyWithImpl<$Res>
    extends
        _$ConversationsSummaryEntityCopyWithImpl<
          $Res,
          _$ConversationsSummaryEntityImpl
        >
    implements _$$ConversationsSummaryEntityImplCopyWith<$Res> {
  __$$ConversationsSummaryEntityImplCopyWithImpl(
    _$ConversationsSummaryEntityImpl _value,
    $Res Function(_$ConversationsSummaryEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConversationsSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalConversations = null,
    Object? activeConversations = null,
    Object? avgCompletion = null,
    Object? messageStats = null,
  }) {
    return _then(
      _$ConversationsSummaryEntityImpl(
        totalConversations: null == totalConversations
            ? _value.totalConversations
            : totalConversations // ignore: cast_nullable_to_non_nullable
                  as int,
        activeConversations: null == activeConversations
            ? _value.activeConversations
            : activeConversations // ignore: cast_nullable_to_non_nullable
                  as int,
        avgCompletion: null == avgCompletion
            ? _value.avgCompletion
            : avgCompletion // ignore: cast_nullable_to_non_nullable
                  as double,
        messageStats: null == messageStats
            ? _value.messageStats
            : messageStats // ignore: cast_nullable_to_non_nullable
                  as MessageStatsEntity,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationsSummaryEntityImpl implements _ConversationsSummaryEntity {
  const _$ConversationsSummaryEntityImpl({
    required this.totalConversations,
    required this.activeConversations,
    required this.avgCompletion,
    required this.messageStats,
  });

  factory _$ConversationsSummaryEntityImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$ConversationsSummaryEntityImplFromJson(json);

  @override
  final int totalConversations;
  @override
  final int activeConversations;
  @override
  final double avgCompletion;
  @override
  final MessageStatsEntity messageStats;

  @override
  String toString() {
    return 'ConversationsSummaryEntity(totalConversations: $totalConversations, activeConversations: $activeConversations, avgCompletion: $avgCompletion, messageStats: $messageStats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationsSummaryEntityImpl &&
            (identical(other.totalConversations, totalConversations) ||
                other.totalConversations == totalConversations) &&
            (identical(other.activeConversations, activeConversations) ||
                other.activeConversations == activeConversations) &&
            (identical(other.avgCompletion, avgCompletion) ||
                other.avgCompletion == avgCompletion) &&
            (identical(other.messageStats, messageStats) ||
                other.messageStats == messageStats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalConversations,
    activeConversations,
    avgCompletion,
    messageStats,
  );

  /// Create a copy of ConversationsSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationsSummaryEntityImplCopyWith<_$ConversationsSummaryEntityImpl>
  get copyWith =>
      __$$ConversationsSummaryEntityImplCopyWithImpl<
        _$ConversationsSummaryEntityImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationsSummaryEntityImplToJson(this);
  }
}

abstract class _ConversationsSummaryEntity
    implements ConversationsSummaryEntity {
  const factory _ConversationsSummaryEntity({
    required final int totalConversations,
    required final int activeConversations,
    required final double avgCompletion,
    required final MessageStatsEntity messageStats,
  }) = _$ConversationsSummaryEntityImpl;

  factory _ConversationsSummaryEntity.fromJson(Map<String, dynamic> json) =
      _$ConversationsSummaryEntityImpl.fromJson;

  @override
  int get totalConversations;
  @override
  int get activeConversations;
  @override
  double get avgCompletion;
  @override
  MessageStatsEntity get messageStats;

  /// Create a copy of ConversationsSummaryEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationsSummaryEntityImplCopyWith<_$ConversationsSummaryEntityImpl>
  get copyWith => throw _privateConstructorUsedError;
}

MessageStatsEntity _$MessageStatsEntityFromJson(Map<String, dynamic> json) {
  return _MessageStatsEntity.fromJson(json);
}

/// @nodoc
mixin _$MessageStatsEntity {
  int get total => throw _privateConstructorUsedError;
  int get aiGenerated => throw _privateConstructorUsedError;
  int get userGenerated => throw _privateConstructorUsedError;
  int get aiRatio => throw _privateConstructorUsedError;

  /// Serializes this MessageStatsEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageStatsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageStatsEntityCopyWith<MessageStatsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageStatsEntityCopyWith<$Res> {
  factory $MessageStatsEntityCopyWith(
    MessageStatsEntity value,
    $Res Function(MessageStatsEntity) then,
  ) = _$MessageStatsEntityCopyWithImpl<$Res, MessageStatsEntity>;
  @useResult
  $Res call({int total, int aiGenerated, int userGenerated, int aiRatio});
}

/// @nodoc
class _$MessageStatsEntityCopyWithImpl<$Res, $Val extends MessageStatsEntity>
    implements $MessageStatsEntityCopyWith<$Res> {
  _$MessageStatsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageStatsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? aiGenerated = null,
    Object? userGenerated = null,
    Object? aiRatio = null,
  }) {
    return _then(
      _value.copyWith(
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            aiGenerated: null == aiGenerated
                ? _value.aiGenerated
                : aiGenerated // ignore: cast_nullable_to_non_nullable
                      as int,
            userGenerated: null == userGenerated
                ? _value.userGenerated
                : userGenerated // ignore: cast_nullable_to_non_nullable
                      as int,
            aiRatio: null == aiRatio
                ? _value.aiRatio
                : aiRatio // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MessageStatsEntityImplCopyWith<$Res>
    implements $MessageStatsEntityCopyWith<$Res> {
  factory _$$MessageStatsEntityImplCopyWith(
    _$MessageStatsEntityImpl value,
    $Res Function(_$MessageStatsEntityImpl) then,
  ) = __$$MessageStatsEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int total, int aiGenerated, int userGenerated, int aiRatio});
}

/// @nodoc
class __$$MessageStatsEntityImplCopyWithImpl<$Res>
    extends _$MessageStatsEntityCopyWithImpl<$Res, _$MessageStatsEntityImpl>
    implements _$$MessageStatsEntityImplCopyWith<$Res> {
  __$$MessageStatsEntityImplCopyWithImpl(
    _$MessageStatsEntityImpl _value,
    $Res Function(_$MessageStatsEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MessageStatsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? aiGenerated = null,
    Object? userGenerated = null,
    Object? aiRatio = null,
  }) {
    return _then(
      _$MessageStatsEntityImpl(
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        aiGenerated: null == aiGenerated
            ? _value.aiGenerated
            : aiGenerated // ignore: cast_nullable_to_non_nullable
                  as int,
        userGenerated: null == userGenerated
            ? _value.userGenerated
            : userGenerated // ignore: cast_nullable_to_non_nullable
                  as int,
        aiRatio: null == aiRatio
            ? _value.aiRatio
            : aiRatio // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageStatsEntityImpl implements _MessageStatsEntity {
  const _$MessageStatsEntityImpl({
    required this.total,
    required this.aiGenerated,
    required this.userGenerated,
    required this.aiRatio,
  });

  factory _$MessageStatsEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageStatsEntityImplFromJson(json);

  @override
  final int total;
  @override
  final int aiGenerated;
  @override
  final int userGenerated;
  @override
  final int aiRatio;

  @override
  String toString() {
    return 'MessageStatsEntity(total: $total, aiGenerated: $aiGenerated, userGenerated: $userGenerated, aiRatio: $aiRatio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageStatsEntityImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.aiGenerated, aiGenerated) ||
                other.aiGenerated == aiGenerated) &&
            (identical(other.userGenerated, userGenerated) ||
                other.userGenerated == userGenerated) &&
            (identical(other.aiRatio, aiRatio) || other.aiRatio == aiRatio));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, total, aiGenerated, userGenerated, aiRatio);

  /// Create a copy of MessageStatsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageStatsEntityImplCopyWith<_$MessageStatsEntityImpl> get copyWith =>
      __$$MessageStatsEntityImplCopyWithImpl<_$MessageStatsEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageStatsEntityImplToJson(this);
  }
}

abstract class _MessageStatsEntity implements MessageStatsEntity {
  const factory _MessageStatsEntity({
    required final int total,
    required final int aiGenerated,
    required final int userGenerated,
    required final int aiRatio,
  }) = _$MessageStatsEntityImpl;

  factory _MessageStatsEntity.fromJson(Map<String, dynamic> json) =
      _$MessageStatsEntityImpl.fromJson;

  @override
  int get total;
  @override
  int get aiGenerated;
  @override
  int get userGenerated;
  @override
  int get aiRatio;

  /// Create a copy of MessageStatsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageStatsEntityImplCopyWith<_$MessageStatsEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopProfessionEntity _$TopProfessionEntityFromJson(Map<String, dynamic> json) {
  return _TopProfessionEntity.fromJson(json);
}

/// @nodoc
mixin _$TopProfessionEntity {
  String get profession => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this TopProfessionEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopProfessionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopProfessionEntityCopyWith<TopProfessionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopProfessionEntityCopyWith<$Res> {
  factory $TopProfessionEntityCopyWith(
    TopProfessionEntity value,
    $Res Function(TopProfessionEntity) then,
  ) = _$TopProfessionEntityCopyWithImpl<$Res, TopProfessionEntity>;
  @useResult
  $Res call({String profession, int count});
}

/// @nodoc
class _$TopProfessionEntityCopyWithImpl<$Res, $Val extends TopProfessionEntity>
    implements $TopProfessionEntityCopyWith<$Res> {
  _$TopProfessionEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopProfessionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profession = null, Object? count = null}) {
    return _then(
      _value.copyWith(
            profession: null == profession
                ? _value.profession
                : profession // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$TopProfessionEntityImplCopyWith<$Res>
    implements $TopProfessionEntityCopyWith<$Res> {
  factory _$$TopProfessionEntityImplCopyWith(
    _$TopProfessionEntityImpl value,
    $Res Function(_$TopProfessionEntityImpl) then,
  ) = __$$TopProfessionEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String profession, int count});
}

/// @nodoc
class __$$TopProfessionEntityImplCopyWithImpl<$Res>
    extends _$TopProfessionEntityCopyWithImpl<$Res, _$TopProfessionEntityImpl>
    implements _$$TopProfessionEntityImplCopyWith<$Res> {
  __$$TopProfessionEntityImplCopyWithImpl(
    _$TopProfessionEntityImpl _value,
    $Res Function(_$TopProfessionEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TopProfessionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? profession = null, Object? count = null}) {
    return _then(
      _$TopProfessionEntityImpl(
        profession: null == profession
            ? _value.profession
            : profession // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$TopProfessionEntityImpl implements _TopProfessionEntity {
  const _$TopProfessionEntityImpl({
    required this.profession,
    required this.count,
  });

  factory _$TopProfessionEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopProfessionEntityImplFromJson(json);

  @override
  final String profession;
  @override
  final int count;

  @override
  String toString() {
    return 'TopProfessionEntity(profession: $profession, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopProfessionEntityImpl &&
            (identical(other.profession, profession) ||
                other.profession == profession) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, profession, count);

  /// Create a copy of TopProfessionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopProfessionEntityImplCopyWith<_$TopProfessionEntityImpl> get copyWith =>
      __$$TopProfessionEntityImplCopyWithImpl<_$TopProfessionEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TopProfessionEntityImplToJson(this);
  }
}

abstract class _TopProfessionEntity implements TopProfessionEntity {
  const factory _TopProfessionEntity({
    required final String profession,
    required final int count,
  }) = _$TopProfessionEntityImpl;

  factory _TopProfessionEntity.fromJson(Map<String, dynamic> json) =
      _$TopProfessionEntityImpl.fromJson;

  @override
  String get profession;
  @override
  int get count;

  /// Create a copy of TopProfessionEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopProfessionEntityImplCopyWith<_$TopProfessionEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopLocationEntity _$TopLocationEntityFromJson(Map<String, dynamic> json) {
  return _TopLocationEntity.fromJson(json);
}

/// @nodoc
mixin _$TopLocationEntity {
  String get location => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this TopLocationEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopLocationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopLocationEntityCopyWith<TopLocationEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopLocationEntityCopyWith<$Res> {
  factory $TopLocationEntityCopyWith(
    TopLocationEntity value,
    $Res Function(TopLocationEntity) then,
  ) = _$TopLocationEntityCopyWithImpl<$Res, TopLocationEntity>;
  @useResult
  $Res call({String location, int count});
}

/// @nodoc
class _$TopLocationEntityCopyWithImpl<$Res, $Val extends TopLocationEntity>
    implements $TopLocationEntityCopyWith<$Res> {
  _$TopLocationEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopLocationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? location = null, Object? count = null}) {
    return _then(
      _value.copyWith(
            location: null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$TopLocationEntityImplCopyWith<$Res>
    implements $TopLocationEntityCopyWith<$Res> {
  factory _$$TopLocationEntityImplCopyWith(
    _$TopLocationEntityImpl value,
    $Res Function(_$TopLocationEntityImpl) then,
  ) = __$$TopLocationEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String location, int count});
}

/// @nodoc
class __$$TopLocationEntityImplCopyWithImpl<$Res>
    extends _$TopLocationEntityCopyWithImpl<$Res, _$TopLocationEntityImpl>
    implements _$$TopLocationEntityImplCopyWith<$Res> {
  __$$TopLocationEntityImplCopyWithImpl(
    _$TopLocationEntityImpl _value,
    $Res Function(_$TopLocationEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TopLocationEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? location = null, Object? count = null}) {
    return _then(
      _$TopLocationEntityImpl(
        location: null == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$TopLocationEntityImpl implements _TopLocationEntity {
  const _$TopLocationEntityImpl({required this.location, required this.count});

  factory _$TopLocationEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopLocationEntityImplFromJson(json);

  @override
  final String location;
  @override
  final int count;

  @override
  String toString() {
    return 'TopLocationEntity(location: $location, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopLocationEntityImpl &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, location, count);

  /// Create a copy of TopLocationEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopLocationEntityImplCopyWith<_$TopLocationEntityImpl> get copyWith =>
      __$$TopLocationEntityImplCopyWithImpl<_$TopLocationEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TopLocationEntityImplToJson(this);
  }
}

abstract class _TopLocationEntity implements TopLocationEntity {
  const factory _TopLocationEntity({
    required final String location,
    required final int count,
  }) = _$TopLocationEntityImpl;

  factory _TopLocationEntity.fromJson(Map<String, dynamic> json) =
      _$TopLocationEntityImpl.fromJson;

  @override
  String get location;
  @override
  int get count;

  /// Create a copy of TopLocationEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopLocationEntityImplCopyWith<_$TopLocationEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExperienceDistributionEntity _$ExperienceDistributionEntityFromJson(
  Map<String, dynamic> json,
) {
  return _ExperienceDistributionEntity.fromJson(json);
}

/// @nodoc
mixin _$ExperienceDistributionEntity {
  String get level => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  /// Serializes this ExperienceDistributionEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExperienceDistributionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExperienceDistributionEntityCopyWith<ExperienceDistributionEntity>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExperienceDistributionEntityCopyWith<$Res> {
  factory $ExperienceDistributionEntityCopyWith(
    ExperienceDistributionEntity value,
    $Res Function(ExperienceDistributionEntity) then,
  ) =
      _$ExperienceDistributionEntityCopyWithImpl<
        $Res,
        ExperienceDistributionEntity
      >;
  @useResult
  $Res call({String level, int count});
}

/// @nodoc
class _$ExperienceDistributionEntityCopyWithImpl<
  $Res,
  $Val extends ExperienceDistributionEntity
>
    implements $ExperienceDistributionEntityCopyWith<$Res> {
  _$ExperienceDistributionEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExperienceDistributionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? level = null, Object? count = null}) {
    return _then(
      _value.copyWith(
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$ExperienceDistributionEntityImplCopyWith<$Res>
    implements $ExperienceDistributionEntityCopyWith<$Res> {
  factory _$$ExperienceDistributionEntityImplCopyWith(
    _$ExperienceDistributionEntityImpl value,
    $Res Function(_$ExperienceDistributionEntityImpl) then,
  ) = __$$ExperienceDistributionEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String level, int count});
}

/// @nodoc
class __$$ExperienceDistributionEntityImplCopyWithImpl<$Res>
    extends
        _$ExperienceDistributionEntityCopyWithImpl<
          $Res,
          _$ExperienceDistributionEntityImpl
        >
    implements _$$ExperienceDistributionEntityImplCopyWith<$Res> {
  __$$ExperienceDistributionEntityImplCopyWithImpl(
    _$ExperienceDistributionEntityImpl _value,
    $Res Function(_$ExperienceDistributionEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExperienceDistributionEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? level = null, Object? count = null}) {
    return _then(
      _$ExperienceDistributionEntityImpl(
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$ExperienceDistributionEntityImpl
    implements _ExperienceDistributionEntity {
  const _$ExperienceDistributionEntityImpl({
    required this.level,
    required this.count,
  });

  factory _$ExperienceDistributionEntityImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$ExperienceDistributionEntityImplFromJson(json);

  @override
  final String level;
  @override
  final int count;

  @override
  String toString() {
    return 'ExperienceDistributionEntity(level: $level, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExperienceDistributionEntityImpl &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, level, count);

  /// Create a copy of ExperienceDistributionEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExperienceDistributionEntityImplCopyWith<
    _$ExperienceDistributionEntityImpl
  >
  get copyWith =>
      __$$ExperienceDistributionEntityImplCopyWithImpl<
        _$ExperienceDistributionEntityImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExperienceDistributionEntityImplToJson(this);
  }
}

abstract class _ExperienceDistributionEntity
    implements ExperienceDistributionEntity {
  const factory _ExperienceDistributionEntity({
    required final String level,
    required final int count,
  }) = _$ExperienceDistributionEntityImpl;

  factory _ExperienceDistributionEntity.fromJson(Map<String, dynamic> json) =
      _$ExperienceDistributionEntityImpl.fromJson;

  @override
  String get level;
  @override
  int get count;

  /// Create a copy of ExperienceDistributionEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExperienceDistributionEntityImplCopyWith<
    _$ExperienceDistributionEntityImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

AIInsightsEntity _$AIInsightsEntityFromJson(Map<String, dynamic> json) {
  return _AIInsightsEntity.fromJson(json);
}

/// @nodoc
mixin _$AIInsightsEntity {
  MarketTrendsEntity get marketTrends => throw _privateConstructorUsedError;
  UserBehaviorEntity get userBehavior => throw _privateConstructorUsedError;
  List<String> get recommendations => throw _privateConstructorUsedError;
  List<String> get insights => throw _privateConstructorUsedError;

  /// Serializes this AIInsightsEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIInsightsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIInsightsEntityCopyWith<AIInsightsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIInsightsEntityCopyWith<$Res> {
  factory $AIInsightsEntityCopyWith(
    AIInsightsEntity value,
    $Res Function(AIInsightsEntity) then,
  ) = _$AIInsightsEntityCopyWithImpl<$Res, AIInsightsEntity>;
  @useResult
  $Res call({
    MarketTrendsEntity marketTrends,
    UserBehaviorEntity userBehavior,
    List<String> recommendations,
    List<String> insights,
  });

  $MarketTrendsEntityCopyWith<$Res> get marketTrends;
  $UserBehaviorEntityCopyWith<$Res> get userBehavior;
}

/// @nodoc
class _$AIInsightsEntityCopyWithImpl<$Res, $Val extends AIInsightsEntity>
    implements $AIInsightsEntityCopyWith<$Res> {
  _$AIInsightsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIInsightsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? marketTrends = null,
    Object? userBehavior = null,
    Object? recommendations = null,
    Object? insights = null,
  }) {
    return _then(
      _value.copyWith(
            marketTrends: null == marketTrends
                ? _value.marketTrends
                : marketTrends // ignore: cast_nullable_to_non_nullable
                      as MarketTrendsEntity,
            userBehavior: null == userBehavior
                ? _value.userBehavior
                : userBehavior // ignore: cast_nullable_to_non_nullable
                      as UserBehaviorEntity,
            recommendations: null == recommendations
                ? _value.recommendations
                : recommendations // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            insights: null == insights
                ? _value.insights
                : insights // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }

  /// Create a copy of AIInsightsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MarketTrendsEntityCopyWith<$Res> get marketTrends {
    return $MarketTrendsEntityCopyWith<$Res>(_value.marketTrends, (value) {
      return _then(_value.copyWith(marketTrends: value) as $Val);
    });
  }

  /// Create a copy of AIInsightsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserBehaviorEntityCopyWith<$Res> get userBehavior {
    return $UserBehaviorEntityCopyWith<$Res>(_value.userBehavior, (value) {
      return _then(_value.copyWith(userBehavior: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AIInsightsEntityImplCopyWith<$Res>
    implements $AIInsightsEntityCopyWith<$Res> {
  factory _$$AIInsightsEntityImplCopyWith(
    _$AIInsightsEntityImpl value,
    $Res Function(_$AIInsightsEntityImpl) then,
  ) = __$$AIInsightsEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    MarketTrendsEntity marketTrends,
    UserBehaviorEntity userBehavior,
    List<String> recommendations,
    List<String> insights,
  });

  @override
  $MarketTrendsEntityCopyWith<$Res> get marketTrends;
  @override
  $UserBehaviorEntityCopyWith<$Res> get userBehavior;
}

/// @nodoc
class __$$AIInsightsEntityImplCopyWithImpl<$Res>
    extends _$AIInsightsEntityCopyWithImpl<$Res, _$AIInsightsEntityImpl>
    implements _$$AIInsightsEntityImplCopyWith<$Res> {
  __$$AIInsightsEntityImplCopyWithImpl(
    _$AIInsightsEntityImpl _value,
    $Res Function(_$AIInsightsEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AIInsightsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? marketTrends = null,
    Object? userBehavior = null,
    Object? recommendations = null,
    Object? insights = null,
  }) {
    return _then(
      _$AIInsightsEntityImpl(
        marketTrends: null == marketTrends
            ? _value.marketTrends
            : marketTrends // ignore: cast_nullable_to_non_nullable
                  as MarketTrendsEntity,
        userBehavior: null == userBehavior
            ? _value.userBehavior
            : userBehavior // ignore: cast_nullable_to_non_nullable
                  as UserBehaviorEntity,
        recommendations: null == recommendations
            ? _value._recommendations
            : recommendations // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        insights: null == insights
            ? _value._insights
            : insights // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AIInsightsEntityImpl implements _AIInsightsEntity {
  const _$AIInsightsEntityImpl({
    required this.marketTrends,
    required this.userBehavior,
    required final List<String> recommendations,
    required final List<String> insights,
  }) : _recommendations = recommendations,
       _insights = insights;

  factory _$AIInsightsEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIInsightsEntityImplFromJson(json);

  @override
  final MarketTrendsEntity marketTrends;
  @override
  final UserBehaviorEntity userBehavior;
  final List<String> _recommendations;
  @override
  List<String> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  final List<String> _insights;
  @override
  List<String> get insights {
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_insights);
  }

  @override
  String toString() {
    return 'AIInsightsEntity(marketTrends: $marketTrends, userBehavior: $userBehavior, recommendations: $recommendations, insights: $insights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIInsightsEntityImpl &&
            (identical(other.marketTrends, marketTrends) ||
                other.marketTrends == marketTrends) &&
            (identical(other.userBehavior, userBehavior) ||
                other.userBehavior == userBehavior) &&
            const DeepCollectionEquality().equals(
              other._recommendations,
              _recommendations,
            ) &&
            const DeepCollectionEquality().equals(other._insights, _insights));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    marketTrends,
    userBehavior,
    const DeepCollectionEquality().hash(_recommendations),
    const DeepCollectionEquality().hash(_insights),
  );

  /// Create a copy of AIInsightsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIInsightsEntityImplCopyWith<_$AIInsightsEntityImpl> get copyWith =>
      __$$AIInsightsEntityImplCopyWithImpl<_$AIInsightsEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AIInsightsEntityImplToJson(this);
  }
}

abstract class _AIInsightsEntity implements AIInsightsEntity {
  const factory _AIInsightsEntity({
    required final MarketTrendsEntity marketTrends,
    required final UserBehaviorEntity userBehavior,
    required final List<String> recommendations,
    required final List<String> insights,
  }) = _$AIInsightsEntityImpl;

  factory _AIInsightsEntity.fromJson(Map<String, dynamic> json) =
      _$AIInsightsEntityImpl.fromJson;

  @override
  MarketTrendsEntity get marketTrends;
  @override
  UserBehaviorEntity get userBehavior;
  @override
  List<String> get recommendations;
  @override
  List<String> get insights;

  /// Create a copy of AIInsightsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIInsightsEntityImplCopyWith<_$AIInsightsEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MarketTrendsEntity _$MarketTrendsEntityFromJson(Map<String, dynamic> json) {
  return _MarketTrendsEntity.fromJson(json);
}

/// @nodoc
mixin _$MarketTrendsEntity {
  List<String> get hotSectors => throw _privateConstructorUsedError;
  String get demandPatterns => throw _privateConstructorUsedError;
  String get growthOpportunities => throw _privateConstructorUsedError;

  /// Serializes this MarketTrendsEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MarketTrendsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MarketTrendsEntityCopyWith<MarketTrendsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketTrendsEntityCopyWith<$Res> {
  factory $MarketTrendsEntityCopyWith(
    MarketTrendsEntity value,
    $Res Function(MarketTrendsEntity) then,
  ) = _$MarketTrendsEntityCopyWithImpl<$Res, MarketTrendsEntity>;
  @useResult
  $Res call({
    List<String> hotSectors,
    String demandPatterns,
    String growthOpportunities,
  });
}

/// @nodoc
class _$MarketTrendsEntityCopyWithImpl<$Res, $Val extends MarketTrendsEntity>
    implements $MarketTrendsEntityCopyWith<$Res> {
  _$MarketTrendsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MarketTrendsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hotSectors = null,
    Object? demandPatterns = null,
    Object? growthOpportunities = null,
  }) {
    return _then(
      _value.copyWith(
            hotSectors: null == hotSectors
                ? _value.hotSectors
                : hotSectors // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            demandPatterns: null == demandPatterns
                ? _value.demandPatterns
                : demandPatterns // ignore: cast_nullable_to_non_nullable
                      as String,
            growthOpportunities: null == growthOpportunities
                ? _value.growthOpportunities
                : growthOpportunities // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MarketTrendsEntityImplCopyWith<$Res>
    implements $MarketTrendsEntityCopyWith<$Res> {
  factory _$$MarketTrendsEntityImplCopyWith(
    _$MarketTrendsEntityImpl value,
    $Res Function(_$MarketTrendsEntityImpl) then,
  ) = __$$MarketTrendsEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<String> hotSectors,
    String demandPatterns,
    String growthOpportunities,
  });
}

/// @nodoc
class __$$MarketTrendsEntityImplCopyWithImpl<$Res>
    extends _$MarketTrendsEntityCopyWithImpl<$Res, _$MarketTrendsEntityImpl>
    implements _$$MarketTrendsEntityImplCopyWith<$Res> {
  __$$MarketTrendsEntityImplCopyWithImpl(
    _$MarketTrendsEntityImpl _value,
    $Res Function(_$MarketTrendsEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MarketTrendsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hotSectors = null,
    Object? demandPatterns = null,
    Object? growthOpportunities = null,
  }) {
    return _then(
      _$MarketTrendsEntityImpl(
        hotSectors: null == hotSectors
            ? _value._hotSectors
            : hotSectors // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        demandPatterns: null == demandPatterns
            ? _value.demandPatterns
            : demandPatterns // ignore: cast_nullable_to_non_nullable
                  as String,
        growthOpportunities: null == growthOpportunities
            ? _value.growthOpportunities
            : growthOpportunities // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketTrendsEntityImpl implements _MarketTrendsEntity {
  const _$MarketTrendsEntityImpl({
    required final List<String> hotSectors,
    required this.demandPatterns,
    required this.growthOpportunities,
  }) : _hotSectors = hotSectors;

  factory _$MarketTrendsEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketTrendsEntityImplFromJson(json);

  final List<String> _hotSectors;
  @override
  List<String> get hotSectors {
    if (_hotSectors is EqualUnmodifiableListView) return _hotSectors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hotSectors);
  }

  @override
  final String demandPatterns;
  @override
  final String growthOpportunities;

  @override
  String toString() {
    return 'MarketTrendsEntity(hotSectors: $hotSectors, demandPatterns: $demandPatterns, growthOpportunities: $growthOpportunities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketTrendsEntityImpl &&
            const DeepCollectionEquality().equals(
              other._hotSectors,
              _hotSectors,
            ) &&
            (identical(other.demandPatterns, demandPatterns) ||
                other.demandPatterns == demandPatterns) &&
            (identical(other.growthOpportunities, growthOpportunities) ||
                other.growthOpportunities == growthOpportunities));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_hotSectors),
    demandPatterns,
    growthOpportunities,
  );

  /// Create a copy of MarketTrendsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketTrendsEntityImplCopyWith<_$MarketTrendsEntityImpl> get copyWith =>
      __$$MarketTrendsEntityImplCopyWithImpl<_$MarketTrendsEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketTrendsEntityImplToJson(this);
  }
}

abstract class _MarketTrendsEntity implements MarketTrendsEntity {
  const factory _MarketTrendsEntity({
    required final List<String> hotSectors,
    required final String demandPatterns,
    required final String growthOpportunities,
  }) = _$MarketTrendsEntityImpl;

  factory _MarketTrendsEntity.fromJson(Map<String, dynamic> json) =
      _$MarketTrendsEntityImpl.fromJson;

  @override
  List<String> get hotSectors;
  @override
  String get demandPatterns;
  @override
  String get growthOpportunities;

  /// Create a copy of MarketTrendsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MarketTrendsEntityImplCopyWith<_$MarketTrendsEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserBehaviorEntity _$UserBehaviorEntityFromJson(Map<String, dynamic> json) {
  return _UserBehaviorEntity.fromJson(json);
}

/// @nodoc
mixin _$UserBehaviorEntity {
  String get engagementLevel => throw _privateConstructorUsedError;
  String get profileCompletion => throw _privateConstructorUsedError;
  String get interactionPatterns => throw _privateConstructorUsedError;

  /// Serializes this UserBehaviorEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserBehaviorEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserBehaviorEntityCopyWith<UserBehaviorEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserBehaviorEntityCopyWith<$Res> {
  factory $UserBehaviorEntityCopyWith(
    UserBehaviorEntity value,
    $Res Function(UserBehaviorEntity) then,
  ) = _$UserBehaviorEntityCopyWithImpl<$Res, UserBehaviorEntity>;
  @useResult
  $Res call({
    String engagementLevel,
    String profileCompletion,
    String interactionPatterns,
  });
}

/// @nodoc
class _$UserBehaviorEntityCopyWithImpl<$Res, $Val extends UserBehaviorEntity>
    implements $UserBehaviorEntityCopyWith<$Res> {
  _$UserBehaviorEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserBehaviorEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? engagementLevel = null,
    Object? profileCompletion = null,
    Object? interactionPatterns = null,
  }) {
    return _then(
      _value.copyWith(
            engagementLevel: null == engagementLevel
                ? _value.engagementLevel
                : engagementLevel // ignore: cast_nullable_to_non_nullable
                      as String,
            profileCompletion: null == profileCompletion
                ? _value.profileCompletion
                : profileCompletion // ignore: cast_nullable_to_non_nullable
                      as String,
            interactionPatterns: null == interactionPatterns
                ? _value.interactionPatterns
                : interactionPatterns // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserBehaviorEntityImplCopyWith<$Res>
    implements $UserBehaviorEntityCopyWith<$Res> {
  factory _$$UserBehaviorEntityImplCopyWith(
    _$UserBehaviorEntityImpl value,
    $Res Function(_$UserBehaviorEntityImpl) then,
  ) = __$$UserBehaviorEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String engagementLevel,
    String profileCompletion,
    String interactionPatterns,
  });
}

/// @nodoc
class __$$UserBehaviorEntityImplCopyWithImpl<$Res>
    extends _$UserBehaviorEntityCopyWithImpl<$Res, _$UserBehaviorEntityImpl>
    implements _$$UserBehaviorEntityImplCopyWith<$Res> {
  __$$UserBehaviorEntityImplCopyWithImpl(
    _$UserBehaviorEntityImpl _value,
    $Res Function(_$UserBehaviorEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserBehaviorEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? engagementLevel = null,
    Object? profileCompletion = null,
    Object? interactionPatterns = null,
  }) {
    return _then(
      _$UserBehaviorEntityImpl(
        engagementLevel: null == engagementLevel
            ? _value.engagementLevel
            : engagementLevel // ignore: cast_nullable_to_non_nullable
                  as String,
        profileCompletion: null == profileCompletion
            ? _value.profileCompletion
            : profileCompletion // ignore: cast_nullable_to_non_nullable
                  as String,
        interactionPatterns: null == interactionPatterns
            ? _value.interactionPatterns
            : interactionPatterns // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserBehaviorEntityImpl implements _UserBehaviorEntity {
  const _$UserBehaviorEntityImpl({
    required this.engagementLevel,
    required this.profileCompletion,
    required this.interactionPatterns,
  });

  factory _$UserBehaviorEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserBehaviorEntityImplFromJson(json);

  @override
  final String engagementLevel;
  @override
  final String profileCompletion;
  @override
  final String interactionPatterns;

  @override
  String toString() {
    return 'UserBehaviorEntity(engagementLevel: $engagementLevel, profileCompletion: $profileCompletion, interactionPatterns: $interactionPatterns)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserBehaviorEntityImpl &&
            (identical(other.engagementLevel, engagementLevel) ||
                other.engagementLevel == engagementLevel) &&
            (identical(other.profileCompletion, profileCompletion) ||
                other.profileCompletion == profileCompletion) &&
            (identical(other.interactionPatterns, interactionPatterns) ||
                other.interactionPatterns == interactionPatterns));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    engagementLevel,
    profileCompletion,
    interactionPatterns,
  );

  /// Create a copy of UserBehaviorEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserBehaviorEntityImplCopyWith<_$UserBehaviorEntityImpl> get copyWith =>
      __$$UserBehaviorEntityImplCopyWithImpl<_$UserBehaviorEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserBehaviorEntityImplToJson(this);
  }
}

abstract class _UserBehaviorEntity implements UserBehaviorEntity {
  const factory _UserBehaviorEntity({
    required final String engagementLevel,
    required final String profileCompletion,
    required final String interactionPatterns,
  }) = _$UserBehaviorEntityImpl;

  factory _UserBehaviorEntity.fromJson(Map<String, dynamic> json) =
      _$UserBehaviorEntityImpl.fromJson;

  @override
  String get engagementLevel;
  @override
  String get profileCompletion;
  @override
  String get interactionPatterns;

  /// Create a copy of UserBehaviorEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserBehaviorEntityImplCopyWith<_$UserBehaviorEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnalyticsResponse _$AnalyticsResponseFromJson(Map<String, dynamic> json) {
  return _AnalyticsResponse.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsResponse {
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  AnalyticsEntity get analytics => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsResponseCopyWith<AnalyticsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsResponseCopyWith<$Res> {
  factory $AnalyticsResponseCopyWith(
    AnalyticsResponse value,
    $Res Function(AnalyticsResponse) then,
  ) = _$AnalyticsResponseCopyWithImpl<$Res, AnalyticsResponse>;
  @useResult
  $Res call({bool success, String message, AnalyticsEntity analytics});

  $AnalyticsEntityCopyWith<$Res> get analytics;
}

/// @nodoc
class _$AnalyticsResponseCopyWithImpl<$Res, $Val extends AnalyticsResponse>
    implements $AnalyticsResponseCopyWith<$Res> {
  _$AnalyticsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? analytics = null,
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
            analytics: null == analytics
                ? _value.analytics
                : analytics // ignore: cast_nullable_to_non_nullable
                      as AnalyticsEntity,
          )
          as $Val,
    );
  }

  /// Create a copy of AnalyticsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnalyticsEntityCopyWith<$Res> get analytics {
    return $AnalyticsEntityCopyWith<$Res>(_value.analytics, (value) {
      return _then(_value.copyWith(analytics: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnalyticsResponseImplCopyWith<$Res>
    implements $AnalyticsResponseCopyWith<$Res> {
  factory _$$AnalyticsResponseImplCopyWith(
    _$AnalyticsResponseImpl value,
    $Res Function(_$AnalyticsResponseImpl) then,
  ) = __$$AnalyticsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String message, AnalyticsEntity analytics});

  @override
  $AnalyticsEntityCopyWith<$Res> get analytics;
}

/// @nodoc
class __$$AnalyticsResponseImplCopyWithImpl<$Res>
    extends _$AnalyticsResponseCopyWithImpl<$Res, _$AnalyticsResponseImpl>
    implements _$$AnalyticsResponseImplCopyWith<$Res> {
  __$$AnalyticsResponseImplCopyWithImpl(
    _$AnalyticsResponseImpl _value,
    $Res Function(_$AnalyticsResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalyticsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? analytics = null,
  }) {
    return _then(
      _$AnalyticsResponseImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        analytics: null == analytics
            ? _value.analytics
            : analytics // ignore: cast_nullable_to_non_nullable
                  as AnalyticsEntity,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsResponseImpl implements _AnalyticsResponse {
  const _$AnalyticsResponseImpl({
    required this.success,
    required this.message,
    required this.analytics,
  });

  factory _$AnalyticsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String message;
  @override
  final AnalyticsEntity analytics;

  @override
  String toString() {
    return 'AnalyticsResponse(success: $success, message: $message, analytics: $analytics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.analytics, analytics) ||
                other.analytics == analytics));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, message, analytics);

  /// Create a copy of AnalyticsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsResponseImplCopyWith<_$AnalyticsResponseImpl> get copyWith =>
      __$$AnalyticsResponseImplCopyWithImpl<_$AnalyticsResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsResponseImplToJson(this);
  }
}

abstract class _AnalyticsResponse implements AnalyticsResponse {
  const factory _AnalyticsResponse({
    required final bool success,
    required final String message,
    required final AnalyticsEntity analytics,
  }) = _$AnalyticsResponseImpl;

  factory _AnalyticsResponse.fromJson(Map<String, dynamic> json) =
      _$AnalyticsResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String get message;
  @override
  AnalyticsEntity get analytics;

  /// Create a copy of AnalyticsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsResponseImplCopyWith<_$AnalyticsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

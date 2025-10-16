// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'instagram_posts_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$InstagramPostsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<InstagramPostEntity> posts,
      InstagramPagination pagination,
    )
    loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<InstagramPostEntity> posts,
      InstagramPagination pagination,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<InstagramPostEntity> posts,
      InstagramPagination pagination,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstagramPostsStateCopyWith<$Res> {
  factory $InstagramPostsStateCopyWith(
    InstagramPostsState value,
    $Res Function(InstagramPostsState) then,
  ) = _$InstagramPostsStateCopyWithImpl<$Res, InstagramPostsState>;
}

/// @nodoc
class _$InstagramPostsStateCopyWithImpl<$Res, $Val extends InstagramPostsState>
    implements $InstagramPostsStateCopyWith<$Res> {
  _$InstagramPostsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InstagramPostsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
    _$InitialImpl value,
    $Res Function(_$InitialImpl) then,
  ) = __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$InstagramPostsStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InstagramPostsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'InstagramPostsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<InstagramPostEntity> posts,
      InstagramPagination pagination,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<InstagramPostEntity> posts,
      InstagramPagination pagination,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<InstagramPostEntity> posts,
      InstagramPagination pagination,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements InstagramPostsState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
    _$LoadingImpl value,
    $Res Function(_$LoadingImpl) then,
  ) = __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$InstagramPostsStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
    _$LoadingImpl _value,
    $Res Function(_$LoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InstagramPostsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'InstagramPostsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<InstagramPostEntity> posts,
      InstagramPagination pagination,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<InstagramPostEntity> posts,
      InstagramPagination pagination,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<InstagramPostEntity> posts,
      InstagramPagination pagination,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements InstagramPostsState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$LoadedImplCopyWith<$Res> {
  factory _$$LoadedImplCopyWith(
    _$LoadedImpl value,
    $Res Function(_$LoadedImpl) then,
  ) = __$$LoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<InstagramPostEntity> posts, InstagramPagination pagination});

  $InstagramPaginationCopyWith<$Res> get pagination;
}

/// @nodoc
class __$$LoadedImplCopyWithImpl<$Res>
    extends _$InstagramPostsStateCopyWithImpl<$Res, _$LoadedImpl>
    implements _$$LoadedImplCopyWith<$Res> {
  __$$LoadedImplCopyWithImpl(
    _$LoadedImpl _value,
    $Res Function(_$LoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InstagramPostsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? posts = null, Object? pagination = null}) {
    return _then(
      _$LoadedImpl(
        posts: null == posts
            ? _value._posts
            : posts // ignore: cast_nullable_to_non_nullable
                  as List<InstagramPostEntity>,
        pagination: null == pagination
            ? _value.pagination
            : pagination // ignore: cast_nullable_to_non_nullable
                  as InstagramPagination,
      ),
    );
  }

  /// Create a copy of InstagramPostsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InstagramPaginationCopyWith<$Res> get pagination {
    return $InstagramPaginationCopyWith<$Res>(_value.pagination, (value) {
      return _then(_value.copyWith(pagination: value));
    });
  }
}

/// @nodoc

class _$LoadedImpl implements _Loaded {
  const _$LoadedImpl({
    required final List<InstagramPostEntity> posts,
    required this.pagination,
  }) : _posts = posts;

  final List<InstagramPostEntity> _posts;
  @override
  List<InstagramPostEntity> get posts {
    if (_posts is EqualUnmodifiableListView) return _posts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_posts);
  }

  @override
  final InstagramPagination pagination;

  @override
  String toString() {
    return 'InstagramPostsState.loaded(posts: $posts, pagination: $pagination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedImpl &&
            const DeepCollectionEquality().equals(other._posts, _posts) &&
            (identical(other.pagination, pagination) ||
                other.pagination == pagination));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_posts),
    pagination,
  );

  /// Create a copy of InstagramPostsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      __$$LoadedImplCopyWithImpl<_$LoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<InstagramPostEntity> posts,
      InstagramPagination pagination,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(posts, pagination);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<InstagramPostEntity> posts,
      InstagramPagination pagination,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(posts, pagination);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<InstagramPostEntity> posts,
      InstagramPagination pagination,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(posts, pagination);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _Loaded implements InstagramPostsState {
  const factory _Loaded({
    required final List<InstagramPostEntity> posts,
    required final InstagramPagination pagination,
  }) = _$LoadedImpl;

  List<InstagramPostEntity> get posts;
  InstagramPagination get pagination;

  /// Create a copy of InstagramPostsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
    _$ErrorImpl value,
    $Res Function(_$ErrorImpl) then,
  ) = __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$InstagramPostsStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
    _$ErrorImpl _value,
    $Res Function(_$ErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InstagramPostsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'InstagramPostsState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of InstagramPostsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<InstagramPostEntity> posts,
      InstagramPagination pagination,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<InstagramPostEntity> posts,
      InstagramPagination pagination,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<InstagramPostEntity> posts,
      InstagramPagination pagination,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements InstagramPostsState {
  const factory _Error({required final String message}) = _$ErrorImpl;

  String get message;

  /// Create a copy of InstagramPostsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$InstagramCommentsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<InstagramCommentEntity> comments, int count)
    loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<InstagramCommentEntity> comments, int count)? loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<InstagramCommentEntity> comments, int count)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_CommentsInitial value) initial,
    required TResult Function(_CommentsLoading value) loading,
    required TResult Function(_CommentsLoaded value) loaded,
    required TResult Function(_CommentsError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_CommentsInitial value)? initial,
    TResult? Function(_CommentsLoading value)? loading,
    TResult? Function(_CommentsLoaded value)? loaded,
    TResult? Function(_CommentsError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_CommentsInitial value)? initial,
    TResult Function(_CommentsLoading value)? loading,
    TResult Function(_CommentsLoaded value)? loaded,
    TResult Function(_CommentsError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstagramCommentsStateCopyWith<$Res> {
  factory $InstagramCommentsStateCopyWith(
    InstagramCommentsState value,
    $Res Function(InstagramCommentsState) then,
  ) = _$InstagramCommentsStateCopyWithImpl<$Res, InstagramCommentsState>;
}

/// @nodoc
class _$InstagramCommentsStateCopyWithImpl<
  $Res,
  $Val extends InstagramCommentsState
>
    implements $InstagramCommentsStateCopyWith<$Res> {
  _$InstagramCommentsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InstagramCommentsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CommentsInitialImplCopyWith<$Res> {
  factory _$$CommentsInitialImplCopyWith(
    _$CommentsInitialImpl value,
    $Res Function(_$CommentsInitialImpl) then,
  ) = __$$CommentsInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CommentsInitialImplCopyWithImpl<$Res>
    extends _$InstagramCommentsStateCopyWithImpl<$Res, _$CommentsInitialImpl>
    implements _$$CommentsInitialImplCopyWith<$Res> {
  __$$CommentsInitialImplCopyWithImpl(
    _$CommentsInitialImpl _value,
    $Res Function(_$CommentsInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InstagramCommentsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CommentsInitialImpl implements _CommentsInitial {
  const _$CommentsInitialImpl();

  @override
  String toString() {
    return 'InstagramCommentsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CommentsInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<InstagramCommentEntity> comments, int count)
    loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<InstagramCommentEntity> comments, int count)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<InstagramCommentEntity> comments, int count)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_CommentsInitial value) initial,
    required TResult Function(_CommentsLoading value) loading,
    required TResult Function(_CommentsLoaded value) loaded,
    required TResult Function(_CommentsError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_CommentsInitial value)? initial,
    TResult? Function(_CommentsLoading value)? loading,
    TResult? Function(_CommentsLoaded value)? loaded,
    TResult? Function(_CommentsError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_CommentsInitial value)? initial,
    TResult Function(_CommentsLoading value)? loading,
    TResult Function(_CommentsLoaded value)? loaded,
    TResult Function(_CommentsError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _CommentsInitial implements InstagramCommentsState {
  const factory _CommentsInitial() = _$CommentsInitialImpl;
}

/// @nodoc
abstract class _$$CommentsLoadingImplCopyWith<$Res> {
  factory _$$CommentsLoadingImplCopyWith(
    _$CommentsLoadingImpl value,
    $Res Function(_$CommentsLoadingImpl) then,
  ) = __$$CommentsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CommentsLoadingImplCopyWithImpl<$Res>
    extends _$InstagramCommentsStateCopyWithImpl<$Res, _$CommentsLoadingImpl>
    implements _$$CommentsLoadingImplCopyWith<$Res> {
  __$$CommentsLoadingImplCopyWithImpl(
    _$CommentsLoadingImpl _value,
    $Res Function(_$CommentsLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InstagramCommentsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CommentsLoadingImpl implements _CommentsLoading {
  const _$CommentsLoadingImpl();

  @override
  String toString() {
    return 'InstagramCommentsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CommentsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<InstagramCommentEntity> comments, int count)
    loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<InstagramCommentEntity> comments, int count)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<InstagramCommentEntity> comments, int count)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_CommentsInitial value) initial,
    required TResult Function(_CommentsLoading value) loading,
    required TResult Function(_CommentsLoaded value) loaded,
    required TResult Function(_CommentsError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_CommentsInitial value)? initial,
    TResult? Function(_CommentsLoading value)? loading,
    TResult? Function(_CommentsLoaded value)? loaded,
    TResult? Function(_CommentsError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_CommentsInitial value)? initial,
    TResult Function(_CommentsLoading value)? loading,
    TResult Function(_CommentsLoaded value)? loaded,
    TResult Function(_CommentsError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _CommentsLoading implements InstagramCommentsState {
  const factory _CommentsLoading() = _$CommentsLoadingImpl;
}

/// @nodoc
abstract class _$$CommentsLoadedImplCopyWith<$Res> {
  factory _$$CommentsLoadedImplCopyWith(
    _$CommentsLoadedImpl value,
    $Res Function(_$CommentsLoadedImpl) then,
  ) = __$$CommentsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<InstagramCommentEntity> comments, int count});
}

/// @nodoc
class __$$CommentsLoadedImplCopyWithImpl<$Res>
    extends _$InstagramCommentsStateCopyWithImpl<$Res, _$CommentsLoadedImpl>
    implements _$$CommentsLoadedImplCopyWith<$Res> {
  __$$CommentsLoadedImplCopyWithImpl(
    _$CommentsLoadedImpl _value,
    $Res Function(_$CommentsLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InstagramCommentsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? comments = null, Object? count = null}) {
    return _then(
      _$CommentsLoadedImpl(
        comments: null == comments
            ? _value._comments
            : comments // ignore: cast_nullable_to_non_nullable
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

class _$CommentsLoadedImpl implements _CommentsLoaded {
  const _$CommentsLoadedImpl({
    required final List<InstagramCommentEntity> comments,
    required this.count,
  }) : _comments = comments;

  final List<InstagramCommentEntity> _comments;
  @override
  List<InstagramCommentEntity> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  @override
  final int count;

  @override
  String toString() {
    return 'InstagramCommentsState.loaded(comments: $comments, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentsLoadedImpl &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
            (identical(other.count, count) || other.count == count));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_comments),
    count,
  );

  /// Create a copy of InstagramCommentsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentsLoadedImplCopyWith<_$CommentsLoadedImpl> get copyWith =>
      __$$CommentsLoadedImplCopyWithImpl<_$CommentsLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<InstagramCommentEntity> comments, int count)
    loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(comments, count);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<InstagramCommentEntity> comments, int count)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(comments, count);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<InstagramCommentEntity> comments, int count)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(comments, count);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_CommentsInitial value) initial,
    required TResult Function(_CommentsLoading value) loading,
    required TResult Function(_CommentsLoaded value) loaded,
    required TResult Function(_CommentsError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_CommentsInitial value)? initial,
    TResult? Function(_CommentsLoading value)? loading,
    TResult? Function(_CommentsLoaded value)? loaded,
    TResult? Function(_CommentsError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_CommentsInitial value)? initial,
    TResult Function(_CommentsLoading value)? loading,
    TResult Function(_CommentsLoaded value)? loaded,
    TResult Function(_CommentsError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _CommentsLoaded implements InstagramCommentsState {
  const factory _CommentsLoaded({
    required final List<InstagramCommentEntity> comments,
    required final int count,
  }) = _$CommentsLoadedImpl;

  List<InstagramCommentEntity> get comments;
  int get count;

  /// Create a copy of InstagramCommentsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentsLoadedImplCopyWith<_$CommentsLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CommentsErrorImplCopyWith<$Res> {
  factory _$$CommentsErrorImplCopyWith(
    _$CommentsErrorImpl value,
    $Res Function(_$CommentsErrorImpl) then,
  ) = __$$CommentsErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$CommentsErrorImplCopyWithImpl<$Res>
    extends _$InstagramCommentsStateCopyWithImpl<$Res, _$CommentsErrorImpl>
    implements _$$CommentsErrorImplCopyWith<$Res> {
  __$$CommentsErrorImplCopyWithImpl(
    _$CommentsErrorImpl _value,
    $Res Function(_$CommentsErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InstagramCommentsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$CommentsErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$CommentsErrorImpl implements _CommentsError {
  const _$CommentsErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'InstagramCommentsState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentsErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of InstagramCommentsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentsErrorImplCopyWith<_$CommentsErrorImpl> get copyWith =>
      __$$CommentsErrorImplCopyWithImpl<_$CommentsErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<InstagramCommentEntity> comments, int count)
    loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<InstagramCommentEntity> comments, int count)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<InstagramCommentEntity> comments, int count)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_CommentsInitial value) initial,
    required TResult Function(_CommentsLoading value) loading,
    required TResult Function(_CommentsLoaded value) loaded,
    required TResult Function(_CommentsError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_CommentsInitial value)? initial,
    TResult? Function(_CommentsLoading value)? loading,
    TResult? Function(_CommentsLoaded value)? loaded,
    TResult? Function(_CommentsError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_CommentsInitial value)? initial,
    TResult Function(_CommentsLoading value)? loading,
    TResult Function(_CommentsLoaded value)? loaded,
    TResult Function(_CommentsError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _CommentsError implements InstagramCommentsState {
  const factory _CommentsError({required final String message}) =
      _$CommentsErrorImpl;

  String get message;

  /// Create a copy of InstagramCommentsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentsErrorImplCopyWith<_$CommentsErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

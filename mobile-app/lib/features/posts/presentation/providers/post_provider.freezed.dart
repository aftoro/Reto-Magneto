// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PostState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message, String? postUrl, String? storyUrl)
    postSuccess,
    required TResult Function(String message, String? storyUrl) storySuccess,
    required TResult Function(String error) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message, String? postUrl, String? storyUrl)?
    postSuccess,
    TResult? Function(String message, String? storyUrl)? storySuccess,
    TResult? Function(String error)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message, String? postUrl, String? storyUrl)?
    postSuccess,
    TResult Function(String message, String? storyUrl)? storySuccess,
    TResult Function(String error)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_PostSuccess value) postSuccess,
    required TResult Function(_StorySuccess value) storySuccess,
    required TResult Function(_Error value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_PostSuccess value)? postSuccess,
    TResult? Function(_StorySuccess value)? storySuccess,
    TResult? Function(_Error value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_PostSuccess value)? postSuccess,
    TResult Function(_StorySuccess value)? storySuccess,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostStateCopyWith<$Res> {
  factory $PostStateCopyWith(PostState value, $Res Function(PostState) then) =
      _$PostStateCopyWithImpl<$Res, PostState>;
}

/// @nodoc
class _$PostStateCopyWithImpl<$Res, $Val extends PostState>
    implements $PostStateCopyWith<$Res> {
  _$PostStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostState
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
    extends _$PostStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'PostState.initial()';
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
    required TResult Function(String message, String? postUrl, String? storyUrl)
    postSuccess,
    required TResult Function(String message, String? storyUrl) storySuccess,
    required TResult Function(String error) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message, String? postUrl, String? storyUrl)?
    postSuccess,
    TResult? Function(String message, String? storyUrl)? storySuccess,
    TResult? Function(String error)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message, String? postUrl, String? storyUrl)?
    postSuccess,
    TResult Function(String message, String? storyUrl)? storySuccess,
    TResult Function(String error)? error,
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
    required TResult Function(_PostSuccess value) postSuccess,
    required TResult Function(_StorySuccess value) storySuccess,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_PostSuccess value)? postSuccess,
    TResult? Function(_StorySuccess value)? storySuccess,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_PostSuccess value)? postSuccess,
    TResult Function(_StorySuccess value)? storySuccess,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements PostState {
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
    extends _$PostStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
    _$LoadingImpl _value,
    $Res Function(_$LoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'PostState.loading()';
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
    required TResult Function(String message, String? postUrl, String? storyUrl)
    postSuccess,
    required TResult Function(String message, String? storyUrl) storySuccess,
    required TResult Function(String error) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message, String? postUrl, String? storyUrl)?
    postSuccess,
    TResult? Function(String message, String? storyUrl)? storySuccess,
    TResult? Function(String error)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message, String? postUrl, String? storyUrl)?
    postSuccess,
    TResult Function(String message, String? storyUrl)? storySuccess,
    TResult Function(String error)? error,
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
    required TResult Function(_PostSuccess value) postSuccess,
    required TResult Function(_StorySuccess value) storySuccess,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_PostSuccess value)? postSuccess,
    TResult? Function(_StorySuccess value)? storySuccess,
    TResult? Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_PostSuccess value)? postSuccess,
    TResult Function(_StorySuccess value)? storySuccess,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements PostState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$PostSuccessImplCopyWith<$Res> {
  factory _$$PostSuccessImplCopyWith(
    _$PostSuccessImpl value,
    $Res Function(_$PostSuccessImpl) then,
  ) = __$$PostSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, String? postUrl, String? storyUrl});
}

/// @nodoc
class __$$PostSuccessImplCopyWithImpl<$Res>
    extends _$PostStateCopyWithImpl<$Res, _$PostSuccessImpl>
    implements _$$PostSuccessImplCopyWith<$Res> {
  __$$PostSuccessImplCopyWithImpl(
    _$PostSuccessImpl _value,
    $Res Function(_$PostSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? postUrl = freezed,
    Object? storyUrl = freezed,
  }) {
    return _then(
      _$PostSuccessImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        postUrl: freezed == postUrl
            ? _value.postUrl
            : postUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        storyUrl: freezed == storyUrl
            ? _value.storyUrl
            : storyUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$PostSuccessImpl implements _PostSuccess {
  const _$PostSuccessImpl({required this.message, this.postUrl, this.storyUrl});

  @override
  final String message;
  @override
  final String? postUrl;
  @override
  final String? storyUrl;

  @override
  String toString() {
    return 'PostState.postSuccess(message: $message, postUrl: $postUrl, storyUrl: $storyUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostSuccessImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.postUrl, postUrl) || other.postUrl == postUrl) &&
            (identical(other.storyUrl, storyUrl) ||
                other.storyUrl == storyUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, postUrl, storyUrl);

  /// Create a copy of PostState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostSuccessImplCopyWith<_$PostSuccessImpl> get copyWith =>
      __$$PostSuccessImplCopyWithImpl<_$PostSuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message, String? postUrl, String? storyUrl)
    postSuccess,
    required TResult Function(String message, String? storyUrl) storySuccess,
    required TResult Function(String error) error,
  }) {
    return postSuccess(message, postUrl, storyUrl);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message, String? postUrl, String? storyUrl)?
    postSuccess,
    TResult? Function(String message, String? storyUrl)? storySuccess,
    TResult? Function(String error)? error,
  }) {
    return postSuccess?.call(message, postUrl, storyUrl);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message, String? postUrl, String? storyUrl)?
    postSuccess,
    TResult Function(String message, String? storyUrl)? storySuccess,
    TResult Function(String error)? error,
    required TResult orElse(),
  }) {
    if (postSuccess != null) {
      return postSuccess(message, postUrl, storyUrl);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_PostSuccess value) postSuccess,
    required TResult Function(_StorySuccess value) storySuccess,
    required TResult Function(_Error value) error,
  }) {
    return postSuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_PostSuccess value)? postSuccess,
    TResult? Function(_StorySuccess value)? storySuccess,
    TResult? Function(_Error value)? error,
  }) {
    return postSuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_PostSuccess value)? postSuccess,
    TResult Function(_StorySuccess value)? storySuccess,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (postSuccess != null) {
      return postSuccess(this);
    }
    return orElse();
  }
}

abstract class _PostSuccess implements PostState {
  const factory _PostSuccess({
    required final String message,
    final String? postUrl,
    final String? storyUrl,
  }) = _$PostSuccessImpl;

  String get message;
  String? get postUrl;
  String? get storyUrl;

  /// Create a copy of PostState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostSuccessImplCopyWith<_$PostSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StorySuccessImplCopyWith<$Res> {
  factory _$$StorySuccessImplCopyWith(
    _$StorySuccessImpl value,
    $Res Function(_$StorySuccessImpl) then,
  ) = __$$StorySuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, String? storyUrl});
}

/// @nodoc
class __$$StorySuccessImplCopyWithImpl<$Res>
    extends _$PostStateCopyWithImpl<$Res, _$StorySuccessImpl>
    implements _$$StorySuccessImplCopyWith<$Res> {
  __$$StorySuccessImplCopyWithImpl(
    _$StorySuccessImpl _value,
    $Res Function(_$StorySuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? storyUrl = freezed}) {
    return _then(
      _$StorySuccessImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        storyUrl: freezed == storyUrl
            ? _value.storyUrl
            : storyUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$StorySuccessImpl implements _StorySuccess {
  const _$StorySuccessImpl({required this.message, this.storyUrl});

  @override
  final String message;
  @override
  final String? storyUrl;

  @override
  String toString() {
    return 'PostState.storySuccess(message: $message, storyUrl: $storyUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StorySuccessImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.storyUrl, storyUrl) ||
                other.storyUrl == storyUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, storyUrl);

  /// Create a copy of PostState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StorySuccessImplCopyWith<_$StorySuccessImpl> get copyWith =>
      __$$StorySuccessImplCopyWithImpl<_$StorySuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message, String? postUrl, String? storyUrl)
    postSuccess,
    required TResult Function(String message, String? storyUrl) storySuccess,
    required TResult Function(String error) error,
  }) {
    return storySuccess(message, storyUrl);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message, String? postUrl, String? storyUrl)?
    postSuccess,
    TResult? Function(String message, String? storyUrl)? storySuccess,
    TResult? Function(String error)? error,
  }) {
    return storySuccess?.call(message, storyUrl);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message, String? postUrl, String? storyUrl)?
    postSuccess,
    TResult Function(String message, String? storyUrl)? storySuccess,
    TResult Function(String error)? error,
    required TResult orElse(),
  }) {
    if (storySuccess != null) {
      return storySuccess(message, storyUrl);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_PostSuccess value) postSuccess,
    required TResult Function(_StorySuccess value) storySuccess,
    required TResult Function(_Error value) error,
  }) {
    return storySuccess(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_PostSuccess value)? postSuccess,
    TResult? Function(_StorySuccess value)? storySuccess,
    TResult? Function(_Error value)? error,
  }) {
    return storySuccess?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_PostSuccess value)? postSuccess,
    TResult Function(_StorySuccess value)? storySuccess,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (storySuccess != null) {
      return storySuccess(this);
    }
    return orElse();
  }
}

abstract class _StorySuccess implements PostState {
  const factory _StorySuccess({
    required final String message,
    final String? storyUrl,
  }) = _$StorySuccessImpl;

  String get message;
  String? get storyUrl;

  /// Create a copy of PostState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StorySuccessImplCopyWith<_$StorySuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
    _$ErrorImpl value,
    $Res Function(_$ErrorImpl) then,
  ) = __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String error});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$PostStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
    _$ErrorImpl _value,
    $Res Function(_$ErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null}) {
    return _then(
      _$ErrorImpl(
        null == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.error);

  @override
  final String error;

  @override
  String toString() {
    return 'PostState.error(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of PostState
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
    required TResult Function(String message, String? postUrl, String? storyUrl)
    postSuccess,
    required TResult Function(String message, String? storyUrl) storySuccess,
    required TResult Function(String error) error,
  }) {
    return error(this.error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message, String? postUrl, String? storyUrl)?
    postSuccess,
    TResult? Function(String message, String? storyUrl)? storySuccess,
    TResult? Function(String error)? error,
  }) {
    return error?.call(this.error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message, String? postUrl, String? storyUrl)?
    postSuccess,
    TResult Function(String message, String? storyUrl)? storySuccess,
    TResult Function(String error)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this.error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_PostSuccess value) postSuccess,
    required TResult Function(_StorySuccess value) storySuccess,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_PostSuccess value)? postSuccess,
    TResult? Function(_StorySuccess value)? storySuccess,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_PostSuccess value)? postSuccess,
    TResult Function(_StorySuccess value)? storySuccess,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements PostState {
  const factory _Error(final String error) = _$ErrorImpl;

  String get error;

  /// Create a copy of PostState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

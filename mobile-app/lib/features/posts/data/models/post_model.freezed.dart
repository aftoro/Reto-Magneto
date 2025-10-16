// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CreatePostRequest _$CreatePostRequestFromJson(Map<String, dynamic> json) {
  return _CreatePostRequest.fromJson(json);
}

/// @nodoc
mixin _$CreatePostRequest {
  String get topic => throw _privateConstructorUsedError;
  String? get style => throw _privateConstructorUsedError;
  String? get target_audience => throw _privateConstructorUsedError;
  String? get reference_image => throw _privateConstructorUsedError;

  /// Serializes this CreatePostRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatePostRequestCopyWith<CreatePostRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePostRequestCopyWith<$Res> {
  factory $CreatePostRequestCopyWith(
    CreatePostRequest value,
    $Res Function(CreatePostRequest) then,
  ) = _$CreatePostRequestCopyWithImpl<$Res, CreatePostRequest>;
  @useResult
  $Res call({
    String topic,
    String? style,
    String? target_audience,
    String? reference_image,
  });
}

/// @nodoc
class _$CreatePostRequestCopyWithImpl<$Res, $Val extends CreatePostRequest>
    implements $CreatePostRequestCopyWith<$Res> {
  _$CreatePostRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topic = null,
    Object? style = freezed,
    Object? target_audience = freezed,
    Object? reference_image = freezed,
  }) {
    return _then(
      _value.copyWith(
            topic: null == topic
                ? _value.topic
                : topic // ignore: cast_nullable_to_non_nullable
                      as String,
            style: freezed == style
                ? _value.style
                : style // ignore: cast_nullable_to_non_nullable
                      as String?,
            target_audience: freezed == target_audience
                ? _value.target_audience
                : target_audience // ignore: cast_nullable_to_non_nullable
                      as String?,
            reference_image: freezed == reference_image
                ? _value.reference_image
                : reference_image // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreatePostRequestImplCopyWith<$Res>
    implements $CreatePostRequestCopyWith<$Res> {
  factory _$$CreatePostRequestImplCopyWith(
    _$CreatePostRequestImpl value,
    $Res Function(_$CreatePostRequestImpl) then,
  ) = __$$CreatePostRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String topic,
    String? style,
    String? target_audience,
    String? reference_image,
  });
}

/// @nodoc
class __$$CreatePostRequestImplCopyWithImpl<$Res>
    extends _$CreatePostRequestCopyWithImpl<$Res, _$CreatePostRequestImpl>
    implements _$$CreatePostRequestImplCopyWith<$Res> {
  __$$CreatePostRequestImplCopyWithImpl(
    _$CreatePostRequestImpl _value,
    $Res Function(_$CreatePostRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topic = null,
    Object? style = freezed,
    Object? target_audience = freezed,
    Object? reference_image = freezed,
  }) {
    return _then(
      _$CreatePostRequestImpl(
        topic: null == topic
            ? _value.topic
            : topic // ignore: cast_nullable_to_non_nullable
                  as String,
        style: freezed == style
            ? _value.style
            : style // ignore: cast_nullable_to_non_nullable
                  as String?,
        target_audience: freezed == target_audience
            ? _value.target_audience
            : target_audience // ignore: cast_nullable_to_non_nullable
                  as String?,
        reference_image: freezed == reference_image
            ? _value.reference_image
            : reference_image // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatePostRequestImpl implements _CreatePostRequest {
  const _$CreatePostRequestImpl({
    required this.topic,
    this.style,
    this.target_audience,
    this.reference_image,
  });

  factory _$CreatePostRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatePostRequestImplFromJson(json);

  @override
  final String topic;
  @override
  final String? style;
  @override
  final String? target_audience;
  @override
  final String? reference_image;

  @override
  String toString() {
    return 'CreatePostRequest(topic: $topic, style: $style, target_audience: $target_audience, reference_image: $reference_image)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePostRequestImpl &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.target_audience, target_audience) ||
                other.target_audience == target_audience) &&
            (identical(other.reference_image, reference_image) ||
                other.reference_image == reference_image));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, topic, style, target_audience, reference_image);

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePostRequestImplCopyWith<_$CreatePostRequestImpl> get copyWith =>
      __$$CreatePostRequestImplCopyWithImpl<_$CreatePostRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatePostRequestImplToJson(this);
  }
}

abstract class _CreatePostRequest implements CreatePostRequest {
  const factory _CreatePostRequest({
    required final String topic,
    final String? style,
    final String? target_audience,
    final String? reference_image,
  }) = _$CreatePostRequestImpl;

  factory _CreatePostRequest.fromJson(Map<String, dynamic> json) =
      _$CreatePostRequestImpl.fromJson;

  @override
  String get topic;
  @override
  String? get style;
  @override
  String? get target_audience;
  @override
  String? get reference_image;

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatePostRequestImplCopyWith<_$CreatePostRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatePostResponse _$CreatePostResponseFromJson(Map<String, dynamic> json) {
  return _CreatePostResponse.fromJson(json);
}

/// @nodoc
mixin _$CreatePostResponse {
  bool get success => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get post_url => throw _privateConstructorUsedError;
  String? get story_url => throw _privateConstructorUsedError;

  /// Serializes this CreatePostResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatePostResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatePostResponseCopyWith<CreatePostResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePostResponseCopyWith<$Res> {
  factory $CreatePostResponseCopyWith(
    CreatePostResponse value,
    $Res Function(CreatePostResponse) then,
  ) = _$CreatePostResponseCopyWithImpl<$Res, CreatePostResponse>;
  @useResult
  $Res call({
    bool success,
    String? message,
    String? error,
    String? post_url,
    String? story_url,
  });
}

/// @nodoc
class _$CreatePostResponseCopyWithImpl<$Res, $Val extends CreatePostResponse>
    implements $CreatePostResponseCopyWith<$Res> {
  _$CreatePostResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatePostResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? error = freezed,
    Object? post_url = freezed,
    Object? story_url = freezed,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            post_url: freezed == post_url
                ? _value.post_url
                : post_url // ignore: cast_nullable_to_non_nullable
                      as String?,
            story_url: freezed == story_url
                ? _value.story_url
                : story_url // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreatePostResponseImplCopyWith<$Res>
    implements $CreatePostResponseCopyWith<$Res> {
  factory _$$CreatePostResponseImplCopyWith(
    _$CreatePostResponseImpl value,
    $Res Function(_$CreatePostResponseImpl) then,
  ) = __$$CreatePostResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool success,
    String? message,
    String? error,
    String? post_url,
    String? story_url,
  });
}

/// @nodoc
class __$$CreatePostResponseImplCopyWithImpl<$Res>
    extends _$CreatePostResponseCopyWithImpl<$Res, _$CreatePostResponseImpl>
    implements _$$CreatePostResponseImplCopyWith<$Res> {
  __$$CreatePostResponseImplCopyWithImpl(
    _$CreatePostResponseImpl _value,
    $Res Function(_$CreatePostResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreatePostResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? error = freezed,
    Object? post_url = freezed,
    Object? story_url = freezed,
  }) {
    return _then(
      _$CreatePostResponseImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        post_url: freezed == post_url
            ? _value.post_url
            : post_url // ignore: cast_nullable_to_non_nullable
                  as String?,
        story_url: freezed == story_url
            ? _value.story_url
            : story_url // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatePostResponseImpl implements _CreatePostResponse {
  const _$CreatePostResponseImpl({
    required this.success,
    this.message,
    this.error,
    this.post_url,
    this.story_url,
  });

  factory _$CreatePostResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatePostResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String? message;
  @override
  final String? error;
  @override
  final String? post_url;
  @override
  final String? story_url;

  @override
  String toString() {
    return 'CreatePostResponse(success: $success, message: $message, error: $error, post_url: $post_url, story_url: $story_url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePostResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.post_url, post_url) ||
                other.post_url == post_url) &&
            (identical(other.story_url, story_url) ||
                other.story_url == story_url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, success, message, error, post_url, story_url);

  /// Create a copy of CreatePostResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePostResponseImplCopyWith<_$CreatePostResponseImpl> get copyWith =>
      __$$CreatePostResponseImplCopyWithImpl<_$CreatePostResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatePostResponseImplToJson(this);
  }
}

abstract class _CreatePostResponse implements CreatePostResponse {
  const factory _CreatePostResponse({
    required final bool success,
    final String? message,
    final String? error,
    final String? post_url,
    final String? story_url,
  }) = _$CreatePostResponseImpl;

  factory _CreatePostResponse.fromJson(Map<String, dynamic> json) =
      _$CreatePostResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String? get message;
  @override
  String? get error;
  @override
  String? get post_url;
  @override
  String? get story_url;

  /// Create a copy of CreatePostResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatePostResponseImplCopyWith<_$CreatePostResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateStoryRequest _$CreateStoryRequestFromJson(Map<String, dynamic> json) {
  return _CreateStoryRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateStoryRequest {
  String get topic => throw _privateConstructorUsedError;
  String? get style => throw _privateConstructorUsedError;
  String? get target_audience => throw _privateConstructorUsedError;
  String? get reference_image => throw _privateConstructorUsedError;

  /// Serializes this CreateStoryRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateStoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateStoryRequestCopyWith<CreateStoryRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateStoryRequestCopyWith<$Res> {
  factory $CreateStoryRequestCopyWith(
    CreateStoryRequest value,
    $Res Function(CreateStoryRequest) then,
  ) = _$CreateStoryRequestCopyWithImpl<$Res, CreateStoryRequest>;
  @useResult
  $Res call({
    String topic,
    String? style,
    String? target_audience,
    String? reference_image,
  });
}

/// @nodoc
class _$CreateStoryRequestCopyWithImpl<$Res, $Val extends CreateStoryRequest>
    implements $CreateStoryRequestCopyWith<$Res> {
  _$CreateStoryRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateStoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topic = null,
    Object? style = freezed,
    Object? target_audience = freezed,
    Object? reference_image = freezed,
  }) {
    return _then(
      _value.copyWith(
            topic: null == topic
                ? _value.topic
                : topic // ignore: cast_nullable_to_non_nullable
                      as String,
            style: freezed == style
                ? _value.style
                : style // ignore: cast_nullable_to_non_nullable
                      as String?,
            target_audience: freezed == target_audience
                ? _value.target_audience
                : target_audience // ignore: cast_nullable_to_non_nullable
                      as String?,
            reference_image: freezed == reference_image
                ? _value.reference_image
                : reference_image // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateStoryRequestImplCopyWith<$Res>
    implements $CreateStoryRequestCopyWith<$Res> {
  factory _$$CreateStoryRequestImplCopyWith(
    _$CreateStoryRequestImpl value,
    $Res Function(_$CreateStoryRequestImpl) then,
  ) = __$$CreateStoryRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String topic,
    String? style,
    String? target_audience,
    String? reference_image,
  });
}

/// @nodoc
class __$$CreateStoryRequestImplCopyWithImpl<$Res>
    extends _$CreateStoryRequestCopyWithImpl<$Res, _$CreateStoryRequestImpl>
    implements _$$CreateStoryRequestImplCopyWith<$Res> {
  __$$CreateStoryRequestImplCopyWithImpl(
    _$CreateStoryRequestImpl _value,
    $Res Function(_$CreateStoryRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateStoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topic = null,
    Object? style = freezed,
    Object? target_audience = freezed,
    Object? reference_image = freezed,
  }) {
    return _then(
      _$CreateStoryRequestImpl(
        topic: null == topic
            ? _value.topic
            : topic // ignore: cast_nullable_to_non_nullable
                  as String,
        style: freezed == style
            ? _value.style
            : style // ignore: cast_nullable_to_non_nullable
                  as String?,
        target_audience: freezed == target_audience
            ? _value.target_audience
            : target_audience // ignore: cast_nullable_to_non_nullable
                  as String?,
        reference_image: freezed == reference_image
            ? _value.reference_image
            : reference_image // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateStoryRequestImpl implements _CreateStoryRequest {
  const _$CreateStoryRequestImpl({
    required this.topic,
    this.style,
    this.target_audience,
    this.reference_image,
  });

  factory _$CreateStoryRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateStoryRequestImplFromJson(json);

  @override
  final String topic;
  @override
  final String? style;
  @override
  final String? target_audience;
  @override
  final String? reference_image;

  @override
  String toString() {
    return 'CreateStoryRequest(topic: $topic, style: $style, target_audience: $target_audience, reference_image: $reference_image)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateStoryRequestImpl &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.target_audience, target_audience) ||
                other.target_audience == target_audience) &&
            (identical(other.reference_image, reference_image) ||
                other.reference_image == reference_image));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, topic, style, target_audience, reference_image);

  /// Create a copy of CreateStoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateStoryRequestImplCopyWith<_$CreateStoryRequestImpl> get copyWith =>
      __$$CreateStoryRequestImplCopyWithImpl<_$CreateStoryRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateStoryRequestImplToJson(this);
  }
}

abstract class _CreateStoryRequest implements CreateStoryRequest {
  const factory _CreateStoryRequest({
    required final String topic,
    final String? style,
    final String? target_audience,
    final String? reference_image,
  }) = _$CreateStoryRequestImpl;

  factory _CreateStoryRequest.fromJson(Map<String, dynamic> json) =
      _$CreateStoryRequestImpl.fromJson;

  @override
  String get topic;
  @override
  String? get style;
  @override
  String? get target_audience;
  @override
  String? get reference_image;

  /// Create a copy of CreateStoryRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateStoryRequestImplCopyWith<_$CreateStoryRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateStoryResponse _$CreateStoryResponseFromJson(Map<String, dynamic> json) {
  return _CreateStoryResponse.fromJson(json);
}

/// @nodoc
mixin _$CreateStoryResponse {
  bool get success => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  String? get story_url => throw _privateConstructorUsedError;

  /// Serializes this CreateStoryResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateStoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateStoryResponseCopyWith<CreateStoryResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateStoryResponseCopyWith<$Res> {
  factory $CreateStoryResponseCopyWith(
    CreateStoryResponse value,
    $Res Function(CreateStoryResponse) then,
  ) = _$CreateStoryResponseCopyWithImpl<$Res, CreateStoryResponse>;
  @useResult
  $Res call({bool success, String? message, String? error, String? story_url});
}

/// @nodoc
class _$CreateStoryResponseCopyWithImpl<$Res, $Val extends CreateStoryResponse>
    implements $CreateStoryResponseCopyWith<$Res> {
  _$CreateStoryResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateStoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? error = freezed,
    Object? story_url = freezed,
  }) {
    return _then(
      _value.copyWith(
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            story_url: freezed == story_url
                ? _value.story_url
                : story_url // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateStoryResponseImplCopyWith<$Res>
    implements $CreateStoryResponseCopyWith<$Res> {
  factory _$$CreateStoryResponseImplCopyWith(
    _$CreateStoryResponseImpl value,
    $Res Function(_$CreateStoryResponseImpl) then,
  ) = __$$CreateStoryResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, String? message, String? error, String? story_url});
}

/// @nodoc
class __$$CreateStoryResponseImplCopyWithImpl<$Res>
    extends _$CreateStoryResponseCopyWithImpl<$Res, _$CreateStoryResponseImpl>
    implements _$$CreateStoryResponseImplCopyWith<$Res> {
  __$$CreateStoryResponseImplCopyWithImpl(
    _$CreateStoryResponseImpl _value,
    $Res Function(_$CreateStoryResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateStoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = freezed,
    Object? error = freezed,
    Object? story_url = freezed,
  }) {
    return _then(
      _$CreateStoryResponseImpl(
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        story_url: freezed == story_url
            ? _value.story_url
            : story_url // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateStoryResponseImpl implements _CreateStoryResponse {
  const _$CreateStoryResponseImpl({
    required this.success,
    this.message,
    this.error,
    this.story_url,
  });

  factory _$CreateStoryResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateStoryResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final String? message;
  @override
  final String? error;
  @override
  final String? story_url;

  @override
  String toString() {
    return 'CreateStoryResponse(success: $success, message: $message, error: $error, story_url: $story_url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateStoryResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.story_url, story_url) ||
                other.story_url == story_url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, success, message, error, story_url);

  /// Create a copy of CreateStoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateStoryResponseImplCopyWith<_$CreateStoryResponseImpl> get copyWith =>
      __$$CreateStoryResponseImplCopyWithImpl<_$CreateStoryResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateStoryResponseImplToJson(this);
  }
}

abstract class _CreateStoryResponse implements CreateStoryResponse {
  const factory _CreateStoryResponse({
    required final bool success,
    final String? message,
    final String? error,
    final String? story_url,
  }) = _$CreateStoryResponseImpl;

  factory _CreateStoryResponse.fromJson(Map<String, dynamic> json) =
      _$CreateStoryResponseImpl.fromJson;

  @override
  bool get success;
  @override
  String? get message;
  @override
  String? get error;
  @override
  String? get story_url;

  /// Create a copy of CreateStoryResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateStoryResponseImplCopyWith<_$CreateStoryResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PostModel _$PostModelFromJson(Map<String, dynamic> json) {
  return _PostModel.fromJson(json);
}

/// @nodoc
mixin _$PostModel {
  String get topic => throw _privateConstructorUsedError;
  String? get style => throw _privateConstructorUsedError;
  String? get targetAudience => throw _privateConstructorUsedError;
  String? get referenceImagePath => throw _privateConstructorUsedError;

  /// Serializes this PostModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostModelCopyWith<PostModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostModelCopyWith<$Res> {
  factory $PostModelCopyWith(PostModel value, $Res Function(PostModel) then) =
      _$PostModelCopyWithImpl<$Res, PostModel>;
  @useResult
  $Res call({
    String topic,
    String? style,
    String? targetAudience,
    String? referenceImagePath,
  });
}

/// @nodoc
class _$PostModelCopyWithImpl<$Res, $Val extends PostModel>
    implements $PostModelCopyWith<$Res> {
  _$PostModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topic = null,
    Object? style = freezed,
    Object? targetAudience = freezed,
    Object? referenceImagePath = freezed,
  }) {
    return _then(
      _value.copyWith(
            topic: null == topic
                ? _value.topic
                : topic // ignore: cast_nullable_to_non_nullable
                      as String,
            style: freezed == style
                ? _value.style
                : style // ignore: cast_nullable_to_non_nullable
                      as String?,
            targetAudience: freezed == targetAudience
                ? _value.targetAudience
                : targetAudience // ignore: cast_nullable_to_non_nullable
                      as String?,
            referenceImagePath: freezed == referenceImagePath
                ? _value.referenceImagePath
                : referenceImagePath // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PostModelImplCopyWith<$Res>
    implements $PostModelCopyWith<$Res> {
  factory _$$PostModelImplCopyWith(
    _$PostModelImpl value,
    $Res Function(_$PostModelImpl) then,
  ) = __$$PostModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String topic,
    String? style,
    String? targetAudience,
    String? referenceImagePath,
  });
}

/// @nodoc
class __$$PostModelImplCopyWithImpl<$Res>
    extends _$PostModelCopyWithImpl<$Res, _$PostModelImpl>
    implements _$$PostModelImplCopyWith<$Res> {
  __$$PostModelImplCopyWithImpl(
    _$PostModelImpl _value,
    $Res Function(_$PostModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topic = null,
    Object? style = freezed,
    Object? targetAudience = freezed,
    Object? referenceImagePath = freezed,
  }) {
    return _then(
      _$PostModelImpl(
        topic: null == topic
            ? _value.topic
            : topic // ignore: cast_nullable_to_non_nullable
                  as String,
        style: freezed == style
            ? _value.style
            : style // ignore: cast_nullable_to_non_nullable
                  as String?,
        targetAudience: freezed == targetAudience
            ? _value.targetAudience
            : targetAudience // ignore: cast_nullable_to_non_nullable
                  as String?,
        referenceImagePath: freezed == referenceImagePath
            ? _value.referenceImagePath
            : referenceImagePath // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PostModelImpl implements _PostModel {
  const _$PostModelImpl({
    required this.topic,
    this.style,
    this.targetAudience,
    this.referenceImagePath,
  });

  factory _$PostModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostModelImplFromJson(json);

  @override
  final String topic;
  @override
  final String? style;
  @override
  final String? targetAudience;
  @override
  final String? referenceImagePath;

  @override
  String toString() {
    return 'PostModel(topic: $topic, style: $style, targetAudience: $targetAudience, referenceImagePath: $referenceImagePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostModelImpl &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.targetAudience, targetAudience) ||
                other.targetAudience == targetAudience) &&
            (identical(other.referenceImagePath, referenceImagePath) ||
                other.referenceImagePath == referenceImagePath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    topic,
    style,
    targetAudience,
    referenceImagePath,
  );

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      __$$PostModelImplCopyWithImpl<_$PostModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostModelImplToJson(this);
  }
}

abstract class _PostModel implements PostModel {
  const factory _PostModel({
    required final String topic,
    final String? style,
    final String? targetAudience,
    final String? referenceImagePath,
  }) = _$PostModelImpl;

  factory _PostModel.fromJson(Map<String, dynamic> json) =
      _$PostModelImpl.fromJson;

  @override
  String get topic;
  @override
  String? get style;
  @override
  String? get targetAudience;
  @override
  String? get referenceImagePath;

  /// Create a copy of PostModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostModelImplCopyWith<_$PostModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StoryModel _$StoryModelFromJson(Map<String, dynamic> json) {
  return _StoryModel.fromJson(json);
}

/// @nodoc
mixin _$StoryModel {
  String get topic => throw _privateConstructorUsedError;
  String? get style => throw _privateConstructorUsedError;
  String? get targetAudience => throw _privateConstructorUsedError;
  String? get referenceImagePath => throw _privateConstructorUsedError;

  /// Serializes this StoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StoryModelCopyWith<StoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryModelCopyWith<$Res> {
  factory $StoryModelCopyWith(
    StoryModel value,
    $Res Function(StoryModel) then,
  ) = _$StoryModelCopyWithImpl<$Res, StoryModel>;
  @useResult
  $Res call({
    String topic,
    String? style,
    String? targetAudience,
    String? referenceImagePath,
  });
}

/// @nodoc
class _$StoryModelCopyWithImpl<$Res, $Val extends StoryModel>
    implements $StoryModelCopyWith<$Res> {
  _$StoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topic = null,
    Object? style = freezed,
    Object? targetAudience = freezed,
    Object? referenceImagePath = freezed,
  }) {
    return _then(
      _value.copyWith(
            topic: null == topic
                ? _value.topic
                : topic // ignore: cast_nullable_to_non_nullable
                      as String,
            style: freezed == style
                ? _value.style
                : style // ignore: cast_nullable_to_non_nullable
                      as String?,
            targetAudience: freezed == targetAudience
                ? _value.targetAudience
                : targetAudience // ignore: cast_nullable_to_non_nullable
                      as String?,
            referenceImagePath: freezed == referenceImagePath
                ? _value.referenceImagePath
                : referenceImagePath // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StoryModelImplCopyWith<$Res>
    implements $StoryModelCopyWith<$Res> {
  factory _$$StoryModelImplCopyWith(
    _$StoryModelImpl value,
    $Res Function(_$StoryModelImpl) then,
  ) = __$$StoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String topic,
    String? style,
    String? targetAudience,
    String? referenceImagePath,
  });
}

/// @nodoc
class __$$StoryModelImplCopyWithImpl<$Res>
    extends _$StoryModelCopyWithImpl<$Res, _$StoryModelImpl>
    implements _$$StoryModelImplCopyWith<$Res> {
  __$$StoryModelImplCopyWithImpl(
    _$StoryModelImpl _value,
    $Res Function(_$StoryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topic = null,
    Object? style = freezed,
    Object? targetAudience = freezed,
    Object? referenceImagePath = freezed,
  }) {
    return _then(
      _$StoryModelImpl(
        topic: null == topic
            ? _value.topic
            : topic // ignore: cast_nullable_to_non_nullable
                  as String,
        style: freezed == style
            ? _value.style
            : style // ignore: cast_nullable_to_non_nullable
                  as String?,
        targetAudience: freezed == targetAudience
            ? _value.targetAudience
            : targetAudience // ignore: cast_nullable_to_non_nullable
                  as String?,
        referenceImagePath: freezed == referenceImagePath
            ? _value.referenceImagePath
            : referenceImagePath // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StoryModelImpl implements _StoryModel {
  const _$StoryModelImpl({
    required this.topic,
    this.style,
    this.targetAudience,
    this.referenceImagePath,
  });

  factory _$StoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StoryModelImplFromJson(json);

  @override
  final String topic;
  @override
  final String? style;
  @override
  final String? targetAudience;
  @override
  final String? referenceImagePath;

  @override
  String toString() {
    return 'StoryModel(topic: $topic, style: $style, targetAudience: $targetAudience, referenceImagePath: $referenceImagePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StoryModelImpl &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.targetAudience, targetAudience) ||
                other.targetAudience == targetAudience) &&
            (identical(other.referenceImagePath, referenceImagePath) ||
                other.referenceImagePath == referenceImagePath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    topic,
    style,
    targetAudience,
    referenceImagePath,
  );

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StoryModelImplCopyWith<_$StoryModelImpl> get copyWith =>
      __$$StoryModelImplCopyWithImpl<_$StoryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StoryModelImplToJson(this);
  }
}

abstract class _StoryModel implements StoryModel {
  const factory _StoryModel({
    required final String topic,
    final String? style,
    final String? targetAudience,
    final String? referenceImagePath,
  }) = _$StoryModelImpl;

  factory _StoryModel.fromJson(Map<String, dynamic> json) =
      _$StoryModelImpl.fromJson;

  @override
  String get topic;
  @override
  String? get style;
  @override
  String? get targetAudience;
  @override
  String? get referenceImagePath;

  /// Create a copy of StoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StoryModelImplCopyWith<_$StoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

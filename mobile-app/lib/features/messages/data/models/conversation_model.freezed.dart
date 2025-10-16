// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) {
  return _ConversationModel.fromJson(json);
}

/// @nodoc
mixin _$ConversationModel {
  String get id => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;
  String get conversationType => throw _privateConstructorUsedError;
  String? get externalConversationId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ConversationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationModelCopyWith<ConversationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationModelCopyWith<$Res> {
  factory $ConversationModelCopyWith(
    ConversationModel value,
    $Res Function(ConversationModel) then,
  ) = _$ConversationModelCopyWithImpl<$Res, ConversationModel>;
  @useResult
  $Res call({
    String id,
    String platform,
    String conversationType,
    String? externalConversationId,
    String userId,
    String? username,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$ConversationModelCopyWithImpl<$Res, $Val extends ConversationModel>
    implements $ConversationModelCopyWith<$Res> {
  _$ConversationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? platform = null,
    Object? conversationType = null,
    Object? externalConversationId = freezed,
    Object? userId = null,
    Object? username = freezed,
    Object? status = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            platform: null == platform
                ? _value.platform
                : platform // ignore: cast_nullable_to_non_nullable
                      as String,
            conversationType: null == conversationType
                ? _value.conversationType
                : conversationType // ignore: cast_nullable_to_non_nullable
                      as String,
            externalConversationId: freezed == externalConversationId
                ? _value.externalConversationId
                : externalConversationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            username: freezed == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConversationModelImplCopyWith<$Res>
    implements $ConversationModelCopyWith<$Res> {
  factory _$$ConversationModelImplCopyWith(
    _$ConversationModelImpl value,
    $Res Function(_$ConversationModelImpl) then,
  ) = __$$ConversationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String platform,
    String conversationType,
    String? externalConversationId,
    String userId,
    String? username,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ConversationModelImplCopyWithImpl<$Res>
    extends _$ConversationModelCopyWithImpl<$Res, _$ConversationModelImpl>
    implements _$$ConversationModelImplCopyWith<$Res> {
  __$$ConversationModelImplCopyWithImpl(
    _$ConversationModelImpl _value,
    $Res Function(_$ConversationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? platform = null,
    Object? conversationType = null,
    Object? externalConversationId = freezed,
    Object? userId = null,
    Object? username = freezed,
    Object? status = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ConversationModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        platform: null == platform
            ? _value.platform
            : platform // ignore: cast_nullable_to_non_nullable
                  as String,
        conversationType: null == conversationType
            ? _value.conversationType
            : conversationType // ignore: cast_nullable_to_non_nullable
                  as String,
        externalConversationId: freezed == externalConversationId
            ? _value.externalConversationId
            : externalConversationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        username: freezed == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationModelImpl implements _ConversationModel {
  const _$ConversationModelImpl({
    required this.id,
    required this.platform,
    required this.conversationType,
    this.externalConversationId,
    required this.userId,
    this.username,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory _$ConversationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String platform;
  @override
  final String conversationType;
  @override
  final String? externalConversationId;
  @override
  final String userId;
  @override
  final String? username;
  @override
  final String? status;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ConversationModel(id: $id, platform: $platform, conversationType: $conversationType, externalConversationId: $externalConversationId, userId: $userId, username: $username, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.conversationType, conversationType) ||
                other.conversationType == conversationType) &&
            (identical(other.externalConversationId, externalConversationId) ||
                other.externalConversationId == externalConversationId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    platform,
    conversationType,
    externalConversationId,
    userId,
    username,
    status,
    createdAt,
    updatedAt,
  );

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationModelImplCopyWith<_$ConversationModelImpl> get copyWith =>
      __$$ConversationModelImplCopyWithImpl<_$ConversationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationModelImplToJson(this);
  }
}

abstract class _ConversationModel implements ConversationModel {
  const factory _ConversationModel({
    required final String id,
    required final String platform,
    required final String conversationType,
    final String? externalConversationId,
    required final String userId,
    final String? username,
    final String? status,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$ConversationModelImpl;

  factory _ConversationModel.fromJson(Map<String, dynamic> json) =
      _$ConversationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get platform;
  @override
  String get conversationType;
  @override
  String? get externalConversationId;
  @override
  String get userId;
  @override
  String? get username;
  @override
  String? get status;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationModelImplCopyWith<_$ConversationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MessageEntity _$MessageEntityFromJson(Map<String, dynamic> json) {
  return _MessageEntity.fromJson(json);
}

/// @nodoc
mixin _$MessageEntity {
  String get id => throw _privateConstructorUsedError;
  String? get conversacionId => throw _privateConstructorUsedError;
  String? get platformMessageId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get messageType => throw _privateConstructorUsedError;
  Map<String, dynamic>? get mediaContext => throw _privateConstructorUsedError;
  bool? get isAiGenerated => throw _privateConstructorUsedError;
  String? get aiModel => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get sentAt => throw _privateConstructorUsedError;
  String? get deliveryStatus => throw _privateConstructorUsedError;

  /// Serializes this MessageEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageEntityCopyWith<MessageEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageEntityCopyWith<$Res> {
  factory $MessageEntityCopyWith(
    MessageEntity value,
    $Res Function(MessageEntity) then,
  ) = _$MessageEntityCopyWithImpl<$Res, MessageEntity>;
  @useResult
  $Res call({
    String id,
    String? conversacionId,
    String? platformMessageId,
    String content,
    String messageType,
    Map<String, dynamic>? mediaContext,
    bool? isAiGenerated,
    String? aiModel,
    DateTime? createdAt,
    DateTime? sentAt,
    String? deliveryStatus,
  });
}

/// @nodoc
class _$MessageEntityCopyWithImpl<$Res, $Val extends MessageEntity>
    implements $MessageEntityCopyWith<$Res> {
  _$MessageEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversacionId = freezed,
    Object? platformMessageId = freezed,
    Object? content = null,
    Object? messageType = null,
    Object? mediaContext = freezed,
    Object? isAiGenerated = freezed,
    Object? aiModel = freezed,
    Object? createdAt = freezed,
    Object? sentAt = freezed,
    Object? deliveryStatus = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            conversacionId: freezed == conversacionId
                ? _value.conversacionId
                : conversacionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            platformMessageId: freezed == platformMessageId
                ? _value.platformMessageId
                : platformMessageId // ignore: cast_nullable_to_non_nullable
                      as String?,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            messageType: null == messageType
                ? _value.messageType
                : messageType // ignore: cast_nullable_to_non_nullable
                      as String,
            mediaContext: freezed == mediaContext
                ? _value.mediaContext
                : mediaContext // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
            isAiGenerated: freezed == isAiGenerated
                ? _value.isAiGenerated
                : isAiGenerated // ignore: cast_nullable_to_non_nullable
                      as bool?,
            aiModel: freezed == aiModel
                ? _value.aiModel
                : aiModel // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            sentAt: freezed == sentAt
                ? _value.sentAt
                : sentAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            deliveryStatus: freezed == deliveryStatus
                ? _value.deliveryStatus
                : deliveryStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MessageEntityImplCopyWith<$Res>
    implements $MessageEntityCopyWith<$Res> {
  factory _$$MessageEntityImplCopyWith(
    _$MessageEntityImpl value,
    $Res Function(_$MessageEntityImpl) then,
  ) = __$$MessageEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? conversacionId,
    String? platformMessageId,
    String content,
    String messageType,
    Map<String, dynamic>? mediaContext,
    bool? isAiGenerated,
    String? aiModel,
    DateTime? createdAt,
    DateTime? sentAt,
    String? deliveryStatus,
  });
}

/// @nodoc
class __$$MessageEntityImplCopyWithImpl<$Res>
    extends _$MessageEntityCopyWithImpl<$Res, _$MessageEntityImpl>
    implements _$$MessageEntityImplCopyWith<$Res> {
  __$$MessageEntityImplCopyWithImpl(
    _$MessageEntityImpl _value,
    $Res Function(_$MessageEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MessageEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversacionId = freezed,
    Object? platformMessageId = freezed,
    Object? content = null,
    Object? messageType = null,
    Object? mediaContext = freezed,
    Object? isAiGenerated = freezed,
    Object? aiModel = freezed,
    Object? createdAt = freezed,
    Object? sentAt = freezed,
    Object? deliveryStatus = freezed,
  }) {
    return _then(
      _$MessageEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        conversacionId: freezed == conversacionId
            ? _value.conversacionId
            : conversacionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        platformMessageId: freezed == platformMessageId
            ? _value.platformMessageId
            : platformMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        messageType: null == messageType
            ? _value.messageType
            : messageType // ignore: cast_nullable_to_non_nullable
                  as String,
        mediaContext: freezed == mediaContext
            ? _value._mediaContext
            : mediaContext // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
        isAiGenerated: freezed == isAiGenerated
            ? _value.isAiGenerated
            : isAiGenerated // ignore: cast_nullable_to_non_nullable
                  as bool?,
        aiModel: freezed == aiModel
            ? _value.aiModel
            : aiModel // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        sentAt: freezed == sentAt
            ? _value.sentAt
            : sentAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deliveryStatus: freezed == deliveryStatus
            ? _value.deliveryStatus
            : deliveryStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageEntityImpl implements _MessageEntity {
  const _$MessageEntityImpl({
    required this.id,
    this.conversacionId,
    this.platformMessageId,
    required this.content,
    required this.messageType,
    final Map<String, dynamic>? mediaContext,
    this.isAiGenerated,
    this.aiModel,
    this.createdAt,
    this.sentAt,
    this.deliveryStatus,
  }) : _mediaContext = mediaContext;

  factory _$MessageEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageEntityImplFromJson(json);

  @override
  final String id;
  @override
  final String? conversacionId;
  @override
  final String? platformMessageId;
  @override
  final String content;
  @override
  final String messageType;
  final Map<String, dynamic>? _mediaContext;
  @override
  Map<String, dynamic>? get mediaContext {
    final value = _mediaContext;
    if (value == null) return null;
    if (_mediaContext is EqualUnmodifiableMapView) return _mediaContext;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final bool? isAiGenerated;
  @override
  final String? aiModel;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? sentAt;
  @override
  final String? deliveryStatus;

  @override
  String toString() {
    return 'MessageEntity(id: $id, conversacionId: $conversacionId, platformMessageId: $platformMessageId, content: $content, messageType: $messageType, mediaContext: $mediaContext, isAiGenerated: $isAiGenerated, aiModel: $aiModel, createdAt: $createdAt, sentAt: $sentAt, deliveryStatus: $deliveryStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversacionId, conversacionId) ||
                other.conversacionId == conversacionId) &&
            (identical(other.platformMessageId, platformMessageId) ||
                other.platformMessageId == platformMessageId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            const DeepCollectionEquality().equals(
              other._mediaContext,
              _mediaContext,
            ) &&
            (identical(other.isAiGenerated, isAiGenerated) ||
                other.isAiGenerated == isAiGenerated) &&
            (identical(other.aiModel, aiModel) || other.aiModel == aiModel) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt) &&
            (identical(other.deliveryStatus, deliveryStatus) ||
                other.deliveryStatus == deliveryStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    conversacionId,
    platformMessageId,
    content,
    messageType,
    const DeepCollectionEquality().hash(_mediaContext),
    isAiGenerated,
    aiModel,
    createdAt,
    sentAt,
    deliveryStatus,
  );

  /// Create a copy of MessageEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageEntityImplCopyWith<_$MessageEntityImpl> get copyWith =>
      __$$MessageEntityImplCopyWithImpl<_$MessageEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageEntityImplToJson(this);
  }
}

abstract class _MessageEntity implements MessageEntity {
  const factory _MessageEntity({
    required final String id,
    final String? conversacionId,
    final String? platformMessageId,
    required final String content,
    required final String messageType,
    final Map<String, dynamic>? mediaContext,
    final bool? isAiGenerated,
    final String? aiModel,
    final DateTime? createdAt,
    final DateTime? sentAt,
    final String? deliveryStatus,
  }) = _$MessageEntityImpl;

  factory _MessageEntity.fromJson(Map<String, dynamic> json) =
      _$MessageEntityImpl.fromJson;

  @override
  String get id;
  @override
  String? get conversacionId;
  @override
  String? get platformMessageId;
  @override
  String get content;
  @override
  String get messageType;
  @override
  Map<String, dynamic>? get mediaContext;
  @override
  bool? get isAiGenerated;
  @override
  String? get aiModel;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get sentAt;
  @override
  String? get deliveryStatus;

  /// Create a copy of MessageEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageEntityImplCopyWith<_$MessageEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preview_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PreviewEntityImpl _$$PreviewEntityImplFromJson(Map<String, dynamic> json) =>
    _$PreviewEntityImpl(
      id: json['id'] as String,
      type: json['type'] as String,
      topic: json['topic'] as String,
      style: json['style'] as String,
      targetAudience: json['targetAudience'] as String,
      referenceImage: json['referenceImage'] as String?,
      previewImage: json['previewImage'] as String,
      videoUrl: json['videoUrl'] as String?,
      caption: json['caption'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
      corrections: (json['corrections'] as List<dynamic>?)
          ?.map((e) => CorrectionEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      views: (json['views'] as num?)?.toInt(),
      likes: (json['likes'] as num?)?.toInt(),
      comments: (json['comments'] as num?)?.toInt(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PreviewEntityImplToJson(_$PreviewEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'topic': instance.topic,
      'style': instance.style,
      'targetAudience': instance.targetAudience,
      'referenceImage': instance.referenceImage,
      'previewImage': instance.previewImage,
      'videoUrl': instance.videoUrl,
      'caption': instance.caption,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'corrections': instance.corrections,
      'views': instance.views,
      'likes': instance.likes,
      'comments': instance.comments,
      'metadata': instance.metadata,
    };

_$CorrectionEntityImpl _$$CorrectionEntityImplFromJson(
  Map<String, dynamic> json,
) => _$CorrectionEntityImpl(
  id: json['id'] as String,
  previewId: json['previewId'] as String,
  type: json['type'] as String,
  description: json['description'] as String,
  status: json['status'] as String,
  visualFeedback: json['visualFeedback'] as String?,
  textChanges: json['textChanges'] as String?,
  styleChanges: json['styleChanges'] as String?,
  visualData: json['visualData'] as Map<String, dynamic>?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  appliedAt: json['appliedAt'] == null
      ? null
      : DateTime.parse(json['appliedAt'] as String),
);

Map<String, dynamic> _$$CorrectionEntityImplToJson(
  _$CorrectionEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'previewId': instance.previewId,
  'type': instance.type,
  'description': instance.description,
  'status': instance.status,
  'visualFeedback': instance.visualFeedback,
  'textChanges': instance.textChanges,
  'styleChanges': instance.styleChanges,
  'visualData': instance.visualData,
  'createdAt': instance.createdAt.toIso8601String(),
  'appliedAt': instance.appliedAt?.toIso8601String(),
};

_$CreatePreviewRequestImpl _$$CreatePreviewRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreatePreviewRequestImpl(
  topic: json['topic'] as String,
  style: json['style'] as String,
  targetAudience: json['targetAudience'] as String,
  referenceImage: json['referenceImage'] as String?,
);

Map<String, dynamic> _$$CreatePreviewRequestImplToJson(
  _$CreatePreviewRequestImpl instance,
) => <String, dynamic>{
  'topic': instance.topic,
  'style': instance.style,
  'targetAudience': instance.targetAudience,
  'referenceImage': instance.referenceImage,
};

_$CreateReelRequestImpl _$$CreateReelRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateReelRequestImpl(
  prompt: json['prompt'] as String,
  accent: json['accent'] as String?,
  style: json['style'] as String?,
  duration: (json['duration'] as num?)?.toInt(),
  targetAudience: json['targetAudience'] as String?,
);

Map<String, dynamic> _$$CreateReelRequestImplToJson(
  _$CreateReelRequestImpl instance,
) => <String, dynamic>{
  'prompt': instance.prompt,
  'accent': instance.accent,
  'style': instance.style,
  'duration': instance.duration,
  'targetAudience': instance.targetAudience,
};

_$ApplyCorrectionsRequestImpl _$$ApplyCorrectionsRequestImplFromJson(
  Map<String, dynamic> json,
) => _$ApplyCorrectionsRequestImpl(
  corrections: (json['corrections'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  visualFeedback: json['visualFeedback'] as String?,
  textChanges: json['textChanges'] as String?,
  styleChanges: json['styleChanges'] as String?,
);

Map<String, dynamic> _$$ApplyCorrectionsRequestImplToJson(
  _$ApplyCorrectionsRequestImpl instance,
) => <String, dynamic>{
  'corrections': instance.corrections,
  'visualFeedback': instance.visualFeedback,
  'textChanges': instance.textChanges,
  'styleChanges': instance.styleChanges,
};

_$PublishPreviewRequestImpl _$$PublishPreviewRequestImplFromJson(
  Map<String, dynamic> json,
) => _$PublishPreviewRequestImpl(finalCaption: json['finalCaption'] as String?);

Map<String, dynamic> _$$PublishPreviewRequestImplToJson(
  _$PublishPreviewRequestImpl instance,
) => <String, dynamic>{'finalCaption': instance.finalCaption};

_$PreviewsResponseImpl _$$PreviewsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$PreviewsResponseImpl(
  previews: (json['previews'] as List<dynamic>)
      .map((e) => PreviewEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  offset: (json['offset'] as num).toInt(),
  hasMore: json['hasMore'] as bool,
);

Map<String, dynamic> _$$PreviewsResponseImplToJson(
  _$PreviewsResponseImpl instance,
) => <String, dynamic>{
  'previews': instance.previews,
  'total': instance.total,
  'limit': instance.limit,
  'offset': instance.offset,
  'hasMore': instance.hasMore,
};

_$PreviewResponseImpl _$$PreviewResponseImplFromJson(
  Map<String, dynamic> json,
) => _$PreviewResponseImpl(
  preview: PreviewEntity.fromJson(json['preview'] as Map<String, dynamic>),
  suggestedCorrections: (json['suggestedCorrections'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$PreviewResponseImplToJson(
  _$PreviewResponseImpl instance,
) => <String, dynamic>{
  'preview': instance.preview,
  'suggestedCorrections': instance.suggestedCorrections,
  'metadata': instance.metadata,
};

_$BackendPreviewResponseImpl _$$BackendPreviewResponseImplFromJson(
  Map<String, dynamic> json,
) => _$BackendPreviewResponseImpl(
  success: json['success'] as bool,
  message: json['message'] as String,
  preview: BackendPreviewData.fromJson(json['preview'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$BackendPreviewResponseImplToJson(
  _$BackendPreviewResponseImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'preview': instance.preview,
};

_$BackendPreviewDataImpl _$$BackendPreviewDataImplFromJson(
  Map<String, dynamic> json,
) => _$BackendPreviewDataImpl(
  id: json['id'] as String,
  type: json['type'] as String,
  image_url: json['image_url'] as String,
  video_url: json['video_url'] as String?,
  suggested_caption: json['suggested_caption'],
);

Map<String, dynamic> _$$BackendPreviewDataImplToJson(
  _$BackendPreviewDataImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'image_url': instance.image_url,
  'video_url': instance.video_url,
  'suggested_caption': instance.suggested_caption,
};

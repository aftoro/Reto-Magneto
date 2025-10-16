import 'package:freezed_annotation/freezed_annotation.dart';

part 'preview_entity.freezed.dart';
part 'preview_entity.g.dart';

@freezed
class PreviewEntity with _$PreviewEntity {
  const factory PreviewEntity({
    required String id,
    required String type, // 'post', 'story', or 'reel'
    required String topic,
    required String style,
    required String targetAudience,
    String? referenceImage,
    required String previewImage,
    String? videoUrl, // For reels
    required String caption,
    required String status, // 'draft', 'published', 'processing'
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt,
    List<CorrectionEntity>? corrections,
    int? views,
    int? likes,
    int? comments,
    Map<String, dynamic>? metadata,
  }) = _PreviewEntity;

  factory PreviewEntity.fromJson(Map<String, dynamic> json) =>
      _$PreviewEntityFromJson(json);
}

@freezed
class CorrectionEntity with _$CorrectionEntity {
  const factory CorrectionEntity({
    required String id,
    required String previewId,
    required String type, // 'text', 'visual', 'style', 'general'
    required String description,
    required String status, // 'pending', 'applied', 'rejected'
    String? visualFeedback,
    String? textChanges,
    String? styleChanges,
    Map<String, dynamic>? visualData, // Para datos específicos de selección visual
    required DateTime createdAt,
    DateTime? appliedAt,
  }) = _CorrectionEntity;

  factory CorrectionEntity.fromJson(Map<String, dynamic> json) =>
      _$CorrectionEntityFromJson(json);
}

@freezed
class CreatePreviewRequest with _$CreatePreviewRequest {
  const factory CreatePreviewRequest({
    required String topic,
    required String style,
    required String targetAudience,
    String? referenceImage,
  }) = _CreatePreviewRequest;

  factory CreatePreviewRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePreviewRequestFromJson(json);
}

@freezed
class CreateReelRequest with _$CreateReelRequest {
  const factory CreateReelRequest({
    required String prompt, // Tema/contenido del reel
    String? accent, // Acento del audio (default: "neutral")
    String? style, // Estilo visual (default: "realista")
    int? duration, // Duración en segundos (default: 8, range: 3-8)
    String? targetAudience, // Audiencia objetivo (default: "desarrolladores y profesionales tech")
  }) = _CreateReelRequest;

  factory CreateReelRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReelRequestFromJson(json);
}

@freezed
class ApplyCorrectionsRequest with _$ApplyCorrectionsRequest {
  const factory ApplyCorrectionsRequest({
    required List<String> corrections,
    String? visualFeedback,
    String? textChanges,
    String? styleChanges,
  }) = _ApplyCorrectionsRequest;

  factory ApplyCorrectionsRequest.fromJson(Map<String, dynamic> json) =>
      _$ApplyCorrectionsRequestFromJson(json);
}

@freezed
class PublishPreviewRequest with _$PublishPreviewRequest {
  const factory PublishPreviewRequest({
    String? finalCaption,
  }) = _PublishPreviewRequest;

  factory PublishPreviewRequest.fromJson(Map<String, dynamic> json) =>
      _$PublishPreviewRequestFromJson(json);
}

@freezed
class PreviewsResponse with _$PreviewsResponse {
  const factory PreviewsResponse({
    required List<PreviewEntity> previews,
    required int total,
    required int limit,
    required int offset,
    required bool hasMore,
  }) = _PreviewsResponse;

  factory PreviewsResponse.fromJson(Map<String, dynamic> json) =>
      _$PreviewsResponseFromJson(json);
}

@freezed
class PreviewResponse with _$PreviewResponse {
  const factory PreviewResponse({
    required PreviewEntity preview,
    required List<String> suggestedCorrections,
    Map<String, dynamic>? metadata,
  }) = _PreviewResponse;

  factory PreviewResponse.fromJson(Map<String, dynamic> json) =>
      _$PreviewResponseFromJson(json);
}

// Respuesta específica del backend
@freezed
class BackendPreviewResponse with _$BackendPreviewResponse {
  const factory BackendPreviewResponse({
    required bool success,
    required String message,
    required BackendPreviewData preview,
  }) = _BackendPreviewResponse;

  factory BackendPreviewResponse.fromJson(Map<String, dynamic> json) =>
      _$BackendPreviewResponseFromJson(json);
}

@freezed
class BackendPreviewData with _$BackendPreviewData {
  const factory BackendPreviewData({
    required String id,
    required String type,
    required String image_url,
    String? video_url, // For reels
    required dynamic suggested_caption, // Changed to dynamic to handle both String and Map
  }) = _BackendPreviewData;

  factory BackendPreviewData.fromJson(Map<String, dynamic> json) =>
      _$BackendPreviewDataFromJson(json);
}

// Enums para opciones de UI
enum PreviewType {
  post('post', 'Post'),
  story('story', 'Story'),
  reel('reel', 'Reel');

  const PreviewType(this.value, this.label);
  final String value;
  final String label;
}

enum PreviewStyle {
  modern('modern', 'Moderno y Profesional'),
  dynamic('dynamic', 'Dinámico y Atractivo'),
  minimalist('minimalist', 'Minimalista');

  const PreviewStyle(this.value, this.label);
  final String value;
  final String label;
}

enum TargetAudience {
  jobSeekers('job_seekers', 'Buscadores de Empleo'),
  recentGraduates('recent_graduates', 'Recién Egresados'),
  professionals('professionals', 'Profesionales Experimentados'),
  executives('executives', 'Ejecutivos y Directivos'),
  freelancers('freelancers', 'Freelancers y Consultores'),
  entrepreneurs('entrepreneurs', 'Emprendedores'),
  students('students', 'Estudiantes Universitarios'),
  careerChangers('career_changers', 'Cambio de Carrera'),
  remoteWorkers('remote_workers', 'Trabajadores Remotos'),
  techProfessionals('tech_professionals', 'Profesionales de Tecnología'),
  salesProfessionals('sales_professionals', 'Profesionales de Ventas'),
  marketingProfessionals('marketing_professionals', 'Profesionales de Marketing'),
  hrProfessionals('hr_professionals', 'Profesionales de RRHH'),
  financeProfessionals('finance_professionals', 'Profesionales Financieros'),
  healthcareProfessionals('healthcare_professionals', 'Profesionales de Salud'),
  educationProfessionals('education_professionals', 'Profesionales de Educación'),
  creativeProfessionals('creative_professionals', 'Profesionales Creativos'),
  manufacturingWorkers('manufacturing_workers', 'Trabajadores de Manufactura'),
  retailWorkers('retail_workers', 'Trabajadores de Retail'),
  serviceWorkers('service_workers', 'Trabajadores de Servicios');

  const TargetAudience(this.value, this.label);
  final String value;
  final String label;
}

enum PreviewStatus {
  draft('draft', 'Borrador'),
  processing('processing', 'Procesando'),
  published('published', 'Publicado'),
  failed('failed', 'Error');

  const PreviewStatus(this.value, this.label);
  final String value;
  final String label;
}

enum CorrectionType {
  text('text', 'Texto'),
  visual('visual', 'Visual'),
  style('style', 'Estilo'),
  general('general', 'General');

  const CorrectionType(this.value, this.label);
  final String value;
  final String label;
}

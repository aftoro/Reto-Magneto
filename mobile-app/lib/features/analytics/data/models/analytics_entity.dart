import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_entity.freezed.dart';
part 'analytics_entity.g.dart';

@freezed
class AnalyticsEntity with _$AnalyticsEntity {
  const factory AnalyticsEntity({
    required String timestamp,
    required DataRangeEntity dataRange,
    required PostsAnalyticsEntity posts,
    required ConversationsAnalyticsEntity conversations,
    required AIInsightsEntity aiInsights,
  }) = _AnalyticsEntity;

  factory AnalyticsEntity.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsEntityFromJson(json);

  factory AnalyticsEntity.fromApiJson(Map<String, dynamic> data) {
    return AnalyticsEntity(
      timestamp: data['timestamp']?.toString() ?? DateTime.now().toIso8601String(),
      dataRange: DataRangeEntity.fromApiJson(data['dataRange'] ?? {}),
      posts: PostsAnalyticsEntity.fromApiJson(data['posts'] ?? {}),
      conversations: ConversationsAnalyticsEntity.fromApiJson(data['conversations'] ?? {}),
      aiInsights: AIInsightsEntity.fromApiJson(data['aiInsights'] ?? {}),
    );
  }
}

@freezed
class DataRangeEntity with _$DataRangeEntity {
  const factory DataRangeEntity({
    required int postsAnalyzed,
    required int conversationsAnalyzed,
    required String period,
  }) = _DataRangeEntity;

  factory DataRangeEntity.fromJson(Map<String, dynamic> json) =>
      _$DataRangeEntityFromJson(json);

  factory DataRangeEntity.fromApiJson(Map<String, dynamic> data) {
    return DataRangeEntity(
      postsAnalyzed: data['postsAnalyzed'] as int? ?? 0,
      conversationsAnalyzed: data['conversationsAnalyzed'] as int? ?? 0,
      period: data['period']?.toString() ?? '',
    );
  }
}

@freezed
class PostsAnalyticsEntity with _$PostsAnalyticsEntity {
  const factory PostsAnalyticsEntity({
    required PostsSummaryEntity summary,
    required List<TopSectorEntity> topSectors,
    required List<TopPositionEntity> topPositions,
    required List<RecentPostEntity> recentPosts,
  }) = _PostsAnalyticsEntity;

  factory PostsAnalyticsEntity.fromJson(Map<String, dynamic> json) =>
      _$PostsAnalyticsEntityFromJson(json);

  factory PostsAnalyticsEntity.fromApiJson(Map<String, dynamic> data) {
    return PostsAnalyticsEntity(
      summary: PostsSummaryEntity.fromApiJson(data['summary'] ?? {}),
      topSectors: (data['topSectors'] as List?)
          ?.map((item) => TopSectorEntity.fromApiJson(item))
          .toList() ?? [],
      topPositions: (data['topPositions'] as List?)
          ?.map((item) => TopPositionEntity.fromApiJson(item))
          .toList() ?? [],
      recentPosts: (data['recentPosts'] as List?)
          ?.map((item) => RecentPostEntity.fromApiJson(item))
          .toList() ?? [],
    );
  }
}

@freezed
class PostsSummaryEntity with _$PostsSummaryEntity {
  const factory PostsSummaryEntity({
    required int totalPosts,
    required int totalComments,
    required int totalLikes,
    required double avgEngagement,
    required int aiResponses,
    required int userComments,
  }) = _PostsSummaryEntity;

  factory PostsSummaryEntity.fromJson(Map<String, dynamic> json) =>
      _$PostsSummaryEntityFromJson(json);

  factory PostsSummaryEntity.fromApiJson(Map<String, dynamic> data) {
    return PostsSummaryEntity(
      totalPosts: data['totalPosts'] as int? ?? 0,
      totalComments: data['totalComments'] as int? ?? 0,
      totalLikes: data['totalLikes'] as int? ?? 0,
      avgEngagement: (data['avgEngagement'] as num?)?.toDouble() ?? 0.0,
      aiResponses: data['aiResponses'] as int? ?? 0,
      userComments: data['userComments'] as int? ?? 0,
    );
  }
}

@freezed
class TopSectorEntity with _$TopSectorEntity {
  const factory TopSectorEntity({
    required String sector,
    required int count,
  }) = _TopSectorEntity;

  factory TopSectorEntity.fromJson(Map<String, dynamic> json) =>
      _$TopSectorEntityFromJson(json);

  factory TopSectorEntity.fromApiJson(Map<String, dynamic> data) {
    return TopSectorEntity(
      sector: data['sector']?.toString() ?? '',
      count: data['count'] as int? ?? 0,
    );
  }
}

@freezed
class TopPositionEntity with _$TopPositionEntity {
  const factory TopPositionEntity({
    required String position,
    required int count,
  }) = _TopPositionEntity;

  factory TopPositionEntity.fromJson(Map<String, dynamic> json) =>
      _$TopPositionEntityFromJson(json);

  factory TopPositionEntity.fromApiJson(Map<String, dynamic> data) {
    return TopPositionEntity(
      position: data['position']?.toString() ?? '',
      count: data['count'] as int? ?? 0,
    );
  }
}

@freezed
class RecentPostEntity with _$RecentPostEntity {
  const factory RecentPostEntity({
    required String id,
    required String caption,
    required int comments,
    required int likes,
    required DateTime createdAt,
  }) = _RecentPostEntity;

  factory RecentPostEntity.fromJson(Map<String, dynamic> json) =>
      _$RecentPostEntityFromJson(json);

  factory RecentPostEntity.fromApiJson(Map<String, dynamic> data) {
    return RecentPostEntity(
      id: data['id']?.toString() ?? '',
      caption: data['caption']?.toString() ?? '',
      comments: data['comments'] as int? ?? 0,
      likes: data['likes'] as int? ?? 0,
      createdAt: data['createdAt'] != null 
          ? DateTime.tryParse(data['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

@freezed
class ConversationsAnalyticsEntity with _$ConversationsAnalyticsEntity {
  const factory ConversationsAnalyticsEntity({
    required ConversationsSummaryEntity summary,
    required List<TopProfessionEntity> topProfessions,
    required List<TopLocationEntity> topLocations,
    required List<ExperienceDistributionEntity> experienceDistribution,
  }) = _ConversationsAnalyticsEntity;

  factory ConversationsAnalyticsEntity.fromJson(Map<String, dynamic> json) =>
      _$ConversationsAnalyticsEntityFromJson(json);

  factory ConversationsAnalyticsEntity.fromApiJson(Map<String, dynamic> data) {
    return ConversationsAnalyticsEntity(
      summary: ConversationsSummaryEntity.fromApiJson(data['summary'] ?? {}),
      topProfessions: (data['topProfessions'] as List?)
          ?.map((item) => TopProfessionEntity.fromApiJson(item))
          .toList() ?? [],
      topLocations: (data['topLocations'] as List?)
          ?.map((item) => TopLocationEntity.fromApiJson(item))
          .toList() ?? [],
      experienceDistribution: (data['experienceDistribution'] as List?)
          ?.map((item) => ExperienceDistributionEntity.fromApiJson(item))
          .toList() ?? [],
    );
  }
}

@freezed
class ConversationsSummaryEntity with _$ConversationsSummaryEntity {
  const factory ConversationsSummaryEntity({
    required int totalConversations,
    required int activeConversations,
    required double avgCompletion,
    required MessageStatsEntity messageStats,
  }) = _ConversationsSummaryEntity;

  factory ConversationsSummaryEntity.fromJson(Map<String, dynamic> json) =>
      _$ConversationsSummaryEntityFromJson(json);

  factory ConversationsSummaryEntity.fromApiJson(Map<String, dynamic> data) {
    return ConversationsSummaryEntity(
      totalConversations: data['totalConversations'] as int? ?? 0,
      activeConversations: data['activeConversations'] as int? ?? 0,
      avgCompletion: (data['avgCompletion'] as num?)?.toDouble() ?? 0.0,
      messageStats: MessageStatsEntity.fromApiJson(data['messageStats'] ?? {}),
    );
  }
}

@freezed
class MessageStatsEntity with _$MessageStatsEntity {
  const factory MessageStatsEntity({
    required int total,
    required int aiGenerated,
    required int userGenerated,
    required int aiRatio,
  }) = _MessageStatsEntity;

  factory MessageStatsEntity.fromJson(Map<String, dynamic> json) =>
      _$MessageStatsEntityFromJson(json);

  factory MessageStatsEntity.fromApiJson(Map<String, dynamic> data) {
    return MessageStatsEntity(
      total: data['total'] as int? ?? 0,
      aiGenerated: data['aiGenerated'] as int? ?? 0,
      userGenerated: data['userGenerated'] as int? ?? 0,
      aiRatio: data['aiRatio'] as int? ?? 0,
    );
  }
}

@freezed
class TopProfessionEntity with _$TopProfessionEntity {
  const factory TopProfessionEntity({
    required String profession,
    required int count,
  }) = _TopProfessionEntity;

  factory TopProfessionEntity.fromJson(Map<String, dynamic> json) =>
      _$TopProfessionEntityFromJson(json);

  factory TopProfessionEntity.fromApiJson(Map<String, dynamic> data) {
    return TopProfessionEntity(
      profession: data['profession']?.toString() ?? '',
      count: data['count'] as int? ?? 0,
    );
  }
}

@freezed
class TopLocationEntity with _$TopLocationEntity {
  const factory TopLocationEntity({
    required String location,
    required int count,
  }) = _TopLocationEntity;

  factory TopLocationEntity.fromJson(Map<String, dynamic> json) =>
      _$TopLocationEntityFromJson(json);

  factory TopLocationEntity.fromApiJson(Map<String, dynamic> data) {
    return TopLocationEntity(
      location: data['location']?.toString() ?? '',
      count: data['count'] as int? ?? 0,
    );
  }
}

@freezed
class ExperienceDistributionEntity with _$ExperienceDistributionEntity {
  const factory ExperienceDistributionEntity({
    required String level,
    required int count,
  }) = _ExperienceDistributionEntity;

  factory ExperienceDistributionEntity.fromJson(Map<String, dynamic> json) =>
      _$ExperienceDistributionEntityFromJson(json);

  factory ExperienceDistributionEntity.fromApiJson(Map<String, dynamic> data) {
    return ExperienceDistributionEntity(
      level: data['level']?.toString() ?? '',
      count: data['count'] as int? ?? 0,
    );
  }
}

@freezed
class AIInsightsEntity with _$AIInsightsEntity {
  const factory AIInsightsEntity({
    required MarketTrendsEntity marketTrends,
    required UserBehaviorEntity userBehavior,
    required List<String> recommendations,
    required List<String> insights,
  }) = _AIInsightsEntity;

  factory AIInsightsEntity.fromJson(Map<String, dynamic> json) =>
      _$AIInsightsEntityFromJson(json);

  factory AIInsightsEntity.fromApiJson(Map<String, dynamic> data) {
    return AIInsightsEntity(
      marketTrends: MarketTrendsEntity.fromApiJson(data['marketTrends'] ?? {}),
      userBehavior: UserBehaviorEntity.fromApiJson(data['userBehavior'] ?? {}),
      recommendations: (data['recommendations'] as List?)
          ?.map((item) => item.toString())
          .toList() ?? [],
      insights: (data['insights'] as List?)
          ?.map((item) => item.toString())
          .toList() ?? [],
    );
  }
}

@freezed
class MarketTrendsEntity with _$MarketTrendsEntity {
  const factory MarketTrendsEntity({
    required List<String> hotSectors,
    required String demandPatterns,
    required String growthOpportunities,
  }) = _MarketTrendsEntity;

  factory MarketTrendsEntity.fromJson(Map<String, dynamic> json) =>
      _$MarketTrendsEntityFromJson(json);

  factory MarketTrendsEntity.fromApiJson(Map<String, dynamic> data) {
    return MarketTrendsEntity(
      hotSectors: (data['hotSectors'] as List?)
          ?.map((item) => item.toString())
          .toList() ?? [],
      demandPatterns: data['demandPatterns']?.toString() ?? '',
      growthOpportunities: data['growthOpportunities']?.toString() ?? '',
    );
  }
}

@freezed
class UserBehaviorEntity with _$UserBehaviorEntity {
  const factory UserBehaviorEntity({
    required String engagementLevel,
    required String profileCompletion,
    required String interactionPatterns,
  }) = _UserBehaviorEntity;

  factory UserBehaviorEntity.fromJson(Map<String, dynamic> json) =>
      _$UserBehaviorEntityFromJson(json);

  factory UserBehaviorEntity.fromApiJson(Map<String, dynamic> data) {
    return UserBehaviorEntity(
      engagementLevel: data['engagementLevel']?.toString() ?? '',
      profileCompletion: data['profileCompletion']?.toString() ?? '',
      interactionPatterns: data['interactionPatterns']?.toString() ?? '',
    );
  }
}

@freezed
class AnalyticsResponse with _$AnalyticsResponse {
  const factory AnalyticsResponse({
    required bool success,
    required String message,
    required AnalyticsEntity analytics,
  }) = _AnalyticsResponse;

  factory AnalyticsResponse.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsResponseFromJson(json);

  factory AnalyticsResponse.fromApiJson(Map<String, dynamic> data) {
    return AnalyticsResponse(
      success: data['success'] as bool? ?? false,
      message: data['message']?.toString() ?? '',
      analytics: AnalyticsEntity.fromApiJson(data['analytics'] ?? {}),
    );
  }
}

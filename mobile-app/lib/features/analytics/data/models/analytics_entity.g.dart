// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnalyticsEntityImpl _$$AnalyticsEntityImplFromJson(
  Map<String, dynamic> json,
) => _$AnalyticsEntityImpl(
  timestamp: json['timestamp'] as String,
  dataRange: DataRangeEntity.fromJson(
    json['dataRange'] as Map<String, dynamic>,
  ),
  posts: PostsAnalyticsEntity.fromJson(json['posts'] as Map<String, dynamic>),
  conversations: ConversationsAnalyticsEntity.fromJson(
    json['conversations'] as Map<String, dynamic>,
  ),
  aiInsights: AIInsightsEntity.fromJson(
    json['aiInsights'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$AnalyticsEntityImplToJson(
  _$AnalyticsEntityImpl instance,
) => <String, dynamic>{
  'timestamp': instance.timestamp,
  'dataRange': instance.dataRange,
  'posts': instance.posts,
  'conversations': instance.conversations,
  'aiInsights': instance.aiInsights,
};

_$DataRangeEntityImpl _$$DataRangeEntityImplFromJson(
  Map<String, dynamic> json,
) => _$DataRangeEntityImpl(
  postsAnalyzed: (json['postsAnalyzed'] as num).toInt(),
  conversationsAnalyzed: (json['conversationsAnalyzed'] as num).toInt(),
  period: json['period'] as String,
);

Map<String, dynamic> _$$DataRangeEntityImplToJson(
  _$DataRangeEntityImpl instance,
) => <String, dynamic>{
  'postsAnalyzed': instance.postsAnalyzed,
  'conversationsAnalyzed': instance.conversationsAnalyzed,
  'period': instance.period,
};

_$PostsAnalyticsEntityImpl _$$PostsAnalyticsEntityImplFromJson(
  Map<String, dynamic> json,
) => _$PostsAnalyticsEntityImpl(
  summary: PostsSummaryEntity.fromJson(json['summary'] as Map<String, dynamic>),
  topSectors: (json['topSectors'] as List<dynamic>)
      .map((e) => TopSectorEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
  topPositions: (json['topPositions'] as List<dynamic>)
      .map((e) => TopPositionEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
  recentPosts: (json['recentPosts'] as List<dynamic>)
      .map((e) => RecentPostEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$PostsAnalyticsEntityImplToJson(
  _$PostsAnalyticsEntityImpl instance,
) => <String, dynamic>{
  'summary': instance.summary,
  'topSectors': instance.topSectors,
  'topPositions': instance.topPositions,
  'recentPosts': instance.recentPosts,
};

_$PostsSummaryEntityImpl _$$PostsSummaryEntityImplFromJson(
  Map<String, dynamic> json,
) => _$PostsSummaryEntityImpl(
  totalPosts: (json['totalPosts'] as num).toInt(),
  totalComments: (json['totalComments'] as num).toInt(),
  totalLikes: (json['totalLikes'] as num).toInt(),
  avgEngagement: (json['avgEngagement'] as num).toDouble(),
  aiResponses: (json['aiResponses'] as num).toInt(),
  userComments: (json['userComments'] as num).toInt(),
);

Map<String, dynamic> _$$PostsSummaryEntityImplToJson(
  _$PostsSummaryEntityImpl instance,
) => <String, dynamic>{
  'totalPosts': instance.totalPosts,
  'totalComments': instance.totalComments,
  'totalLikes': instance.totalLikes,
  'avgEngagement': instance.avgEngagement,
  'aiResponses': instance.aiResponses,
  'userComments': instance.userComments,
};

_$TopSectorEntityImpl _$$TopSectorEntityImplFromJson(
  Map<String, dynamic> json,
) => _$TopSectorEntityImpl(
  sector: json['sector'] as String,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$$TopSectorEntityImplToJson(
  _$TopSectorEntityImpl instance,
) => <String, dynamic>{'sector': instance.sector, 'count': instance.count};

_$TopPositionEntityImpl _$$TopPositionEntityImplFromJson(
  Map<String, dynamic> json,
) => _$TopPositionEntityImpl(
  position: json['position'] as String,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$$TopPositionEntityImplToJson(
  _$TopPositionEntityImpl instance,
) => <String, dynamic>{'position': instance.position, 'count': instance.count};

_$RecentPostEntityImpl _$$RecentPostEntityImplFromJson(
  Map<String, dynamic> json,
) => _$RecentPostEntityImpl(
  id: json['id'] as String,
  caption: json['caption'] as String,
  comments: (json['comments'] as num).toInt(),
  likes: (json['likes'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$RecentPostEntityImplToJson(
  _$RecentPostEntityImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'caption': instance.caption,
  'comments': instance.comments,
  'likes': instance.likes,
  'createdAt': instance.createdAt.toIso8601String(),
};

_$ConversationsAnalyticsEntityImpl _$$ConversationsAnalyticsEntityImplFromJson(
  Map<String, dynamic> json,
) => _$ConversationsAnalyticsEntityImpl(
  summary: ConversationsSummaryEntity.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
  topProfessions: (json['topProfessions'] as List<dynamic>)
      .map((e) => TopProfessionEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
  topLocations: (json['topLocations'] as List<dynamic>)
      .map((e) => TopLocationEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
  experienceDistribution: (json['experienceDistribution'] as List<dynamic>)
      .map(
        (e) => ExperienceDistributionEntity.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$$ConversationsAnalyticsEntityImplToJson(
  _$ConversationsAnalyticsEntityImpl instance,
) => <String, dynamic>{
  'summary': instance.summary,
  'topProfessions': instance.topProfessions,
  'topLocations': instance.topLocations,
  'experienceDistribution': instance.experienceDistribution,
};

_$ConversationsSummaryEntityImpl _$$ConversationsSummaryEntityImplFromJson(
  Map<String, dynamic> json,
) => _$ConversationsSummaryEntityImpl(
  totalConversations: (json['totalConversations'] as num).toInt(),
  activeConversations: (json['activeConversations'] as num).toInt(),
  avgCompletion: (json['avgCompletion'] as num).toDouble(),
  messageStats: MessageStatsEntity.fromJson(
    json['messageStats'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$ConversationsSummaryEntityImplToJson(
  _$ConversationsSummaryEntityImpl instance,
) => <String, dynamic>{
  'totalConversations': instance.totalConversations,
  'activeConversations': instance.activeConversations,
  'avgCompletion': instance.avgCompletion,
  'messageStats': instance.messageStats,
};

_$MessageStatsEntityImpl _$$MessageStatsEntityImplFromJson(
  Map<String, dynamic> json,
) => _$MessageStatsEntityImpl(
  total: (json['total'] as num).toInt(),
  aiGenerated: (json['aiGenerated'] as num).toInt(),
  userGenerated: (json['userGenerated'] as num).toInt(),
  aiRatio: (json['aiRatio'] as num).toInt(),
);

Map<String, dynamic> _$$MessageStatsEntityImplToJson(
  _$MessageStatsEntityImpl instance,
) => <String, dynamic>{
  'total': instance.total,
  'aiGenerated': instance.aiGenerated,
  'userGenerated': instance.userGenerated,
  'aiRatio': instance.aiRatio,
};

_$TopProfessionEntityImpl _$$TopProfessionEntityImplFromJson(
  Map<String, dynamic> json,
) => _$TopProfessionEntityImpl(
  profession: json['profession'] as String,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$$TopProfessionEntityImplToJson(
  _$TopProfessionEntityImpl instance,
) => <String, dynamic>{
  'profession': instance.profession,
  'count': instance.count,
};

_$TopLocationEntityImpl _$$TopLocationEntityImplFromJson(
  Map<String, dynamic> json,
) => _$TopLocationEntityImpl(
  location: json['location'] as String,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$$TopLocationEntityImplToJson(
  _$TopLocationEntityImpl instance,
) => <String, dynamic>{'location': instance.location, 'count': instance.count};

_$ExperienceDistributionEntityImpl _$$ExperienceDistributionEntityImplFromJson(
  Map<String, dynamic> json,
) => _$ExperienceDistributionEntityImpl(
  level: json['level'] as String,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$$ExperienceDistributionEntityImplToJson(
  _$ExperienceDistributionEntityImpl instance,
) => <String, dynamic>{'level': instance.level, 'count': instance.count};

_$AIInsightsEntityImpl _$$AIInsightsEntityImplFromJson(
  Map<String, dynamic> json,
) => _$AIInsightsEntityImpl(
  marketTrends: MarketTrendsEntity.fromJson(
    json['marketTrends'] as Map<String, dynamic>,
  ),
  userBehavior: UserBehaviorEntity.fromJson(
    json['userBehavior'] as Map<String, dynamic>,
  ),
  recommendations: (json['recommendations'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  insights: (json['insights'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$AIInsightsEntityImplToJson(
  _$AIInsightsEntityImpl instance,
) => <String, dynamic>{
  'marketTrends': instance.marketTrends,
  'userBehavior': instance.userBehavior,
  'recommendations': instance.recommendations,
  'insights': instance.insights,
};

_$MarketTrendsEntityImpl _$$MarketTrendsEntityImplFromJson(
  Map<String, dynamic> json,
) => _$MarketTrendsEntityImpl(
  hotSectors: (json['hotSectors'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  demandPatterns: json['demandPatterns'] as String,
  growthOpportunities: json['growthOpportunities'] as String,
);

Map<String, dynamic> _$$MarketTrendsEntityImplToJson(
  _$MarketTrendsEntityImpl instance,
) => <String, dynamic>{
  'hotSectors': instance.hotSectors,
  'demandPatterns': instance.demandPatterns,
  'growthOpportunities': instance.growthOpportunities,
};

_$UserBehaviorEntityImpl _$$UserBehaviorEntityImplFromJson(
  Map<String, dynamic> json,
) => _$UserBehaviorEntityImpl(
  engagementLevel: json['engagementLevel'] as String,
  profileCompletion: json['profileCompletion'] as String,
  interactionPatterns: json['interactionPatterns'] as String,
);

Map<String, dynamic> _$$UserBehaviorEntityImplToJson(
  _$UserBehaviorEntityImpl instance,
) => <String, dynamic>{
  'engagementLevel': instance.engagementLevel,
  'profileCompletion': instance.profileCompletion,
  'interactionPatterns': instance.interactionPatterns,
};

_$AnalyticsResponseImpl _$$AnalyticsResponseImplFromJson(
  Map<String, dynamic> json,
) => _$AnalyticsResponseImpl(
  success: json['success'] as bool,
  message: json['message'] as String,
  analytics: AnalyticsEntity.fromJson(
    json['analytics'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$AnalyticsResponseImplToJson(
  _$AnalyticsResponseImpl instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'analytics': instance.analytics,
};

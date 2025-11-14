import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/analytics_entity.dart';
import '../../../instagram/data/datasources/instagram_api_service.dart';

class StatsOverviewCard extends StatelessWidget {
  final AnalyticsEntity analytics;

  const StatsOverviewCard({
    super.key,
    required this.analytics,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        gradient: AppConstants.brandGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withOpacity(0.35),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.dashboard,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: AppConstants.spacingS),
              const Text(
                'Resumen General',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingS,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Últimos ${analytics.dataRange.postsAnalyzed} posts',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingL),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Posts',
                  analytics.posts.summary.totalPosts.toString(),
                  'assets/icons/media.svg',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Conversaciones',
                  analytics.conversations.summary.totalConversations.toString(),
                  'assets/icons/chat.svg',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Engagement',
                  '${analytics.posts.summary.avgEngagement.toStringAsFixed(1)}%',
                  CupertinoIcons.arrow_up_right,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Usuarios Activos',
                  analytics.conversations.summary.activeConversations.toString(),
                  'assets/icons/users.svg',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Completitud',
                  '${analytics.conversations.summary.avgCompletion.toStringAsFixed(1)}%',
                  CupertinoIcons.checkmark_circle,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'IA Ratio',
                  '${analytics.conversations.summary.messageStats.aiRatio}%',
                  CupertinoIcons.chart_pie_fill,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          // Likes totales de todos los posts
          FutureBuilder<int>(
            future: _getLikesSummary(),
            builder: (context, snapshot) {
              final likesCount = snapshot.data ?? 0;
              return Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Likes totales',
                      likesCount.toString(),
                      'assets/icons/like.svg',
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<int> _getLikesSummary() async {
    try {
      final apiService = InstagramApiService();
      return await apiService.getLikesSummary();
    } catch (e) {
      print('Error obteniendo resumen de likes: $e');
      return 0;
    }
  }

  Widget _buildStatItem(String label, String value, dynamic icon) {
    return Column(
      children: [
        icon is String
            ? SvgPicture.asset(
                icon,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.8),
                  BlendMode.srcIn,
                ),
              )
            : Icon(
                icon as IconData,
                color: Colors.white.withOpacity(0.8),
                size: 20,
              ),
        const SizedBox(height: AppConstants.spacingS),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

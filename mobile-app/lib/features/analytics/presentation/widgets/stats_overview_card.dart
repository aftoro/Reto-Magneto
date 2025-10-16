import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/analytics_entity.dart';

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
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
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
                  Icons.article_outlined,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Conversaciones',
                  analytics.conversations.summary.totalConversations.toString(),
                  Icons.chat_bubble_outline,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Engagement',
                  '${analytics.posts.summary.avgEngagement.toStringAsFixed(1)}%',
                  Icons.trending_up,
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
                  Icons.people_outline,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Completitud',
                  '${analytics.conversations.summary.avgCompletion.toStringAsFixed(1)}%',
                  Icons.check_circle_outline,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'IA Ratio',
                  '${analytics.conversations.summary.messageStats.aiRatio}%',
                  Icons.smart_toy_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
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

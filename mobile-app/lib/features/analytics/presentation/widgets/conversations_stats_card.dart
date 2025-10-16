import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/analytics_entity.dart';

class ConversationsStatsCard extends StatelessWidget {
  final AnalyticsEntity analytics;

  const ConversationsStatsCard({
    super.key,
    required this.analytics,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2D2D2D),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.chat_bubble_outline,
                color: Color(0xFF8B5CF6),
                size: 24,
              ),
              const SizedBox(width: AppConstants.spacingS),
              const Text(
                'Estadísticas de Conversaciones',
                style: TextStyle(
                  color: Color(0xFFE5E7EB),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingL),
          
          // Estadísticas principales
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Total',
                  analytics.conversations.summary.totalConversations.toString(),
                  Icons.chat,
                  const Color(0xFF8B5CF6),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Activas',
                  analytics.conversations.summary.activeConversations.toString(),
                  Icons.chat_bubble,
                  const Color(0xFF10B981),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Completitud',
                  '${analytics.conversations.summary.avgCompletion.toStringAsFixed(1)}%',
                  Icons.check_circle,
                  const Color(0xFF3B82F6),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingL),
          
          // Top profesiones
          _buildTopProfessions(),
          const SizedBox(height: AppConstants.spacingM),
          
          // Top ubicaciones
          _buildTopLocations(),
          const SizedBox(height: AppConstants.spacingM),
          
          // Distribución de experiencia
          _buildExperienceDistribution(),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: AppConstants.spacingS),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTopProfessions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profesiones Más Activas',
          style: TextStyle(
            color: Color(0xFFE5E7EB),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.spacingS),
        ...analytics.conversations.topProfessions.take(3).map((profession) => 
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B5CF6),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingS),
                Expanded(
                  child: Text(
                    profession.profession,
                    style: const TextStyle(
                      color: Color(0xFFE5E7EB),
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  '${profession.count}',
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ).toList(),
      ],
    );
  }

  Widget _buildTopLocations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ubicaciones Más Activas',
          style: TextStyle(
            color: Color(0xFFE5E7EB),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.spacingS),
        ...analytics.conversations.topLocations.take(3).map((location) => 
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingS),
                Expanded(
                  child: Text(
                    location.location,
                    style: const TextStyle(
                      color: Color(0xFFE5E7EB),
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  '${location.count}',
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ).toList(),
      ],
    );
  }

  Widget _buildExperienceDistribution() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Distribución por Experiencia',
          style: TextStyle(
            color: Color(0xFFE5E7EB),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.spacingS),
        ...analytics.conversations.experienceDistribution.take(3).map((exp) => 
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3B82F6),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingS),
                Expanded(
                  child: Text(
                    exp.level,
                    style: const TextStyle(
                      color: Color(0xFFE5E7EB),
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  '${exp.count}',
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ).toList(),
      ],
    );
  }
}

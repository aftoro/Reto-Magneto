import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
        color: Colors.white, // Fondo blanco para light mode
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB), // Borde gris claro
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // Sombra suave para light mode
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/chat.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF8B5CF6),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: AppConstants.spacingS),
              const Text(
                'Estadísticas de Conversaciones',
                style: TextStyle(
                  color: AppConstants.textPrimary, // Texto negro para light mode
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
                  'assets/icons/chat.svg',
                  const Color(0xFF8B5CF6),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Activas',
                  analytics.conversations.summary.activeConversations.toString(),
                  'assets/icons/chat.svg',
                  const Color(0xFF10B981),
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Completitud',
                  '${analytics.conversations.summary.avgCompletion.toStringAsFixed(1)}%',
                  CupertinoIcons.check_mark_circled_solid,
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

  Widget _buildStatItem(String label, String value, dynamic icon, Color color) {
    return Column(
      children: [
        icon is String
            ? SvgPicture.asset(
                icon,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  color,
                  BlendMode.srcIn,
                ),
              )
            : Icon(
                icon as IconData,
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
            color: AppConstants.textSecondary, // Gris medio para light mode
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
            color: AppConstants.textPrimary, // Texto negro para light mode
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
                      color: AppConstants.textPrimary, // Texto negro para light mode
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  '${profession.count}',
                  style: const TextStyle(
                    color: AppConstants.textSecondary, // Gris medio para light mode
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
            color: AppConstants.textPrimary, // Texto negro para light mode
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
                      color: AppConstants.textPrimary, // Texto negro para light mode
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  '${location.count}',
                  style: const TextStyle(
                    color: AppConstants.textSecondary, // Gris medio para light mode
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
            color: AppConstants.textPrimary, // Texto negro para light mode
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
                      color: AppConstants.textPrimary, // Texto negro para light mode
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  '${exp.count}',
                  style: const TextStyle(
                    color: AppConstants.textSecondary, // Gris medio para light mode
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

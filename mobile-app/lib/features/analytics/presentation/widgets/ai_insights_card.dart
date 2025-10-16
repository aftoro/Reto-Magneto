import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/analytics_entity.dart';

class AIInsightsCard extends StatelessWidget {
  final AIInsightsEntity insights;

  const AIInsightsCard({
    super.key,
    required this.insights,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withOpacity(0.3),
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
                Icons.psychology,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: AppConstants.spacingS),
              const Text(
                'Análisis de IA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingL),
          
          // Tendencias del mercado
          _buildInsightSection(
            'Tendencias del Mercado',
            Icons.trending_up,
            [
              'Sectores calientes: ${insights.marketTrends.hotSectors.join(', ')}',
              insights.marketTrends.demandPatterns,
              insights.marketTrends.growthOpportunities,
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          
          // Comportamiento de usuarios
          _buildInsightSection(
            'Comportamiento de Usuarios',
            Icons.people,
            [
              insights.userBehavior.engagementLevel,
              insights.userBehavior.profileCompletion,
              insights.userBehavior.interactionPatterns,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightSection(String title, IconData icon, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.white.withOpacity(0.8),
              size: 16,
            ),
            const SizedBox(width: AppConstants.spacingS),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingS),
        ...items.map((item) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: 4,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppConstants.spacingS),
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/analytics_entity.dart';

class TopSectorsCard extends StatelessWidget {
  final List<TopSectorEntity> sectors;

  const TopSectorsCard({
    super.key,
    required this.sectors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
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
                Icons.business,
                color: Color(0xFF3B82F6),
                size: 20,
              ),
              const SizedBox(width: AppConstants.spacingS),
              const Text(
                'Sectores Más Populares',
                style: TextStyle(
                  color: Color(0xFFE5E7EB),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          ...sectors.take(5).map((sector) => _buildSectorItem(sector)).toList(),
        ],
      ),
    );
  }

  Widget _buildSectorItem(TopSectorEntity sector) {
    final totalCount = sectors.fold<int>(0, (sum, item) => sum + item.count);
    final percentage = totalCount > 0 ? (sector.count / totalCount * 100) : 0.0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingS),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              sector.sector,
              style: const TextStyle(
                color: Color(0xFFE5E7EB),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage / 100,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingS),
          Text(
            '${sector.count}',
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/analytics_entity.dart';

class TopPositionsCard extends StatelessWidget {
  final List<TopPositionEntity> positions;

  const TopPositionsCard({
    super.key,
    required this.positions,
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
                Icons.work_outline,
                color: Color(0xFF10B981),
                size: 20,
              ),
              const SizedBox(width: AppConstants.spacingS),
              const Text(
                'Posiciones Más Demandadas',
                style: TextStyle(
                  color: Color(0xFFE5E7EB),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          ...positions.take(5).map((position) => _buildPositionItem(position)).toList(),
        ],
      ),
    );
  }

  Widget _buildPositionItem(TopPositionEntity position) {
    final totalCount = positions.fold<int>(0, (sum, item) => sum + item.count);
    final percentage = totalCount > 0 ? (position.count / totalCount * 100) : 0.0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingS),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              position.position,
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
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingS),
          Text(
            '${position.count}',
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

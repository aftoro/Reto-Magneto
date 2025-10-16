import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class InsightsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> insights;

  const InsightsCard({
    super.key,
    required this.title,
    required this.icon,
    required this.insights,
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              Icon(
                icon,
                color: const Color(0xFFF59E0B),
                size: 24,
              ),
              const SizedBox(width: AppConstants.spacingS),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFE5E7EB),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          ...insights.map((insight) => Container(
            margin: const EdgeInsets.only(bottom: AppConstants.spacingS),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF59E0B),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingS),
                Expanded(
                  child: Text(
                    insight,
                    style: const TextStyle(
                      color: Color(0xFFE5E7EB),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/analytics_provider.dart';
import '../widgets/analytics_card.dart';
import '../widgets/insights_card.dart';
import '../widgets/stats_overview_card.dart';
import '../widgets/top_sectors_card.dart';
import '../widgets/top_positions_card.dart';
import '../widgets/conversations_stats_card.dart';
import '../widgets/ai_insights_card.dart';

class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({super.key});

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    // Cargar estadísticas al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsNotifierProvider.notifier).loadAIAnalytics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final analyticsState = ref.watch(analyticsNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: CustomScrollView(
        slivers: [
          // App Bar personalizado
          SliverAppBar(
            expandedHeight: 80,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1F2937),
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1F2937), Color(0xFF374151)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Text(
                        'Estadísticas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: () {
                          ref.read(analyticsNotifierProvider.notifier).refreshAnalytics();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Contenido principal
          SliverToBoxAdapter(
            child: analyticsState.when(
              initial: () => _buildLoadingState(),
              loading: () => _buildLoadingState(),
              loaded: (analytics) => _buildLoadedContent(analytics),
              error: (message) => _buildErrorState(message),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
            ),
            SizedBox(height: AppConstants.spacingM),
            Text(
              'Cargando estadísticas...',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Color(0xFFEF4444),
            ),
            const SizedBox(height: AppConstants.spacingM),
            Text(
              'Error al cargar estadísticas',
              style: const TextStyle(
                color: Color(0xFFE5E7EB),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              message,
              style: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingL),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(analyticsNotifierProvider.notifier).loadAIAnalytics();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingL,
                  vertical: AppConstants.spacingM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedContent(analytics) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resumen general
          StatsOverviewCard(analytics: analytics),
          const SizedBox(height: AppConstants.spacingM),
          
          // Estadísticas de posts
          AnalyticsCard(
            title: 'Análisis de Posts',
            icon: Icons.analytics,
            child: Column(
              children: [
                TopSectorsCard(sectors: analytics.posts.topSectors),
                const SizedBox(height: AppConstants.spacingM),
                TopPositionsCard(positions: analytics.posts.topPositions),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.spacingM),
          
          // Estadísticas de conversaciones
          ConversationsStatsCard(analytics: analytics),
          const SizedBox(height: AppConstants.spacingM),
          
          // Insights de IA
          AIInsightsCard(insights: analytics.aiInsights),
          const SizedBox(height: AppConstants.spacingM),
          
          // Recomendaciones
          InsightsCard(
            title: 'Recomendaciones',
            icon: Icons.lightbulb_outline,
            insights: analytics.aiInsights.recommendations,
          ),
          const SizedBox(height: AppConstants.spacingM),
          
          // Insights específicos
          InsightsCard(
            title: 'Insights Clave',
            icon: Icons.insights,
            insights: analytics.aiInsights.insights,
          ),
          const SizedBox(height: AppConstants.spacingXL),
        ],
      ),
    );
  }
}

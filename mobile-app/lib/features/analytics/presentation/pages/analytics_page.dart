import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/responsive.dart';
import '../providers/analytics_stream_provider.dart';
import '../providers/analytics_provider.dart';
import '../widgets/analytics_card.dart';
import '../widgets/insights_card.dart';
import '../widgets/stats_overview_card.dart';
import '../widgets/top_sectors_card.dart';
import '../widgets/top_positions_card.dart';
import '../widgets/conversations_stats_card.dart';
import '../widgets/ai_insights_card.dart';
import '../../data/models/analytics_entity.dart';
import '../providers/analytics_provider.dart' show aiLoadingProvider;
import '../../../../shared/widgets/responsive/responsive_grid.dart';
import '../../../../shared/widgets/responsive/responsive_padding.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({super.key});

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
    // Cargar estadísticas básicas por GET y en paralelo iniciar el stream para IA
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsNotifierProvider.notifier).loadBasicAnalyticsIfNeeded();
    });
  }

  void _handleSignOut(BuildContext context, WidgetRef ref) async {
    // Mostrar diálogo de confirmación
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cerrar sesión',
          style: GoogleFonts.poppins(
            color: AppConstants.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          '¿Estás seguro de que deseas cerrar sesión?',
          style: GoogleFonts.poppins(
            color: AppConstants.textSecondary,
            fontSize: 14,
          ),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(
                color: AppConstants.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Cerrar sesión',
              style: GoogleFonts.poppins(
                color: AppConstants.errorColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      try {
        // Mostrar indicador de carga
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cerrando sesión...'),
            duration: Duration(seconds: 1),
          ),
        );

        // Ejecutar logout
        await ref.read(signOutProvider.notifier).signOut();

        // Navegar al login
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al cerrar sesión: ${e.toString()}'),
              backgroundColor: AppConstants.errorColor,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppConstants.backgroundColor, // Fondo blanco para light mode
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Fondo blanco para modo claro
              border: Border(
                bottom: BorderSide(
                  color: AppConstants.textTertiary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    // Logo
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppConstants.primaryColor.withValues(alpha: 0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Image.asset(
                          'assets/images/logo_m.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Estadísticas',
                      style: GoogleFonts.poppins(
                        color: AppConstants.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        CupertinoIcons.refresh,
                        color: AppConstants.textSecondary,
                      ),
                      onPressed: () {
                        ref.read(analyticsNotifierProvider.notifier).loadBasicAnalytics();
                      },
                      tooltip: 'Actualizar',
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(
                        CupertinoIcons.ellipsis_vertical,
                        color: AppConstants.textSecondary,
                      ),
                      color: Colors.white,
                      onSelected: (value) {
                        if (value == 'logout') {
                          _handleSignOut(context, ref);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'logout',
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/logout.svg',
                                width: 20,
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                  AppConstants.errorColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Cerrar sesión',
                                style: GoogleFonts.poppins(
                                  color: AppConstants.errorColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _buildContentFromState(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5B1DF4)), // Púrpura Magneto
            ),
            const SizedBox(height: AppConstants.spacingM),
            Text(
              'Cargando estadísticas...',
              style: GoogleFonts.poppins(
                color: AppConstants.textSecondary, // Gris medio para light mode
                fontSize: 16,
                fontWeight: FontWeight.w500,
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
              color: Color(0xFF5B1DF4), // Púrpura Magneto
            ),
            const SizedBox(height: AppConstants.spacingM),
            Text(
              'Error al cargar estadísticas',
              style: GoogleFonts.poppins(
                color: AppConstants.textPrimary, // Texto negro para light mode
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              message,
              style: GoogleFonts.poppins(
                color: AppConstants.textSecondary, // Gris medio para light mode
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingL),
            ElevatedButton.icon(
              onPressed: () {
                // Reintentar carga básica
                ref.read(analyticsNotifierProvider.notifier).loadBasicAnalytics();
                // Reiniciar análisis IA en segundo plano
                final notifier = ref.read(analyticsStreamProvider.notifier);
                notifier.stop();
                notifier.start();
              },
              icon: const Icon(CupertinoIcons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B1DF4), // Púrpura Magneto
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingL,
                  vertical: AppConstants.spacingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedContent(AnalyticsEntity analytics) {
    return ResponsivePadding(
      child: Responsive.builder(
        context: context,
        mobile: _buildMobileLayout(analytics),
        tablet: _buildTabletLayout(analytics),
        desktop: _buildDesktopLayout(analytics),
      ),
    );
  }

  Widget _buildMobileLayout(AnalyticsEntity analytics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildAllCards(analytics),
    );
  }

  Widget _buildTabletLayout(AnalyticsEntity analytics) {
    return ResponsiveGrid(
      mobileColumns: 1,
      tabletColumns: 2,
      desktopColumns: 3,
      spacing: AppConstants.spacingM,
      runSpacing: AppConstants.spacingM,
      children: [
        // Resumen general - ocupa todo el ancho
        StatsOverviewCard(analytics: analytics),
        // Estadísticas de posts
        AnalyticsCard(
          title: 'Análisis de Posts',
          iconPath: 'assets/icons/media.svg',
          child: Column(
            children: [
              TopSectorsCard(sectors: analytics.posts.topSectors),
              const SizedBox(height: AppConstants.spacingM),
              TopPositionsCard(positions: analytics.posts.topPositions),
            ],
          ),
        ),
        // Estadísticas de conversaciones
        ConversationsStatsCard(analytics: analytics),
        // Insights de IA
        Builder(
          builder: (context) {
            final isAiLoading = ref.watch(aiLoadingProvider);
            return Stack(
              children: [
                AIInsightsCard(insights: analytics.aiInsights),
                if (isAiLoading)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8), // Fondo blanco semitransparente para light mode
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor), // Púrpura Magneto
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: Icon(CupertinoIcons.sparkles, color: AppConstants.primaryColor), // Púrpura Magneto para light mode
                    tooltip: 'Generar análisis de IA',
                    onPressed: isAiLoading
                        ? null
                        : () {
                            ref.read(aiLoadingProvider.notifier).state = true;
                            ref.read(analyticsNotifierProvider.notifier).fetchAndMergeAIInsights();
                          },
                  ),
                )
              ],
            );
          },
        ),
        // Recomendaciones
        InsightsCard(
          title: 'Recomendaciones',
          icon: CupertinoIcons.lightbulb,
          insights: analytics.aiInsights.recommendations,
        ),
        // Insights específicos
        InsightsCard(
          title: 'Insights Clave',
          icon: CupertinoIcons.chart_bar_circle_fill,
          insights: analytics.aiInsights.insights,
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(AnalyticsEntity analytics) {
    return ResponsiveGrid(
      mobileColumns: 1,
      tabletColumns: 2,
      desktopColumns: 3,
      spacing: AppConstants.spacingL,
      runSpacing: AppConstants.spacingL,
      children: [
        // Resumen general - ocupa 2 columnas
        SizedBox(
          width: double.infinity,
          child: StatsOverviewCard(analytics: analytics),
        ),
        // Estadísticas de posts
        AnalyticsCard(
          title: 'Análisis de Posts',
          iconPath: 'assets/icons/media.svg',
          child: Column(
            children: [
              TopSectorsCard(sectors: analytics.posts.topSectors),
              const SizedBox(height: AppConstants.spacingM),
              TopPositionsCard(positions: analytics.posts.topPositions),
            ],
          ),
        ),
        // Estadísticas de conversaciones
        ConversationsStatsCard(analytics: analytics),
        // Insights de IA
        Builder(
          builder: (context) {
            final isAiLoading = ref.watch(aiLoadingProvider);
            return Stack(
              children: [
                AIInsightsCard(insights: analytics.aiInsights),
                if (isAiLoading)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8), // Fondo blanco semitransparente para light mode
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor), // Púrpura Magneto
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: Icon(CupertinoIcons.sparkles, color: AppConstants.primaryColor), // Púrpura Magneto para light mode
                    tooltip: 'Generar análisis de IA',
                    onPressed: isAiLoading
                        ? null
                        : () {
                            ref.read(aiLoadingProvider.notifier).state = true;
                            ref.read(analyticsNotifierProvider.notifier).fetchAndMergeAIInsights();
                          },
                  ),
                )
              ],
            );
          },
        ),
        // Recomendaciones
        InsightsCard(
          title: 'Recomendaciones',
          icon: CupertinoIcons.lightbulb,
          insights: analytics.aiInsights.recommendations,
        ),
        // Insights específicos
        InsightsCard(
          title: 'Insights Clave',
          icon: CupertinoIcons.chart_bar_circle_fill,
          insights: analytics.aiInsights.insights,
        ),
      ],
    );
  }

  List<Widget> _buildAllCards(AnalyticsEntity analytics) {
    return [
      // Resumen general
      StatsOverviewCard(analytics: analytics),
      const SizedBox(height: AppConstants.spacingM),
      
      // Estadísticas de posts
      AnalyticsCard(
        title: 'Análisis de Posts',
        icon: CupertinoIcons.chart_bar_alt_fill,
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
      
      // Insights de IA con overlay de carga
      Builder(
        builder: (context) {
          final isAiLoading = ref.watch(aiLoadingProvider);
          return Stack(
            children: [
              AIInsightsCard(insights: analytics.aiInsights),
              if (isAiLoading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8), // Fondo blanco semitransparente para light mode
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor), // Púrpura Magneto
                      ),
                    ),
                  ),
                ),
              // Botón para disparar análisis IA on-demand
              Positioned(
                right: 8,
                top: 8,
                child: IconButton(
                  icon: Icon(CupertinoIcons.sparkles, color: AppConstants.primaryColor), // Púrpura Magneto para light mode
                  tooltip: 'Generar análisis de IA',
                  onPressed: isAiLoading
                      ? null
                      : () {
                          ref.read(aiLoadingProvider.notifier).state = true;
                          ref.read(analyticsNotifierProvider.notifier).fetchAndMergeAIInsights();
                        },
                ),
              )
            ],
          );
        },
      ),
      const SizedBox(height: AppConstants.spacingM),
      
      // Recomendaciones
      InsightsCard(
        title: 'Recomendaciones',
        icon: CupertinoIcons.lightbulb,
        insights: analytics.aiInsights.recommendations,
      ),
      const SizedBox(height: AppConstants.spacingM),
      
      // Insights específicos
      InsightsCard(
        title: 'Insights Clave',
        icon: CupertinoIcons.chart_bar_circle_fill,
        insights: analytics.aiInsights.insights,
      ),
      const SizedBox(height: AppConstants.spacingXL),
    ];
  }

  Widget _buildContentFromState() {
    final state = ref.watch(analyticsNotifierProvider);
    return state.when(
      initial: _buildLoadingState,
      loading: _buildLoadingState,
      error: (msg) => _buildErrorState(msg),
      loaded: (analytics) {
        return _buildLoadedContent(analytics);
      },
    );
  }

  // Panel streaming eliminado
}

import 'package:dio/dio.dart';
import '../../../../core/config/api_config.dart';
import '../models/analytics_entity.dart';

class AnalyticsApiService {
  final Dio _dio;

  AnalyticsApiService() : _dio = Dio() {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 30);
  }

  /// Obtiene estadísticas completas con análisis de IA
  Future<AnalyticsResponse> getAIAnalytics() async {
    int retryCount = 0;
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 2);

    while (retryCount < maxRetries) {
      try {
        final response = await _dio.get(
          '/analytics/ai-insights',
          options: Options(
            headers: ApiConfig.defaultHeaders,
          ),
        );

        if (response.statusCode == 200) {
          return AnalyticsResponse.fromApiJson(response.data);
        } else {
          throw Exception('Error HTTP: ${response.statusCode}');
        }
      } on DioException catch (e) {
        retryCount++;
        print('Intento $retryCount/$maxRetries falló para analytics IA: ${e.message}');
        
        if (retryCount >= maxRetries) {
          // Si es un error de conexión, devolver datos demo
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.connectionError) {
            print('API de analytics IA no disponible después de $maxRetries intentos, devolviendo datos demo');
            return _getDemoAnalytics();
          }
          throw Exception('Error al obtener analytics IA después de $maxRetries intentos: ${e.message}');
        }
        
        // Esperar antes del siguiente intento
        await Future.delayed(retryDelay * retryCount);
      } catch (e) {
        if (retryCount >= maxRetries - 1) {
          throw Exception('Error al obtener analytics IA: $e');
        }
        retryCount++;
        await Future.delayed(retryDelay * retryCount);
      }
    }

    throw Exception('Error inesperado al obtener analytics IA');
  }

  /// Obtiene estadísticas básicas
  Future<AnalyticsResponse> getBasicAnalytics() async {
    int retryCount = 0;
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 2);

    while (retryCount < maxRetries) {
      try {
        final response = await _dio.get(
          '/analytics/basic',
          options: Options(
            headers: ApiConfig.defaultHeaders,
          ),
        );

        if (response.statusCode == 200) {
          return AnalyticsResponse.fromApiJson(response.data);
        } else {
          throw Exception('Error HTTP: ${response.statusCode}');
        }
      } on DioException catch (e) {
        retryCount++;
        print('Intento $retryCount/$maxRetries falló para analytics básicas: ${e.message}');
        
        if (retryCount >= maxRetries) {
          // Si es un error de conexión, devolver datos demo
          if (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.connectionError) {
            print('API de analytics básicas no disponible después de $maxRetries intentos, devolviendo datos demo');
            return _getDemoAnalytics();
          }
          throw Exception('Error al obtener analytics básicas después de $maxRetries intentos: ${e.message}');
        }
        
        // Esperar antes del siguiente intento
        await Future.delayed(retryDelay * retryCount);
      } catch (e) {
        if (retryCount >= maxRetries - 1) {
          throw Exception('Error al obtener analytics básicas: $e');
        }
        retryCount++;
        await Future.delayed(retryDelay * retryCount);
      }
    }

    throw Exception('Error inesperado al obtener analytics básicas');
  }

  /// Datos demo para cuando la API no está disponible
  AnalyticsResponse _getDemoAnalytics() {
    return AnalyticsResponse(
      success: true,
      message: 'Datos demo - API no disponible',
      analytics: AnalyticsEntity(
        timestamp: DateTime.now().toIso8601String(),
        dataRange: DataRangeEntity(
          postsAnalyzed: 25,
          conversationsAnalyzed: 150,
          period: 'Últimos 50 posts y 100 conversaciones',
        ),
        posts: PostsAnalyticsEntity(
          summary: PostsSummaryEntity(
            totalPosts: 25,
            totalComments: 180,
            totalLikes: 450,
            avgEngagement: 25.2,
            aiResponses: 120,
            userComments: 60,
          ),
          topSectors: [
            TopSectorEntity(sector: 'Tecnología', count: 15),
            TopSectorEntity(sector: 'Marketing/Ventas', count: 5),
            TopSectorEntity(sector: 'Diseño', count: 3),
          ],
          topPositions: [
            TopPositionEntity(position: 'Frontend Developer', count: 8),
            TopPositionEntity(position: 'Full Stack Developer', count: 6),
            TopPositionEntity(position: 'Backend Developer', count: 4),
          ],
          recentPosts: [
            RecentPostEntity(
              id: '1',
              caption: 'Oportunidad Frontend React',
              comments: 12,
              likes: 45,
              createdAt: DateTime.now().subtract(const Duration(hours: 2)),
            ),
            RecentPostEntity(
              id: '2',
              caption: 'Vacante Backend Node.js',
              comments: 8,
              likes: 32,
              createdAt: DateTime.now().subtract(const Duration(hours: 5)),
            ),
          ],
        ),
        conversations: ConversationsAnalyticsEntity(
          summary: ConversationsSummaryEntity(
            totalConversations: 150,
            activeConversations: 45,
            avgCompletion: 78.5,
            messageStats: MessageStatsEntity(
              total: 1200,
              aiGenerated: 800,
              userGenerated: 400,
              aiRatio: 67,
            ),
          ),
          topProfessions: [
            TopProfessionEntity(profession: 'Desarrollador', count: 45),
            TopProfessionEntity(profession: 'Diseñador', count: 20),
            TopProfessionEntity(profession: 'Analista', count: 15),
          ],
          topLocations: [
            TopLocationEntity(location: 'Bogotá', count: 60),
            TopLocationEntity(location: 'Medellín', count: 35),
            TopLocationEntity(location: 'Cali', count: 20),
          ],
          experienceDistribution: [
            ExperienceDistributionEntity(level: 'Junior (0-1 años)', count: 40),
            ExperienceDistributionEntity(level: 'Semi-Senior (1-3 años)', count: 35),
            ExperienceDistributionEntity(level: 'Mid-Level (3-5 años)', count: 25),
          ],
        ),
        aiInsights: AIInsightsEntity(
          marketTrends: MarketTrendsEntity(
            hotSectors: ['Tecnología', 'Marketing Digital'],
            demandPatterns: 'Frontend developers tienen 3x más engagement',
            growthOpportunities: 'Contenido sobre React y Node.js',
          ),
          userBehavior: UserBehaviorEntity(
            engagementLevel: 'Alto en posts de tecnología',
            profileCompletion: '78% promedio, oportunidad de mejora',
            interactionPatterns: 'Usuarios junior más activos en DMs',
          ),
          recommendations: [
            'Crear más contenido sobre React y Frontend',
            'Mejorar onboarding para completar perfiles',
            'Enfocar stories en desarrolladores junior',
          ],
          insights: [
            'Bogotá representa 40% de usuarios activos',
            'Posts con "Frontend" tienen 2.5x más engagement',
            'Usuarios con perfiles completos tienen 3x más conversaciones',
          ],
        ),
      ),
    );
  }
}

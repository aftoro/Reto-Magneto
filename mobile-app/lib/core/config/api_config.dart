class ApiConfig {
  // URL base de la API - Cambia esta URL según tu configuración
  // Para desarrollo local con ngrok, usa: https://TU_ID.ngrok-free.app
  // Para producción, usa tu dominio real
  static const String baseUrl = 'https://7b6cc34ccf4c.ngrok-free.app/api';
  
  // ============================================
  // ENDPOINTS DE USUARIOS
  // ============================================
  static const String userRegister = '$baseUrl/users/register';
  static const String userLogin = '$baseUrl/users/login';
  static const String userProfile = '$baseUrl/users/profile';
  
  // ============================================
  // ENDPOINTS DE MENSAJES Y CONVERSACIONES
  // ============================================
  static const String messages = '$baseUrl/messages';
  static const String getConversation = '$baseUrl/messages/conversation'; // + /:id
  static const String notifications = '$baseUrl/notifications/stream';
  
  // Endpoints legacy (mantener compatibilidad)
  static const String sendDm = '$baseUrl/messages'; // Usa el endpoint de messages
  static const String chats = '$baseUrl/messages/list'; // Usa el endpoint público de messages/list
  static const String conversations = '$baseUrl/messages'; // Usa el endpoint de messages
  
  // ============================================
  // ENDPOINTS DE INSTAGRAM
  // ============================================
  static const String instagramPosts = '$baseUrl/instagram/posts';
  static const String instagramPostComments = '$baseUrl/instagram/posts'; // + /:postId/comments
  static const String instagramPublishPost = '$baseUrl/instagram/publish/post';
  static const String instagramPublishStory = '$baseUrl/instagram/publish/story';
  static const String instagramPublishReel = '$baseUrl/instagram/publish/reel';
  
  // Webhooks (solo para recibir, no para llamar desde Flutter)
  static const String instagramWebhookComment = '$baseUrl/instagram/webhook/comment';
  static const String instagramWebhookMessage = '$baseUrl/instagram/webhook/message';
  static const String instagramWebhookLike = '$baseUrl/instagram/webhook/like';
  
  // Endpoints legacy (mantener compatibilidad)
  static const String createPost = '$baseUrl/instagram/publish/post';
  static const String createStory = '$baseUrl/instagram/publish/story';
  
  // ============================================
  // ENDPOINTS DE ANALYTICS
  // ============================================
  static const String analyticsAiInsights = '$baseUrl/analytics/ai-insights';
  static const String analyticsBasic = '$baseUrl/analytics/basic';
  
  // ============================================
  // ENDPOINTS DE PREVIEW (legacy - usar /generate/preview)
  // ============================================
  // Nota: Los endpoints de preview están en /generate/preview (fuera de /api)
  // Para compatibilidad, mantenemos estas constantes pero se deben usar con buildUrl
  static const String previewPost = '/generate/preview'; // POST con type=post
  static const String previewStory = '/generate/preview'; // POST con type=story
  static const String previewReel = '/generate/preview'; // POST con type=reel
  
  // ============================================
  // ENDPOINTS DE HEALTH CHECK
  // ============================================
  static const String health = '$baseUrl/health';
  static const String apiInfo = '$baseUrl/info';
  
  // ============================================
  // CONFIGURACIÓN
  // ============================================
  // Headers comunes
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'ngrok-skip-browser-warning': 'true', // Necesario para ngrok
    'Accept': 'application/json',
  };
  
  // Timeout para requests
  static const Duration timeout = Duration(seconds: 30);
  
  // Timeout para requests largos (como analytics con IA)
  static const Duration longTimeout = Duration(minutes: 2);
  
  /// Construir URL con parámetros de ruta
  /// Ejemplo: buildUrl('/messages/conversation/:id', {'id': '123'})
  /// Retorna: '/api/messages/conversation/123'
  static String buildUrl(String endpoint, Map<String, String>? params) {
    String url = endpoint.startsWith('/') 
        ? '$baseUrl$endpoint' 
        : '$baseUrl/$endpoint';
    
    if (params != null && params.isNotEmpty) {
      params.forEach((key, value) {
        url = url.replaceAll(':$key', value);
      });
    }
    
    return url;
  }
  
  /// Construir URL con query parameters
  /// Ejemplo: buildUrlWithQuery('/messages', {'limit': '10', 'offset': '0'})
  /// Retorna: '/api/messages?limit=10&offset=0'
  static String buildUrlWithQuery(String endpoint, Map<String, String>? queryParams) {
    String url = endpoint.startsWith('/') 
        ? '$baseUrl$endpoint' 
        : '$baseUrl/$endpoint';
    
    if (queryParams != null && queryParams.isNotEmpty) {
      final queryString = queryParams.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
      url = '$url?$queryString';
    }
    
    return url;
  }
}

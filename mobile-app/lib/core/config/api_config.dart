class ApiConfig {
  // URL base de la API - Cambia esta URL según tu configuración
  static const String baseUrl = 'https://db72e8cc249c.ngrok-free.app/api';
  
  // Endpoints específicos
  static const String sendDm = '$baseUrl/send-dm';
  static const String createPost = '$baseUrl/create-post';
  static const String createStory = '$baseUrl/create-story';
  
  // Endpoints de conversaciones y mensajes
  static const String chats = '$baseUrl/chats';
  static const String conversations = '$baseUrl/conversations';
  static const String notifications = '$baseUrl/notifications/stream';
  
  // Headers comunes
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'ngrok-skip-browser-warning': 'true',
  };
  
  // Timeout para requests
  static const Duration timeout = Duration(seconds: 30);
}

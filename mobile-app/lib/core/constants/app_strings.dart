/// Constantes de strings de la aplicación
/// Contiene todos los textos de la UI alineados con la identidad de marca de Magneto Empleos
class AppStrings {
  // ============================================
  // IDENTIDAD DE MARCA
  // ============================================
  
  /// Eslogan principal de Magneto Empleos
  static const String mainSlogan = 'Oportunidades que transforman';
  
  /// Eslóganes secundarios
  static const String secondarySlogan1 = 'Impulsamos. Conectamos. Transformamos';
  static const String secondarySlogan2 = 'Trabajos que transforman';
  static const String secondarySlogan3 = 'El trabajo que mereces';
  
  /// Mensajes clave de la marca
  static const String keyMessage1 = 'Estamos aquí para ayudarte a encontrar la oportunidad que estabas buscando';
  static const String keyMessage2 = 'Tu próxima postulación puede cambiar tu vida ¿qué estás esperando?';
  static const String keyMessage3 = 'No es otro empleo, es avanzar hacía tus sueños';
  static const String keyMessage4 = 'No esperes, elige el lugar donde quieres estar';
  
  // ============================================
  // AUTENTICACIÓN
  // ============================================
  
  static const String welcomeBack = '¡Bienvenido de vuelta!';
  static const String welcomeToMagneto = '¡Bienvenido a Magneto!';
  static const String loginSubtitle = 'Inicia sesión para continuar';
  static const String loginSubtitleAlt = 'Inicia sesión en tu cuenta';
  static const String registerTitle = 'Crea tu cuenta';
  static const String registerSubtitle = 'Únete a Magneto y encuentra tu oportunidad';
  static const String accountCreated = '¡Cuenta creada exitosamente!';
  static const String accountCreatedMessage = 'Tu cuenta ha sido creada. ¡Bienvenido a Magneto!';
  
  // ============================================
  // NAVEGACIÓN
  // ============================================
  
  static const String stats = 'Estadísticas';
  static const String chats = 'Chats';
  static const String conversations = 'Conversaciones';
  static const String posts = 'Posts';
  static const String stories = 'Stories';
  static const String profile = 'Perfil';
  static const String logout = 'Cerrar sesión';
  static const String loggingOut = 'Cerrando sesión...';
  
  // ============================================
  // MENSAJES Y CONVERSACIONES
  // ============================================
  
  static const String conversationsEmptyTitle = '¡Bienvenido a Magneto!';
  static const String conversationsEmptyMessage = 
      'Tus conversaciones aparecerán aquí cuando recibas mensajes de usuarios interesados en tus ofertas de empleo';
  static const String noConversations = 'No hay conversaciones aún';
  static const String noMessages = 'No hay mensajes aún';
  static const String sendMessage = 'Enviar mensaje';
  static const String messagePlaceholder = 'Escribe tu mensaje...';
  static const String messagesInfo = 'Los mensajes se enviarán directamente a través de Instagram';
  
  // ============================================
  // POSTS Y STORIES
  // ============================================
  
  static const String createPost = 'Crear Post';
  static const String createStory = 'Crear Story';
  static const String createReel = 'Crear Reel';
  static const String noPosts = 'No hay posts creados aún';
  static const String noStories = 'No hay stories creadas aún';
  static const String createFirstPost = 'Crea tu primer post y comparte oportunidades';
  static const String createFirstStory = 'Crea tu primera story y conecta con tu audiencia';
  
  // ============================================
  // PREVIEW Y CREACIÓN DE CONTENIDO
  // ============================================
  
  static const String createContent = 'Crear Contenido';
  static const String selectType = 'Selecciona el tipo de contenido';
  static const String topic = 'Tema';
  static const String topicHint = 'Ej: Oportunidad de desarrollador React';
  static const String style = 'Estilo';
  static const String targetAudience = 'Audiencia objetivo';
  static const String generatePreview = 'Generar Preview';
  static const String generating = 'Generando...';
  static const String applyCorrections = 'Aplicar Correcciones';
  static const String publish = 'Publicar';
  static const String cancel = 'Cancelar';
  
  // ============================================
  // ANALYTICS
  // ============================================
  
  static const String analytics = 'Analytics';
  static const String insights = 'Insights';
  static const String loadingAnalytics = 'Cargando analytics...';
  static const String noAnalytics = 'No hay datos de analytics disponibles';
  
  // ============================================
  // MENSAJES DE ÉXITO Y ERROR
  // ============================================
  
  static const String success = '¡Éxito!';
  static const String error = 'Error';
  static const String somethingWentWrong = 'Algo salió mal';
  static const String tryAgain = 'Intentar de nuevo';
  static const String loading = 'Cargando...';
  
  // ============================================
  // CALLS TO ACTION
  // ============================================
  
  static const String getStarted = 'Comenzar';
  static const String startNow = 'Empezar ahora';
  static const String applyNow = '¡Aplica ahora!';
  static const String shareExperience = '¡Comparte tu experiencia!';
  static const String commentIfInterested = '¡Comenta si te interesa!';
  static const String findOpportunity = 'Encuentra tu oportunidad';
  static const String exploreJobs = 'Explorar empleos';
  
  // ============================================
  // BENEFICIOS
  // ============================================
  
  static const String benefit1 = 'Acceso a miles de vacantes y empresas de todos los tamaños en Latinoamérica';
  static const String benefit2 = 'Filtros para la personalización y efectividad de la búsqueda';
  static const String benefit3 = 'Postulaciones sin límite y gratuitas';
  static const String benefit4 = 'Historial de aplicaciones y seguimiento a procesos';
  static const String benefit5 = 'Notificaciones de nuevas oportunidades';
  static const String benefit6 = 'Acceso gratuito e ilimitado a formación en empleabilidad';
  
  // ============================================
  // HELPERS
  // ============================================
  
  /// Obtiene un mensaje de bienvenida personalizado
  static String getWelcomeMessage(String? userName) {
    final name = userName?.split(' ').first ?? 'Usuario';
    return '¡Hola, $name! 👋\n$keyMessage1';
  }
  
  /// Obtiene un mensaje motivacional aleatorio
  static String getMotivationalMessage() {
    final messages = [
      keyMessage2,
      keyMessage3,
      keyMessage4,
      mainSlogan,
    ];
    return messages[DateTime.now().millisecond % messages.length];
  }
}


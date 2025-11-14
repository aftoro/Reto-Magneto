import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/responsive.dart';
import '../../../conversations/presentation/providers/conversation_provider.dart';
import '../../../conversations/data/models/conversation_entity.dart';
import '../../../conversations/presentation/pages/chat_page.dart';
import '../../../preview/presentation/pages/preview_creation_page.dart';
import '../../../preview/presentation/providers/reel_generation_monitor_provider.dart';
import '../../../preview/presentation/pages/reel_preview_page.dart';
import '../../../posts/presentation/pages/created_posts_page.dart';
import '../../../posts/presentation/pages/created_stories_page.dart';
import '../../../analytics/presentation/pages/analytics_page.dart';
import '../../../search/presentation/providers/search_provider.dart';
import '../../../../shared/widgets/floating_create_button.dart';
import '../../../../shared/widgets/responsive/responsive_scaffold.dart';
import '../../../../shared/widgets/responsive/web_sidebar.dart';

class MainAppPage extends ConsumerStatefulWidget {
  const MainAppPage({super.key});

  @override
  ConsumerState<MainAppPage> createState() => _MainAppPageState();
}

class _MainAppPageState extends ConsumerState<MainAppPage> {
  int _currentIndex = 0;
  
  /// Método público para restaurar el tab de conversaciones
  void restoreConversationsTab() {
    if (mounted && _currentIndex != 1) {
      setState(() {
        _currentIndex = 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Verificar si hay reels generándose al iniciar la app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // El monitor verificará automáticamente si hay reels recientes
        // cuando se inicie el monitoreo desde preview_creation_page
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Obtener argumentos de la ruta para establecer el índice inicial
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['initialIndex'] != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentIndex = args['initialIndex'] as int;
          });
        }
      });
    }
  }

  final List<Widget> _pages = [
    const AnalyticsPage(),
    const _ConversationsPage(),
    const CreatedPostsPage(),
    const CreatedStoriesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // Listener para cambios en el estado de generación de reels
    ref.listen<ReelGenerationState>(reelGenerationMonitorProvider, (previous, next) {
      if (next.isGenerating && next.topic != null) {
        // Asegurar que estamos en el dashboard (índice 0)
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        }
        
        // Mostrar/actualizar toast con progreso
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Generando reel... ${next.progress}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: AppConstants.primaryColor,
            duration: const Duration(seconds: 2),
          ),
        );
      } else if (next.completedPreview != null) {
        // Reel completado
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text('¡Tu reel está listo!'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Ver',
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReelPreviewPage(
                      preview: next.completedPreview!,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      } else if (next.error != null) {
        // Error en la generación
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    });
    
    // Verificar autenticación al construir la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final session = Supabase.instance.client.auth.currentSession;
      final user = Supabase.instance.client.auth.currentUser;
      
      if (session == null || user == null || session.accessToken.isEmpty) {
        print('🔓 MainAppPage: No hay sesión, redirigiendo a login...');
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
    
    // Verificar que MediaQuery esté disponible antes de usar context.isMobile
    final mediaQuery = MediaQuery.maybeOf(context);
    final isMobileSize = mediaQuery != null ? context.isMobile : false;

    // En web con pantalla grande, usar sidebar
    if (Responsive.isWeb && !isMobileSize) {
      return ResponsiveScaffold(
        body: IndexedStack(index: _currentIndex, children: _pages),
        sidebar: WebSidebar(
          currentIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        floatingActionButton: FloatingCreateButton(
          onItemSelected: (item) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PreviewCreationPage(initialType: item),
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    }

    // En mobile, usar bottom navigation
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      floatingActionButton: FloatingCreateButton(
        onItemSelected: (item) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PreviewCreationPage(initialType: item),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: AppConstants.textTertiary.withValues(alpha: 0.2), width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingM,
              vertical: AppConstants.spacingS,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                  Expanded(
                    child: _buildNavItem(
                      svgPath: 'assets/icons/charts.svg',
                      label: AppStrings.stats,
                      index: 0,
                    ),
                  ),
                  Expanded(
                    child: _buildNavItem(
                      svgPath: 'assets/icons/chat.svg',
                      label: AppStrings.chats,
                      index: 1,
                    ),
                  ),
                  // Espacio para el botón flotante
                  const SizedBox(width: 60),
                  Expanded(
                    child: _buildNavItem(
                      svgPath: 'assets/icons/media.svg',
                      label: AppStrings.posts,
                      index: 2,
                    ),
                  ),
                  Expanded(
                    child: _buildNavItem(
                      svgPath: 'assets/icons/storie.svg',
                      label: AppStrings.stories,
                      index: 3,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String svgPath,
    required String label,
    required int index,
  }) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingS,
          vertical: AppConstants.spacingS,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppConstants.primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SvgPicture.asset(
          svgPath,
          width: 24,
          height: 24,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(
            isActive ? AppConstants.primaryColor : AppConstants.textSecondary,
            BlendMode.srcIn,
              ),
        ),
      ),
    );
  }
}

class _ConversationsPage extends ConsumerStatefulWidget {
  const _ConversationsPage();

  @override
  ConsumerState<_ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends ConsumerState<_ConversationsPage> {
  @override
  void initState() {
    super.initState();
    // Cargar conversaciones cuando se inicializa la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(conversationNotifierProvider.notifier).loadConversations();
    });
  }

  // Helper para obtener el nombre de la emoción en español
  String _getEmotionDisplayName(String? emotion) {
    switch (emotion?.toLowerCase()) {
      case 'happy':
        return 'Feliz';
      case 'excited':
        return 'Emocionado';
      case 'hopeful':
        return 'Esperanzado';
      case 'grateful':
        return 'Agradecido';
      case 'calm':
        return 'Calmado';
      case 'sad':
        return 'Triste';
      case 'angry':
        return 'Enojado';
      case 'stressed':
        return 'Estresado';
      case 'disappointed':
        return 'Decepcionado';
      case 'confused':
        return 'Confundido';
      case 'curious':
        return 'Curioso';
      case 'neutral':
        return 'Neutral';
      default:
        return 'Desconocido';
    }
  }

  // Helper para obtener la descripción de la emoción
  String _getEmotionDescription(String? emotion) {
    switch (emotion?.toLowerCase()) {
      case 'happy':
        return 'Expresión de alegría y satisfacción. Usuario se siente contento y positivo.';
      case 'excited':
        return 'Muestra entusiasmo y energía. Usuario está motivado y dinámico.';
      case 'hopeful':
        return 'Indica optimismo y expectativa positiva. Usuario tiene esperanzas.';
      case 'grateful':
        return 'Refleja aprecio y gratitud. Usuario se siente agradecido.';
      case 'calm':
        return 'Denota serenidad y tranquilidad. Usuario está relajado.';
      case 'sad':
        return 'Expresión de tristeza o melancolía. Usuario se siente abatido.';
      case 'angry':
        return 'Muestra enojo o irritación. Usuario está molesto o frustrado.';
      case 'stressed':
        return 'Indica tensión o preocupación. Usuario se siente presionado.';
      case 'disappointed':
        return 'Refleja desilusión o frustración. Usuario esperaba algo mejor.';
      case 'confused':
        return 'Muestra perplejidad o falta de claridad. Usuario necesita aclaración.';
      case 'curious':
        return 'Indica interés y deseo de saber más. Usuario quiere aprender.';
      case 'neutral':
        return 'Expresión sin emoción predominante. Usuario está equilibrado.';
      default:
        return 'Emoción no reconocida por el sistema.';
    }
  }

  // Widget común para el contenido de emociones
  Widget _buildEmotionContent(List<String> emotions, ScrollController? controller) {
    return Column(
      children: [
        // Header - Título
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          alignment: Alignment.center,
          child: Text(
            'Guía de Emociones',
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            style: GoogleFonts.poppins(
              color: AppConstants.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              decoration: TextDecoration.none,
            ),
          ),
        ),

        // Divider sutil
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppConstants.textTertiary.withValues(alpha: 0.1),
                Colors.transparent,
              ],
            ),
          ),
        ),
        
        // Content - Lista de emociones
        Expanded(
          child: ListView.builder(
            controller: controller,
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            itemCount: emotions.length,
            itemBuilder: (context, index) {
              final emotion = emotions[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    // Acción al tocar la emoción
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Fondo blanco para light mode
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _getEmotionColor(
                          emotion,
                        ).withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                        BoxShadow(
                          color: _getEmotionColor(
                            emotion,
                          ).withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        // Avatar de emoción - Estilo moderno
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getEmotionColor(
                              emotion,
                            ).withOpacity(0.1), // Fondo claro para light mode
                            border: Border.all(
                              color: _getEmotionColor(
                                emotion,
                              ).withOpacity(0.3),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _getEmotionColor(
                                  emotion,
                                ).withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/emotions/$emotion.png',
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _getEmotionColor(
                                      emotion,
                                    ).withOpacity(0.1),
                                  ),
                                  child: Icon(
                                    CupertinoIcons.smiley,
                                    color: _getEmotionColor(
                                      emotion,
                                    ),
                                    size: 28,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Información de la emoción
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getEmotionDisplayName(emotion),
                                style: GoogleFonts.poppins(
                                  color: AppConstants.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _getEmotionDescription(emotion),
                                style: GoogleFonts.manrope(
                                  color: AppConstants.textSecondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.1,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Función para mostrar el bottom sheet de ayuda - Adaptativo para web y móvil
  void _showEmotionHelpBottomSheet(BuildContext context) {
    final List<String> emotions = [
      'happy',
      'excited',
      'hopeful',
      'grateful',
      'calm',
      'sad',
      'angry',
      'stressed',
      'disappointed',
      'confused',
      'curious',
      'neutral',
    ];

    // En web, mostrar diálogo centrado
    if (Responsive.isWeb) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 600,
                maxHeight: 700,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header con botón de cerrar
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Guía de Emociones',
                          style: GoogleFonts.poppins(
                            color: AppConstants.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            CupertinoIcons.xmark_circle_fill,
                            color: AppConstants.textSecondary,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),

                  // Divider sutil
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppConstants.textTertiary.withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // Content - Lista de emociones con scroll
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 12.0,
                      ),
                      itemCount: emotions.length,
                      itemBuilder: (context, index) {
                        final emotion = emotions[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              // Acción al tocar la emoción
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: _getEmotionColor(
                                    emotion,
                                  ).withOpacity(0.3),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                  BoxShadow(
                                    color: _getEmotionColor(
                                      emotion,
                                    ).withOpacity(0.1),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  // Avatar de emoción
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _getEmotionColor(
                                        emotion,
                                      ).withOpacity(0.1),
                                      border: Border.all(
                                        color: _getEmotionColor(
                                          emotion,
                                        ).withOpacity(0.3),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _getEmotionColor(
                                            emotion,
                                          ).withOpacity(0.2),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/emotions/$emotion.png',
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 56,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _getEmotionColor(
                                                emotion,
                                              ).withOpacity(0.1),
                                            ),
                                            child: Icon(
                                              CupertinoIcons.smiley,
                                              color: _getEmotionColor(
                                                emotion,
                                              ),
                                              size: 28,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  // Información de la emoción
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _getEmotionDisplayName(emotion),
                                          style: GoogleFonts.poppins(
                                            color: AppConstants.textPrimary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          _getEmotionDescription(emotion),
                                          style: GoogleFonts.manrope(
                                            color: AppConstants.textSecondary,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: -0.1,
                                            height: 1.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      // En móvil, mantener el bottom sheet original
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.75,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            expand: false,
            builder: (_, controller) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Handle Cupertino
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 36,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppConstants.textTertiary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                    // Contenido común
                    _buildEmotionContent(emotions, controller),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

  // Helper para obtener el color de la emoción
  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return const Color(0xFF00E676); // Bright Green
      case 'excited':
        return const Color(0xFF7B2FFF); // Vibrant Purple
      case 'hopeful':
        return const Color(0xFF00C853); // Emerald Green
      case 'grateful':
        return const Color(0xFFFFD700); // Gold
      case 'calm':
        return const Color(0xFF4CAF50); // Green
      case 'sad':
        return const Color(0xFF2196F3); // Blue
      case 'angry':
        return const Color(0xFFFF5252); // Coral Red
      case 'stressed':
        return const Color(0xFFFF9800); // Orange
      case 'disappointed':
        return const Color(0xFF9E9E9E); // Medium Gray
      case 'confused':
        return const Color(0xFF9C27B0); // Purple
      case 'curious':
        return const Color(0xFF00BCD4); // Cyan
      case 'neutral':
        return const Color(0xFF607D8B); // Blue Grey
      default:
        return const Color(0xFF9E9E9E); // Default gray
    }
  }

  @override
  Widget build(BuildContext context) {
    final conversationState = ref.watch(conversationNotifierProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco para modo claro
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppConstants.primaryColor.withValues(alpha: 0.03), // Overlay púrpura muy sutil arriba
            Colors.transparent, // Desaparece abajo
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ), // Scroll con bouncing siempre
          slivers: [
            // AppBar con glass effect
            SliverAppBar(
              expandedHeight: 70,
              collapsedHeight: 70,
              pinned: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              toolbarHeight: 70,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
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
                          AppStrings.chats,
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
                            CupertinoIcons.search,
                            color: AppConstants.textSecondary,
                          ),
                          onPressed: () {
                            // TODO: Implementar funcionalidad de búsqueda
                          },
                          tooltip: 'Buscar',
                        ),
                        IconButton(
                          icon: Icon(
                            CupertinoIcons.question_circle,
                            color: AppConstants.textSecondary,
                          ),
                          onPressed: () =>
                              _showEmotionHelpBottomSheet(context),
                          tooltip: 'Ayuda - Guía de emociones',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Contenido principal
            conversationState.when(
              initial: () => SliverToBoxAdapter(
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'Inicializando conversaciones...',
                      style: TextStyle(color: AppConstants.textSecondary),
                    ),
                  ),
                ),
              ),
              loading: () => SliverToBoxAdapter(
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
              loaded: (conversations, stats) => conversations.isEmpty
                  ? SliverToBoxAdapter(child: _buildEmptyState())
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final conversation = conversations[index];
                        return _WhatsAppConversationTile(
                          conversation: conversation,
                        );
                      }, childCount: conversations.length),
                    ),
              error: (error) => SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: AppConstants.errorColor.withValues(alpha: 0.6),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error al cargar conversaciones',
                          style: GoogleFonts.manrope(
                            color: AppConstants.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Verifica tu conexión a internet',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: AppConstants.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            ref
                                .read(conversationNotifierProvider.notifier)
                                .loadConversations();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Reintentar',
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withValues(alpha: 0.1), // Púrpura claro para contraste
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.primaryColor.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: AppConstants.primaryColor, // Púrpura Magneto
              ),
            ),
            const SizedBox(height: 32),
            Text(
              AppStrings.conversationsEmptyTitle,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.conversationsEmptyMessage,
              style: GoogleFonts.manrope(
                fontSize: 16,
                color: AppConstants.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppConstants.primaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: AppConstants.primaryColor, // Púrpura Magneto
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '¡Magneto IA está activo!',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppConstants.primaryColor, // Púrpura Magneto
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends ConsumerStatefulWidget {
  final Function(String) onSearch;

  const _SearchBar({required this.onSearch});

  @override
  ConsumerState<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<_SearchBar> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchNotifierProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppConstants.textTertiary.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.manrope(color: AppConstants.textPrimary, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Buscar conversaciones y mensajes...',
          hintStyle: GoogleFonts.manrope(color: AppConstants.textTertiary, fontSize: 16),
          prefixIcon: Icon(
            Icons.search,
            color: searchState.maybeWhen(
              loading: () => AppConstants.secondaryColor,
              orElse: () => AppConstants.textSecondary,
            ),
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: AppConstants.textSecondary, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(searchNotifierProvider.notifier).clearSearch();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: (value) {
          setState(() {});
          // Búsqueda con debounce
          if (value.trim().isNotEmpty) {
            ref.read(searchNotifierProvider.notifier).search(value);
          } else {
            ref.read(searchNotifierProvider.notifier).clearSearch();
          }
        },
      ),
    );
  }
}

class _WhatsAppConversationTile extends StatelessWidget {
  final ConversationWithMessages conversation;

  const _WhatsAppConversationTile({required this.conversation});

  @override
  Widget build(BuildContext context) {
    final username =
        conversation.conversation.username ??
        conversation.conversation.userId.substring(0, 8);
    final lastMessage = conversation.lastMessage?.content ?? 'Sin mensajes';
    final timestamp =
        conversation.lastMessage?.createdAt ??
        conversation.conversation.updatedAt ??
        conversation.conversation.createdAt;
    final isActive = conversation.conversation.status == 'active';
    final unreadCount = conversation.unreadCount ?? 0;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.transparent, // Mismo color que el fondo principal
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(conversation: conversation),
              ),
            ).then((_) {
              // Restaurar el tab de conversaciones cuando se regrese del chat
              final mainAppState = context.findAncestorStateOfType<_MainAppPageState>();
              mainAppState?.restoreConversationsTab();
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Avatar circular estilo WhatsApp
                Stack(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _getEmotionColor(
                          conversation.conversation.userCurrentEmotion,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: AppConstants.textTertiary.withValues(alpha: 0.2),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getEmotionColor(
                              conversation.conversation.userCurrentEmotion,
                            ).withValues(alpha: 0.2),
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          _getEmotionImagePath(
                            conversation.conversation.userCurrentEmotion,
                          ),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Indicador de estado en línea
                    if (isActive)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppConstants.secondaryColor, // Verde menta
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppConstants.primaryVariant, // Morado oscuro
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                // Contenido principal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              username,
                              style: GoogleFonts.poppins(
                                color: AppConstants.textPrimary,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                          if (timestamp != null)
                            Text(
                              _formatTimestamp(timestamp),
                              style: GoogleFonts.poppins(
                                color: AppConstants.textTertiary,
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.1,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lastMessage,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.manrope(
                                color: unreadCount > 0
                                    ? AppConstants.textPrimary
                                    : AppConstants.textSecondary,
                                fontSize: 14,
                                fontWeight: unreadCount > 0
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                height: 1.3,
                              ),
                            ),
                          ),
                          if (unreadCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              constraints: const BoxConstraints(minWidth: 20),
                              height: 20,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppConstants.primaryColor, // Púrpura Magneto
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  unreadCount > 99
                                      ? '99+'
                                      : unreadCount.toString(),
                                  style: GoogleFonts.manrope(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${difference.inDays}d';
    }
  }

  Color _getEmotionColor(String? emotion) {
    switch (emotion?.toLowerCase()) {
      case 'happy':
        return AppConstants.secondaryColor; // Verde menta
      case 'excited':
        return AppConstants.primaryColor; // Púrpura Magneto
      case 'hopeful':
        return AppConstants.secondaryColor; // Verde menta
      case 'grateful':
        return AppConstants.primaryColor; // Púrpura Magneto
      case 'calm':
        return AppConstants.primaryVariant; // Morado oscuro
      case 'sad':
        return AppConstants.textTertiary; // Gris claro
      case 'angry':
        return AppConstants.errorColor; // Rojo para enojo
      case 'stressed':
        return AppConstants.warningColor; // Amarillo/naranja para estrés
      case 'disappointed':
        return AppConstants.primaryVariant; // Morado oscuro
      case 'confused':
        return AppConstants.textTertiary; // Gris claro
      case 'curious':
        return AppConstants.secondaryColor; // Verde menta
      case 'neutral':
        return AppConstants.primaryVariant; // Morado oscuro
      default:
        return AppConstants.primaryVariant; // Morado oscuro por defecto
    }
  }

  String _getEmotionImagePath(String? emotion) {
    switch (emotion?.toLowerCase()) {
      case 'happy':
        return 'assets/images/emotions/happy.png';
      case 'excited':
        return 'assets/images/emotions/excited.png';
      case 'hopeful':
        return 'assets/images/emotions/hopeful.png';
      case 'grateful':
        return 'assets/images/emotions/grateful.png';
      case 'calm':
        return 'assets/images/emotions/calm.png';
      case 'sad':
        return 'assets/images/emotions/sad.png';
      case 'angry':
        return 'assets/images/emotions/angry.png';
      case 'stressed':
        return 'assets/images/emotions/stressed.png';
      case 'disappointed':
        return 'assets/images/emotions/disappointed.png';
      case 'confused':
        return 'assets/images/emotions/confused.png';
      case 'curious':
        return 'assets/images/emotions/curious.png';
      case 'neutral':
        return 'assets/images/emotions/neutral.png';
      default:
        return 'assets/images/emotions/neutral.png';
    }
  }
}

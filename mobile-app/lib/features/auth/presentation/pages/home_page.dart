import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/auth_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late AnimationController _welcomeAnimationController;
  late Animation<double> _welcomeScaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );

    _welcomeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _welcomeScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _welcomeAnimationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
    
    // Iniciar animación de bienvenida después de un delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _welcomeAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _welcomeAnimationController.dispose();
    super.dispose();
  }

  void _handleSignOut() async {
    print('🚪 Iniciando logout...');
    
    try {
      print('📞 Llamando a AuthNotifier.signOut...');
      
      // Mostrar indicador de carga
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cerrando sesión...'),
            duration: Duration(seconds: 1),
          ),
        );
      }
      
      // Ejecutar logout
      await ref.read(signOutProvider.notifier).signOut();
      
      print('✅ Logout exitoso, navegando al login...');
      
      if (mounted) {
        // Usar addPostFrameCallback para asegurar navegación correcta
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            try {
              // Limpiar el stack de navegación y ir al login
              Navigator.pushNamedAndRemoveUntil(
                context, 
                '/login', 
                (route) => false
              );
              print('✅ Navegación al login exitosa');
            } catch (e) {
              print('⚠️ Error en navegación: $e');
              // Intentar navegación alternativa
              try {
                Navigator.pushReplacementNamed(context, '/login');
                print('✅ Navegación alternativa exitosa');
              } catch (e2) {
                print('❌ Error en navegación alternativa: $e2');
              }
            }
          }
        });
      }
      
    } catch (e) {
      print('❌ Error en logout: $e');
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

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('magneto empleos'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implementar notificaciones
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // TODO: Implementar perfil
            },
          ),
          IconButton(
            icon: ref.watch(signOutProvider).isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.logout),
            onPressed: ref.watch(signOutProvider).isLoading ? null : _handleSignOut,
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: currentUserAsync.when(
        data: (user) {
          if (user == null) {
            // Usuario no autenticado, redirigir a login
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/login');
            });
            return const Center(child: CircularProgressIndicator());
          }

          return AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppConstants.spacingL),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header con saludo personalizado mejorado
                        AnimatedBuilder(
                          animation: _welcomeAnimationController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _welcomeScaleAnimation.value,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(AppConstants.spacingL),
                                decoration: BoxDecoration(
                                  gradient: AppConstants.brandGradient,
                                  borderRadius: BorderRadius.circular(AppConstants.radiusL),
                                  boxShadow: AppConstants.elevatedShadow,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        // Avatar del usuario mejorado
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(AppConstants.radiusM),
                                            border: Border.all(
                                              color: Colors.white.withValues(alpha: 0.3),
                                              width: 2,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 35,
                                          ),
                                        ),
                                        const SizedBox(width: AppConstants.spacingM),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '¡Bienvenido de vuelta! 🎉',
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  color: Colors.white.withValues(alpha: 0.9),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: AppConstants.spacingXS),
                                              Text(
                                                '¡Hola, ${user.fullName?.split(' ').first ?? 'Usuario'}! 👋',
                                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: AppConstants.spacingM),
                                    
                                    // Mensaje de bienvenida personalizado
                                    Container(
                                      padding: const EdgeInsets.all(AppConstants.spacingM),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(AppConstants.radiusM),
                                        border: Border.all(
                                          color: Colors.white.withValues(alpha: 0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.celebration,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          const SizedBox(width: AppConstants.spacingS),
                                          Expanded(
                                            child: Text(
                                              'Es genial verte de nuevo en magneto empleos',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    const SizedBox(height: AppConstants.spacingM),
                                    
                                    // Información del usuario
                                    Container(
                                      padding: const EdgeInsets.all(AppConstants.spacingM),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(AppConstants.radiusM),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.email_outlined,
                                            color: Colors.white.withValues(alpha: 0.8),
                                            size: 20,
                                          ),
                                          const SizedBox(width: AppConstants.spacingS),
                                          Expanded(
                                            child: Text(
                                              user.email,
                                              style: TextStyle(
                                                color: Colors.white.withValues(alpha: 0.8),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: AppConstants.spacingS,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppConstants.successColor,
                                              borderRadius: BorderRadius.circular(AppConstants.radiusS),
                                            ),
                                            child: Text(
                                              'Activo',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        
                        const SizedBox(height: AppConstants.spacingL),
                        
                        // Título de sección
                        Text(
                          'Funcionalidades',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        const SizedBox(height: AppConstants.spacingM),
                        
                        // Grid de funcionalidades
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: AppConstants.spacingM,
                          mainAxisSpacing: AppConstants.spacingM,
                          childAspectRatio: 1.2,
                          children: [
                            _buildFeatureCard(
                              context,
                              icon: Icons.apps_outlined,
                              title: 'Aplicación',
                              subtitle: 'Acceder a todas las funciones',
                              color: AppConstants.primaryColor,
                              onTap: () {
                                Navigator.pushNamed(context, '/main-app');
                              },
                            ),
                            _buildFeatureCard(
                              context,
                              icon: Icons.chat_bubble_outline,
                              title: 'Chats',
                              subtitle: 'Ver conversaciones activas',
                              color: AppConstants.secondaryColor,
                              onTap: () {
                                Navigator.pushNamed(context, '/conversations');
                              },
                            ),
                            _buildFeatureCard(
                              context,
                              icon: Icons.add_photo_alternate_outlined,
                              title: 'Crear Post',
                              subtitle: 'Generar posts con IA',
                              color: AppConstants.successColor,
                              onTap: () {
                                Navigator.pushNamed(context, '/create-post');
                              },
                            ),
                            _buildFeatureCard(
                              context,
                              icon: Icons.auto_stories_outlined,
                              title: 'Crear Historia',
                              subtitle: 'Generar historias con IA',
                              color: AppConstants.warningColor,
                              onTap: () {
                                Navigator.pushNamed(context, '/create-story');
                              },
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: AppConstants.spacingL),
                        
                        // Título de sección
                        Text(
                          'Actividad reciente',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        
                        const SizedBox(height: AppConstants.spacingM),
                        
                        // Lista de actividades
                        _buildActivityList(context),
                        
                        const SizedBox(height: AppConstants.spacingL),
                        
                        // Botón de cerrar sesión
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: ref.watch(signOutProvider).isLoading ? null : _handleSignOut,
                            icon: ref.watch(signOutProvider).isLoading 
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.logout),
                            label: Text(
                              ref.watch(signOutProvider).isLoading 
                                  ? 'Cerrando sesión...' 
                                  : 'Cerrar sesión',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.errorColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppConstants.spacingM,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppConstants.errorColor,
              ),
              const SizedBox(height: AppConstants.spacingM),
              Text(
                'Error al cargar usuario',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppConstants.spacingS),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppConstants.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.spacingL),
              ElevatedButton(
                onPressed: () {
                  ref.refresh(currentUserProvider);
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        boxShadow: AppConstants.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 30,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingM),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.spacingXS),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityList(BuildContext context) {
    final activities = [
      {'title': 'Sesión iniciada', 'time': 'Hace 5 minutos', 'icon': Icons.login, 'color': AppConstants.successColor},
      {'title': 'Perfil actualizado', 'time': 'Hace 1 hora', 'icon': Icons.person, 'color': AppConstants.infoColor},
      {'title': 'Configuración guardada', 'time': 'Hace 2 horas', 'icon': Icons.settings, 'color': AppConstants.primaryColor},
    ];

    return Column(
      children: activities.map((activity) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppConstants.spacingS),
          padding: const EdgeInsets.all(AppConstants.spacingM),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            boxShadow: AppConstants.cardShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (activity['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                ),
                child: Icon(
                  activity['icon'] as IconData,
                  color: activity['color'] as Color,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppConstants.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity['title'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      activity['time'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppConstants.textTertiary,
                size: 20,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

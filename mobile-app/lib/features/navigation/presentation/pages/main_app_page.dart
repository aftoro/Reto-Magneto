import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../conversations/presentation/providers/conversation_provider.dart';
import '../../../conversations/data/models/conversation_entity.dart';
import '../../../conversations/presentation/pages/chat_page.dart';
import '../../../preview/presentation/pages/preview_creation_page.dart';
import '../../../posts/presentation/pages/created_posts_page.dart';
import '../../../posts/presentation/pages/created_stories_page.dart';
import '../../../analytics/presentation/pages/analytics_page.dart';
import '../../../search/presentation/providers/search_provider.dart';
import '../../../../shared/widgets/floating_create_button.dart';

class MainAppPage extends ConsumerStatefulWidget {
  const MainAppPage({super.key});

  @override
  ConsumerState<MainAppPage> createState() => _MainAppPageState();
}

class _MainAppPageState extends ConsumerState<MainAppPage> {
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Obtener argumentos de la ruta para establecer el índice inicial
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
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
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      floatingActionButton: FloatingCreateButton(
        onItemSelected: (item) {
          // Navigate to general creation page for all types (posts, stories, reels)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PreviewCreationPage(
                initialType: item,
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F),
          border: Border(
            top: BorderSide(
              color: const Color(0xFF2D2D2D),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
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
                    icon: Icons.analytics_outlined,
                    activeIcon: Icons.analytics,
                    label: 'Stats',
                    index: 0,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.chat_bubble_outline,
                    activeIcon: Icons.chat_bubble,
                    label: 'Chats',
                    index: 1,
                  ),
                ),
                // Espacio para el botón flotante
                const SizedBox(width: 60),
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.add_photo_alternate_outlined,
                    activeIcon: Icons.add_photo_alternate,
                    label: 'Posts',
                    index: 2,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.auto_stories_outlined,
                    activeIcon: Icons.auto_stories,
                    label: 'Stories',
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
    required IconData icon,
    required IconData activeIcon,
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
          gradient: isActive 
              ? const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)], // Blue gradient for dark mode
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isActive ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive 
                  ? Colors.white
                  : const Color(0xFF6B7280),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive 
                    ? Colors.white
                    : const Color(0xFF6B7280),
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
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

  List<ConversationWithMessages> _getDemoConversations() {
    return [
      ConversationWithMessages(
        conversation: ConversationEntity(
          id: 'demo-1',
          platform: 'instagram',
          conversationType: 'dm',
          userId: 'demo_user_1',
          username: 'juan_perez',
          status: 'active',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
          userFullName: 'Juan Pérez',
          userProfession: 'Desarrollador Full Stack',
          userCurrentEmotion: 'happy',
          userLocation: 'Bogotá, Colombia',
        ),
        lastMessage: MessageEntity(
          id: 'demo-msg-1',
          conversacionId: 'demo-1',
          content: 'Hola! Estoy interesado en la vacante de desarrollador',
          messageType: 'incoming',
          authorName: 'Juan Pérez',
          authorType: 'user',
          createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
          deliveryStatus: 'delivered',
        ),
        unreadCount: 1,
      ),
      ConversationWithMessages(
        conversation: ConversationEntity(
          id: 'demo-2',
          platform: 'instagram',
          conversationType: 'dm',
          userId: 'demo_user_2',
          username: 'maria_garcia',
          status: 'active',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
          userFullName: 'María García',
          userProfession: 'Diseñadora UX/UI',
          userCurrentEmotion: 'excited',
          userLocation: 'Medellín, Colombia',
        ),
        lastMessage: MessageEntity(
          id: 'demo-msg-2',
          conversacionId: 'demo-2',
          content: 'Perfecto! Te envío más información sobre el proceso',
          messageType: 'outgoing',
          authorName: 'Magneto Empleos',
          authorType: 'ai',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
          deliveryStatus: 'sent',
          isAiGenerated: true,
        ),
        unreadCount: 0,
      ),
      ConversationWithMessages(
        conversation: ConversationEntity(
          id: 'demo-3',
          platform: 'instagram',
          conversationType: 'dm',
          userId: 'demo_user_3',
          username: 'carlos_lopez',
          status: 'active',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
          userFullName: 'Carlos López',
          userProfession: 'Product Manager',
          userCurrentEmotion: 'confident',
          userLocation: 'Cali, Colombia',
        ),
        lastMessage: MessageEntity(
          id: 'demo-msg-3',
          conversacionId: 'demo-3',
          content: '¿Cuáles son los beneficios de la empresa?',
          messageType: 'incoming',
          authorName: 'Carlos López',
          authorType: 'user',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          deliveryStatus: 'delivered',
        ),
        unreadCount: 2,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final conversationState = ref.watch(conversationNotifierProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0F0F), // Dark background
              Color(0xFF1A1A1A), // Darker background
            ],
          ),
        ),
        child: SafeArea(
          child: conversationState.when(
            initial: () => const Center(
              child: Text('Inicializando conversaciones...'),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (conversations, stats) => Column(
              children: [
                // Custom Header
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    children: [
                      // Profile Avatar
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)], // Blue gradient for dark mode
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Title and Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Magneto Empleos',
                              style: TextStyle(
                                color: Color(0xFFE5E7EB),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${conversations.length} conversaciones',
                              style: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                        // Connection Status and Refresh Button
                        Row(
                          children: [
                            // Connection Status Indicator
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: conversationState.maybeWhen(
                                  loaded: (_, __) => const Color(0xFF10B981), // Verde cuando hay datos
                                  error: (_) => const Color(0xFFEF4444), // Rojo cuando hay error
                                  orElse: () => const Color(0xFFF59E0B), // Amarillo cuando está cargando
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Refresh Button
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF1F1F1F),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF2D2D2D),
                                  width: 1,
                                ),
                              ),
                              child: IconButton(
                                icon: conversationState.maybeWhen(
                                  loading: () => const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9CA3AF)),
                                    ),
                                  ),
                                  orElse: () => const Icon(
                                    Icons.refresh,
                                    color: Color(0xFF9CA3AF),
                                    size: 20,
                                  ),
                                ),
                                onPressed: conversationState.maybeWhen(
                                  loading: () => null,
                                  orElse: () => () {
                                    ref.read(conversationNotifierProvider.notifier).refreshConversations();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                
                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: _SearchBar(
                    onSearch: (query) {
                      ref.read(searchNotifierProvider.notifier).searchImmediate(query);
                    },
                  ),
                ),
                
                // Conversations List
                Expanded(
                  child: conversations.isEmpty
                      ? _buildEmptyState()
                      : _ConversationsList(conversations: conversations),
                ),
              ],
            ),
                error: (error) => Column(
                  children: [
                    // Offline Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFF59E0B).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.wifi_off,
                            color: Color(0xFFF59E0B),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Modo offline - Mostrando datos de ejemplo',
                              style: TextStyle(
                                color: Color(0xFFF59E0B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(conversationNotifierProvider.notifier).loadConversations();
                            },
                            child: const Text(
                              'Reintentar',
                              style: TextStyle(color: Color(0xFFF59E0B)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Demo Conversations
                    Expanded(
                      child: _ConversationsList(
                        conversations: _getDemoConversations(),
                      ),
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No hay conversaciones',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE5E7EB),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Las conversaciones aparecerán aquí cuando\nrecibas mensajes de usuarios',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF2D2D2D),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(
          color: Color(0xFFE5E7EB),
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Buscar conversaciones y mensajes...',
          hintStyle: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: searchState.maybeWhen(
              loading: () => const Color(0xFF8B5CF6),
              orElse: () => const Color(0xFF6B7280),
            ),
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Color(0xFF6B7280),
                    size: 20,
                  ),
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

class _ConversationsList extends StatelessWidget {
  final List<ConversationWithMessages> conversations;

  const _ConversationsList({required this.conversations});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return _InstagramConversationTile(conversation: conversation);
      },
    );
  }
}

class _InstagramConversationTile extends StatelessWidget {
  final ConversationWithMessages conversation;

  const _InstagramConversationTile({required this.conversation});

  @override
  Widget build(BuildContext context) {
    final username = conversation.conversation.username ?? 
        conversation.conversation.userId.substring(0, 8);
    final lastMessage = conversation.lastMessage?.content ?? 'Sin mensajes';
    final timestamp = conversation.lastMessage?.createdAt ?? 
        conversation.conversation.updatedAt ?? 
        conversation.conversation.createdAt;
    final isActive = conversation.conversation.status == 'active';
    final unreadCount = conversation.unreadCount ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF2D2D2D).withOpacity(0.3),
            width: 0.5,
          ),
        ),
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
            );
          },
          child: Padding(
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
                        gradient: LinearGradient(
                          colors: isActive 
                              ? [const Color(0xFF3B82F6), const Color(0xFF1E40AF)]
                              : [const Color(0xFF6B7280), const Color(0xFF4B5563)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          _getEmotionEmoji(conversation.conversation.userCurrentEmotion),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    // Indicador de estado en línea
                    if (isActive)
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: const Color(0xFF1A1A1A),
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
                              style: const TextStyle(
                                color: Color(0xFFE5E7EB),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (timestamp != null)
                            Text(
                              _formatTimestamp(timestamp),
                              style: const TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 13,
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
                              style: TextStyle(
                                color: unreadCount > 0 
                                    ? const Color(0xFFE5E7EB)
                                    : const Color(0xFF9CA3AF),
                                fontSize: 14,
                                fontWeight: unreadCount > 0 
                                    ? FontWeight.w500 
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (unreadCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              constraints: const BoxConstraints(minWidth: 20),
                              height: 20,
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  unreadCount > 99 ? '99+' : unreadCount.toString(),
                                  style: const TextStyle(
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

  String _getEmotionEmoji(String? emotion) {
    switch (emotion?.toLowerCase()) {
      case 'happy':
      case 'feliz':
        return '😊';
      case 'sad':
      case 'triste':
        return '😢';
      case 'angry':
      case 'enojado':
        return '😠';
      case 'excited':
      case 'emocionado':
        return '🤩';
      case 'calm':
      case 'tranquilo':
        return '😌';
      case 'confused':
      case 'confundido':
        return '😕';
      default:
        return '😐';
    }
  }

}

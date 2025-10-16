import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../conversations/presentation/providers/conversation_provider.dart';
import '../../../conversations/data/models/conversation_entity.dart';
import '../../../conversations/presentation/pages/chat_page.dart';

class ConversationsPage extends ConsumerStatefulWidget {
  const ConversationsPage({super.key});

  @override
  ConsumerState<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends ConsumerState<ConversationsPage> {
  @override
  void initState() {
    super.initState();
    // Cargar conversaciones cuando se inicializa la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(conversationNotifierProvider.notifier).loadConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final conversationState = ref.watch(conversationNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversaciones'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppConstants.brandGradient,
          ),
        ),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(conversationNotifierProvider.notifier).refreshConversations();
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppConstants.backgroundColor,
              Color(0xFFF1F5F9),
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
                // Stats Cards
                Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingL),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatsCard(
                          title: 'Total',
                          value: stats['total']?.toString() ?? '0',
                          icon: Icons.chat_bubble_outline,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingM),
                      Expanded(
                        child: _StatsCard(
                          title: 'Activas',
                          value: stats['active']?.toString() ?? '0',
                          icon: Icons.mark_chat_unread,
                          color: AppConstants.successColor,
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingM),
                      Expanded(
                        child: _StatsCard(
                          title: 'Pendientes',
                          value: stats['pending']?.toString() ?? '0',
                          icon: Icons.schedule,
                          color: AppConstants.warningColor,
                        ),
                      ),
                    ],
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
            error: (error) => Center(
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
                    'Error al cargar conversaciones',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppConstants.spacingS),
                  Text(
                    error,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppConstants.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.spacingL),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(conversationNotifierProvider.notifier).loadConversations();
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
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
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppConstants.textTertiary,
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            'No hay conversaciones',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppConstants.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingS),
          Text(
            'Las conversaciones aparecerán aquí cuando\nrecibas mensajes de usuarios',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppConstants.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatsCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        boxShadow: AppConstants.cardShadow,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: AppConstants.spacingS),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppConstants.textSecondary,
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingL),
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return _ConversationTile(conversation: conversation);
      },
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationWithMessages conversation;

  const _ConversationTile({required this.conversation});

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
      margin: const EdgeInsets.only(bottom: AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        boxShadow: AppConstants.cardShadow,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppConstants.spacingM),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: isActive 
              ? AppConstants.primaryColor 
              : AppConstants.textTertiary,
          child: Text(
            username.substring(0, 1).toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                username,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingS,
                  vertical: AppConstants.spacingXS,
                ),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor,
                  borderRadius: BorderRadius.circular(AppConstants.radiusS),
                ),
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppConstants.spacingXS),
            Text(
              lastMessage,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingXS),
            if (timestamp != null)
              Text(
                _formatTimestamp(timestamp),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppConstants.textTertiary,
                ),
              ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(conversation: conversation),
            ),
          );
        },
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
}

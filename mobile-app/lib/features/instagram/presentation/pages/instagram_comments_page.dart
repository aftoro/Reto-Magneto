import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/instagram_post_entity.dart';
import '../providers/instagram_posts_provider.dart';

class InstagramCommentsPage extends ConsumerStatefulWidget {
  final InstagramPostEntity post;

  const InstagramCommentsPage({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<InstagramCommentsPage> createState() => _InstagramCommentsPageState();
}

class _InstagramCommentsPageState extends ConsumerState<InstagramCommentsPage> {
  @override
  void initState() {
    super.initState();
    // Cargar comentarios solo si no se han cargado antes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(instagramCommentsNotifierProvider.notifier).loadCommentsIfNeeded(widget.post.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final commentsState = ref.watch(instagramCommentsNotifierProvider);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.arrow_left,
            color: AppConstants.textPrimary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comentarios',
              style: GoogleFonts.poppins(
                color: AppConstants.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${widget.post.commentsCount ?? 0} comentarios',
              style: GoogleFonts.poppins(
                color: AppConstants.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppConstants.textTertiary.withOpacity(0.2),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.refresh,
              color: AppConstants.textSecondary,
            ),
            onPressed: () {
              ref.read(instagramCommentsNotifierProvider.notifier).refreshComments(widget.post.id);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Post Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Post Image
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.post.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF833AB4), Color(0xFFE1306C)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 20,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Post Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _truncateText(widget.post.caption, 60),
                        style: GoogleFonts.poppins(
                          color: AppConstants.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTimestamp(widget.post.timestamp),
                        style: GoogleFonts.poppins(
                          color: AppConstants.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Comments List
          Expanded(
            child: commentsState.when(
              initial: () => Center(
                child: Text(
                  'Cargando comentarios...',
                  style: GoogleFonts.poppins(
                    color: AppConstants.textSecondary,
                  ),
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
                ),
              ),
              loaded: (comments, count) => comments.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return _CommentTile(comment: comment);
                      },
                    ),
              error: (error) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.exclamationmark_triangle,
                        size: 64,
                        color: AppConstants.errorColor,
                      ),
                      const SizedBox(height: AppConstants.spacingM),
                      Text(
                        'Error al cargar comentarios',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingS),
                      Text(
                        error,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppConstants.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppConstants.spacingL),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(instagramCommentsNotifierProvider.notifier).refreshComments(widget.post.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              CupertinoIcons.chat_bubble,
              size: 48,
              color: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No hay comentarios',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Los comentarios aparecerán aquí',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppConstants.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
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
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

class _CommentTile extends StatelessWidget {
  final InstagramCommentEntity comment;

  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Comment
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: comment.isAiResponse
                      ? const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : const LinearGradient(
                          colors: [Color(0xFF833AB4), Color(0xFFE1306C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    comment.username.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Comment Content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: comment.isAiResponse
                        ? AppConstants.primaryColor.withOpacity(0.05)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: comment.isAiResponse
                          ? AppConstants.primaryColor.withOpacity(0.2)
                          : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            comment.username,
                            style: GoogleFonts.poppins(
                              color: comment.isAiResponse
                                  ? AppConstants.primaryColor
                                  : AppConstants.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (comment.isAiResponse) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'IA',
                                style: TextStyle(
                                  color: Color(0xFF8B5CF6),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          Text(
                            _formatTimestamp(comment.createdAt),
                            style: GoogleFonts.poppins(
                              color: AppConstants.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      MarkdownBody(
                        data: comment.commentText,
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(
                            color: AppConstants.textPrimary,
                            fontSize: 14,
                            height: 1.4,
                          ),
                          strong: TextStyle(
                            color: AppConstants.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          em: TextStyle(
                            color: AppConstants.textPrimary,
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                          ),
                        ),
                        selectable: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Replies
          if (comment.replies != null && comment.replies!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 44),
              child: Column(
                children: comment.replies!.map((reply) => _ReplyTile(reply: reply)).toList(),
              ),
            ),
          ],
        ],
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
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

class _ReplyTile extends StatelessWidget {
  final InstagramCommentEntity reply;

  const _ReplyTile({required this.reply});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              gradient: reply.isAiResponse
                  ? const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [Color(0xFF6B7280), Color(0xFF9CA3AF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                reply.username.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Reply Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: reply.isAiResponse
                    ? AppConstants.primaryColor.withOpacity(0.05)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: reply.isAiResponse
                      ? AppConstants.primaryColor.withOpacity(0.2)
                      : Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        reply.username,
                        style: GoogleFonts.poppins(
                          color: reply.isAiResponse
                              ? AppConstants.primaryColor
                              : AppConstants.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (reply.isAiResponse) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'IA',
                            style: TextStyle(
                              color: Color(0xFF8B5CF6),
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      Text(
                        _formatTimestamp(reply.createdAt),
                        style: GoogleFonts.poppins(
                          color: AppConstants.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reply.commentText,
                    style: GoogleFonts.poppins(
                      color: AppConstants.textPrimary,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}

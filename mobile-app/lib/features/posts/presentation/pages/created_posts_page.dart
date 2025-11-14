import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import '../../../../core/constants/app_constants.dart';
import '../../../instagram/presentation/providers/instagram_posts_provider.dart';
import '../../../instagram/presentation/pages/instagram_comments_page.dart';
import '../../../instagram/data/models/instagram_post_entity.dart';

class CreatedPostsPage extends ConsumerStatefulWidget {
  const CreatedPostsPage({super.key});

  @override
  ConsumerState<CreatedPostsPage> createState() => _CreatedPostsPageState();
}

class _CreatedPostsPageState extends ConsumerState<CreatedPostsPage> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(instagramPostsNotifierProvider.notifier).loadPostsIfNeeded();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postsState = ref.watch(instagramPostsNotifierProvider);
    
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          // SliverAppBar con blur glass effect como Chats
          SliverAppBar(
            expandedHeight: 70,
            collapsedHeight: 70,
            pinned: true,
            clipBehavior: Clip.none,
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 70,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: AppConstants.textTertiary.withOpacity(0.2),
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
                          color: AppConstants.primaryColor.withOpacity(0.1),
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
                        'Posts',
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
                          ref.read(instagramPostsNotifierProvider.notifier).refreshPosts();
                        },
                        tooltip: 'Actualizar',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Search Bar con estilo Cupertino
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  style: GoogleFonts.poppins(
                    color: AppConstants.textPrimary,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Buscar posts...',
                    hintStyle: GoogleFonts.poppins(
                      color: AppConstants.textTertiary,
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.search,
                      color: _isSearching 
                          ? AppConstants.primaryColor
                          : AppConstants.textTertiary,
                      size: 20,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              CupertinoIcons.clear_circled_solid,
                              color: AppConstants.textTertiary,
                              size: 20,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _isSearching = false;
                              });
                              ref.read(instagramPostsNotifierProvider.notifier).refreshPosts();
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
                    setState(() {
                      _isSearching = value.trim().isNotEmpty;
                    });
                    if (value.trim().isNotEmpty) {
                      ref.read(instagramPostsNotifierProvider.notifier).searchPosts(query: value);
                    } else {
                      ref.read(instagramPostsNotifierProvider.notifier).refreshPosts();
                    }
                  },
                ),
              ),
            ),
          ),
          
          // Posts List
          postsState.when(
            initial: () => const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5B1DF4)),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Cargando posts...',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            loading: () => SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Cargando posts...',
                        style: GoogleFonts.poppins(
                          color: AppConstants.textSecondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            loaded: (posts, pagination) => posts.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6), // Gris claro para light mode
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                CupertinoIcons.photo,
                                color: AppConstants.textSecondary,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No hay posts',
                              style: GoogleFonts.poppins(
                                color: AppConstants.textPrimary, // Texto negro para light mode
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Crea tu primer post para comenzar',
                              style: GoogleFonts.poppins(
                                color: AppConstants.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(20, index == 0 ? 8 : 4, 20, 4),
                          child: _buildPostTile(posts[index]),
                        );
                      },
                      childCount: posts.length,
                    ),
                  ),
            error: (error) => SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        CupertinoIcons.exclamationmark_triangle,
                        color: AppConstants.errorColor,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar posts',
                        style: GoogleFonts.poppins(
                          color: AppConstants.textPrimary, // Texto negro para light mode
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Verifica tu conexión e intenta de nuevo',
                        style: GoogleFonts.poppins(
                          color: AppConstants.textSecondary,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          ref.read(instagramPostsNotifierProvider.notifier).refreshPosts();
                        },
                        icon: const Icon(CupertinoIcons.refresh),
                        label: const Text('Reintentar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5B1DF4),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
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
    );
  }

  Widget _buildPostTile(InstagramPostEntity post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco para light mode
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB), // Borde gris claro
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // Sombra suave para light mode
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InstagramCommentsPage(post: post),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Sombra suave para light mode
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                    child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: post.imageUrl.isNotEmpty
                        ? Image.network(
                            post.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: const Color(0xFFF3F4F6), // Gris claro para light mode
                                child: Center(
                                  child: _getMediaTypeIcon(post.mediaType, size: 24),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: const Color(0xFFF3F4F6), // Gris claro para light mode
                            child: Center(
                              child: _getMediaTypeIcon(post.mediaType, size: 24),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.caption.length > 50 
                            ? '${post.caption.substring(0, 50)}...' 
                            : post.caption,
                        style: GoogleFonts.poppins(
                          color: AppConstants.textPrimary, // Texto negro para light mode
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/comments.svg',
                            width: 16,
                            height: 16,
                            fit: BoxFit.contain,
                            colorFilter: ColorFilter.mode(
                              AppConstants.textPrimary,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${post.commentsCount ?? 0} comentarios',
                            style: GoogleFonts.poppins(
                              color: AppConstants.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          SvgPicture.asset(
                            'assets/icons/like.svg',
                            width: 16,
                            height: 16,
                            fit: BoxFit.contain,
                            colorFilter: ColorFilter.mode(
                              AppConstants.errorColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${post.likesCount ?? 0} likes',
                            style: GoogleFonts.poppins(
                              color: AppConstants.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(CupertinoIcons.chevron_right, color: AppConstants.textSecondary, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getMediaTypeIcon(String mediaType, {double size = 24}) {
    String iconPath;
    final upperMediaType = mediaType.toUpperCase();
    
    if (upperMediaType == 'REEL' || upperMediaType == 'VIDEO') {
      iconPath = 'assets/icons/reel.svg';
    } else {
      // IMAGE o cualquier otro tipo
      iconPath = 'assets/icons/media.svg';
    }
    
    return SvgPicture.asset(
      iconPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        AppConstants.textSecondary,
        BlendMode.srcIn,
      ),
    );
  }
}

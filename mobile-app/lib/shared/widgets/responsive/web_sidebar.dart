import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../core/config/app_router.dart';

/// Sidebar de navegación para web
class WebSidebar extends ConsumerWidget {
  final int currentIndex;
  final Function(int) onItemSelected;
  final double? width;

  const WebSidebar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
    this.width,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sidebarWidth = width ?? context.sidebarWidth;
    final authState = ref.watch(signOutProvider);

    return Container(
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: AppConstants.textTertiary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo y título
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingL),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                    color: AppConstants.primaryColor.withOpacity(0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      'assets/images/logo_m.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingM),
                Expanded(
                  child: Text(
                    'Magneto',
                    style: GoogleFonts.poppins(
                      color: AppConstants.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Divider(
            color: AppConstants.textTertiary.withValues(alpha: 0.2),
            height: 1,
          ),
          
          // Items de navegación
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingM),
              children: [
                _buildNavItem(
                  context: context,
                  svgPath: 'assets/icons/charts.svg',
                  label: AppStrings.stats,
                  index: 0,
                ),
                _buildNavItem(
                  context: context,
                  svgPath: 'assets/icons/chat.svg',
                  label: AppStrings.conversations,
                  index: 1,
                ),
                _buildNavItem(
                  context: context,
                  svgPath: 'assets/icons/media.svg',
                  label: AppStrings.posts,
                  index: 2,
                ),
                _buildNavItem(
                  context: context,
                  svgPath: 'assets/icons/storie.svg',
                  label: AppStrings.stories,
                  index: 3,
                ),
              ],
            ),
          ),
          
          // Botón de cerrar sesión
          Divider(
            color: AppConstants.textTertiary.withValues(alpha: 0.2),
            height: 1,
          ),
          
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            child: _buildLogoutButton(context, ref, authState),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLogoutButton(BuildContext context, WidgetRef ref, AuthState authState) {
    final isLoading = authState.isLoading;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : () => _handleSignOut(context, ref),
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingM,
              vertical: AppConstants.spacingM,
            ),
            child: Row(
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  )
                else
                  SvgPicture.asset(
                    'assets/icons/logout.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.red,
                      BlendMode.srcIn,
                    ),
                  ),
                const SizedBox(width: AppConstants.spacingM),
                Expanded(
                  child: Text(
                    isLoading ? AppStrings.loggingOut : AppStrings.logout,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Future<void> _handleSignOut(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(signOutProvider.notifier).signOut();
      
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouter.login,
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cerrar sesión: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildNavItem({
    required BuildContext context,
    required String svgPath,
    required String label,
    required int index,
  }) {
    final isActive = currentIndex == index;
    
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingM,
        vertical: AppConstants.spacingXS,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? AppConstants.primaryColor.withOpacity(0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: isActive
            ? Border.all(
                color: AppConstants.primaryColor.withOpacity(0.5),
                width: 1,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onItemSelected(index),
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingM,
              vertical: AppConstants.spacingM,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  svgPath,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    isActive
                        ? AppConstants.primaryColor
                        : AppConstants.textSecondary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingM),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isActive
                          ? AppConstants.textPrimary
                          : AppConstants.textSecondary,
                      fontSize: 15,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

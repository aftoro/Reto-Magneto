import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/preview_entity.dart';
import '../providers/preview_provider.dart';
import '../widgets/media_preview_widget.dart';

class PreviewCorrectionsPage extends ConsumerStatefulWidget {
  final PreviewEntity preview;
  final List<String> suggestedCorrections;

  const PreviewCorrectionsPage({
    super.key,
    required this.preview,
    required this.suggestedCorrections,
  });

  @override
  ConsumerState<PreviewCorrectionsPage> createState() => _PreviewCorrectionsPageState();
}

class _PreviewCorrectionsPageState extends ConsumerState<PreviewCorrectionsPage>
    with TickerProviderStateMixin {
  final _captionController = TextEditingController();
  
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _isApplyingCorrections = false;
  bool _isPublishing = false;
  int _selectedTab = 0;
  List<String> _selectedCorrections = [];
  String _customFeedback = '';
  String _textChanges = '';
  String _styleChanges = '';
  String? _selectedCaptionId;
  List<String> _selectedHashtags = [];
  PreviewEntity? _updatedPreview;
  bool _isUpdatingPreview = false;
  double _bottomSheetHeight = 400.0; // Altura inicial del bottom sheet
  double _minSheetHeight = 70.0; // Altura mínima (solo handle y título)
  double _maxSheetHeight = 0.0; // Se calculará en build
  double _dragStartHeight = 0.0;
  double _dragOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _captionController.text = widget.preview.caption;
    
    // Debug: Print preview data
    print('Preview ID: ${widget.preview.id}');
    print('Preview Type: ${widget.preview.type}');
    print('Preview Image URL: ${widget.preview.previewImage}');
    print('Preview Caption: ${widget.preview.caption}');
    
    print('Suggested Corrections: ${widget.suggestedCorrections}');
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _captionController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to preview details state changes
    ref.listen<PreviewDetailsState>(previewDetailsProvider, (previous, next) {
      if (next is PreviewDetailsError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${next.message}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    });
    
    return Container(
      decoration: const BoxDecoration(
        color: AppConstants.backgroundColor, // Fondo blanco para light mode
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildCustomLayout(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomLayout() {
    // Calcular altura máxima disponible (90% de la pantalla menos el header)
    return LayoutBuilder(
      builder: (context, constraints) {
        // Detectar si estamos en web
        final isWeb = MediaQuery.of(context).size.width > 600;
        
        // Verificar que constraints sean válidos
        if (constraints.maxHeight.isInfinite || constraints.maxHeight <= 0) {
          _maxSheetHeight = 600.0; // Fallback
        } else {
          _maxSheetHeight = constraints.maxHeight * 0.9;
        }
        
        // En web, usar un layout diferente con el preview centrado y el bottom sheet a un lado o abajo
        if (isWeb) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preview Section - Ocupa el espacio disponible
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    // Custom Header
                    _buildCustomHeader(),
                    
                    // Instagram Post Preview
                    Expanded(
                      child: _buildPreviewSection(),
                    ),
                  ],
                ),
              ),
              
              // Bottom Sheet - Lado derecho en web
              Container(
                width: 400,
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
                child: _buildCorrectionsBottomSheet(),
              ),
            ],
          );
        }
        
        // Layout móvil original
        return Stack(
          children: [
            // Main Content - Instagram Preview
            Column(
              children: [
                // Custom Header
                _buildCustomHeader(),
                
                // Instagram Post Preview
                Expanded(
                  child: _buildPreviewSection(),
                ),
              ],
            ),
            
            // Bottom Sheet Modal for Corrections - Draggable
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              left: 0,
              right: 0,
              bottom: 0,
              height: _bottomSheetHeight,
              child: _buildCorrectionsBottomSheet(),
            ),
          ],
        );
      },
    );
  }

  // Custom Header
  Widget _buildCustomHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco para light mode
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 0.5,
        ),
      ),
      ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                // Top row with back button and title
                Row(
                  children: [
                    // Back Button - Fixed
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                    child: Icon(
                          Icons.arrow_back_ios,
                      color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                    
                    // Logo
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                    color: const Color(0xFF5B1DF4).withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Image.asset(
                          'assets/images/logo_m.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Title
                    Expanded(
                      child: Text(
                        'Editar ${widget.preview.type == 'post' ? 'Post' : 'Story'}',
                        style: GoogleFonts.poppins(
                      color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                // Status indicator
                if (_isApplyingCorrections || _isPublishing) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                  color: const Color(0xFF5B1DF4).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CupertinoActivityIndicator(
                            color: Color(0xFF5B1DF4),
                            radius: 7,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _isApplyingCorrections ? 'Aplicando correcciones...' : 'Publicando...',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF5B1DF4),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
        ),
      ),
    );
  }

  // Bottom Sheet Modal for Corrections - Draggable Cupertino Style
  Widget _buildCorrectionsBottomSheet() {
    final isWeb = MediaQuery.of(context).size.width > 600;
    
    // En web, el bottom sheet siempre está expandido y ocupa toda la altura
    if (isWeb) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white, // Fondo blanco para light mode
        ),
        child: Column(
          children: [
            // Header sin handle en web
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  // Title
                  Expanded(
                    child: Text(
                      'Herramientas de Edición',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Cupertino Tabs
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade200,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: widget.preview.type == 'story'
                    ? [
                        // Para stories solo mostrar Visual y Revisar
                        _buildCupertinoTab('Visual', 0, CupertinoIcons.eye),
                        _buildCupertinoTab('Revisar', 1, CupertinoIcons.checkmark_circle),
                      ]
                    : [
                        // Para posts y reels mostrar todos los tabs
                        _buildCupertinoTab('Sugerencias', 0, CupertinoIcons.lightbulb),
                        _buildCupertinoTab('Visual', 1, CupertinoIcons.eye),
                        _buildCupertinoTab('Texto', 2, CupertinoIcons.textformat),
                        _buildCupertinoTab('Revisar', 3, CupertinoIcons.checkmark_circle),
                      ],
              ),
            ),
            
            // Tab Content - Scrollable
            Expanded(
              child: ClipRect(
                child: _buildTabContent(),
              ),
            ),
          ],
        ),
      );
    }
    
    // Layout móvil original con draggable
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco para light mode
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cupertino Handle and Header - Draggable Area
          GestureDetector(
            onVerticalDragStart: (details) {
              _dragStartHeight = _bottomSheetHeight;
              _dragOffset = 0;
            },
            onVerticalDragUpdate: (details) {
              setState(() {
                // Acumular el offset del drag
                _dragOffset -= details.delta.dy;
                // Calcular nueva altura
                double newHeight = _dragStartHeight + _dragOffset;
                // Aplicar con clamp
                _bottomSheetHeight = newHeight.clamp(_minSheetHeight, _maxSheetHeight);
              });
            },
            onVerticalDragEnd: (details) {
              // Snap a posiciones específicas basadas en la velocidad y posición
              setState(() {
                final velocity = details.primaryVelocity ?? 0;
                
                // Si hay una velocidad significativa, usar eso para decidir
                if (velocity.abs() > 500) {
                  if (velocity < 0) {
                    // Arrastrado hacia arriba rápido -> expandir al máximo
                    _bottomSheetHeight = _maxSheetHeight;
                  } else {
                    // Arrastrado hacia abajo rápido -> colapsar
                    _bottomSheetHeight = _minSheetHeight;
                  }
                } else {
                  // Snap basado en la posición actual
                  if (_bottomSheetHeight < 150) {
                    _bottomSheetHeight = _minSheetHeight; // Colapsar
                  } else if (_bottomSheetHeight < 500) {
                    _bottomSheetHeight = 400; // Tamaño medio
                  } else if (_bottomSheetHeight < (_maxSheetHeight * 0.7)) {
                    _bottomSheetHeight = 600; // Tamaño grande
                  } else {
                    _bottomSheetHeight = _maxSheetHeight; // Máximo
                  }
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.white, // Fondo blanco para light mode
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Cupertino Handle
                  Container(
                    width: 36,
                    height: 5,
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  
                  // Header Row
                  Row(
                    children: [
                      // Title
                      Expanded(
                        child: Text(
                          'Herramientas de Edición',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                      
                      // Info text
                      Text(
                        'Arrastra para ajustar',
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Cupertino Tabs y Contenido - Solo visible cuando está expandido
          if (_bottomSheetHeight > 150)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Cupertino Tabs
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Fondo blanco para light mode
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade200,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      children: widget.preview.type == 'story'
                          ? [
                              // Para stories solo mostrar Visual y Revisar
                              _buildCupertinoTab('Visual', 0, CupertinoIcons.eye),
                              _buildCupertinoTab('Revisar', 1, CupertinoIcons.checkmark_circle),
                            ]
                          : [
                              // Para posts y reels mostrar todos los tabs
                              _buildCupertinoTab('Sugerencias', 0, CupertinoIcons.lightbulb),
                              _buildCupertinoTab('Visual', 1, CupertinoIcons.eye),
                              _buildCupertinoTab('Texto', 2, CupertinoIcons.textformat),
                              _buildCupertinoTab('Revisar', 3, CupertinoIcons.checkmark_circle),
                            ],
                    ),
                  ),
                  
                  // Tab Content - Scrollable
                  Expanded(
                    child: ClipRect(
                      child: _buildTabContent(),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Preview Section - Instagram Post Style
  Widget _buildPreviewSection() {
    // Usar el preview actualizado si está disponible, sino el original
    final currentPreview = _updatedPreview ?? widget.preview;
    
    return Container(
      color: Colors.white, // Fondo blanco para light mode
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Detectar si estamos en web o pantalla grande
          final isWeb = MediaQuery.of(context).size.width > 600;
          final maxWidth = isWeb ? 600.0 : double.infinity;
          
          return Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                ),
                child: Column(
                  children: [
                    // Instagram Post Container
                    Container(
                      width: double.infinity,
                      color: Colors.white, // Fondo blanco para light mode
                      child: Column(
                        children: [
                          // Instagram Header
                          _buildInstagramHeader(),
                          
                          // Instagram Image
                          _buildInstagramImage(),
                          
                          // Instagram Actions
                          _buildInstagramActions(),
                          
                          // Instagram Caption (solo para posts y reels, no para stories)
                          if (currentPreview.type != 'story')
                            _buildInstagramCaption(),
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
    );
  }

  Widget _buildInstagramHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco para light mode
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Profile Picture - Magneto Logo
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF5B1DF4), // Fondo púrpura Magneto
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo_instagram.jpg',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text(
                      'm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Username
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'magnetoempleos',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Badge de verificación de Instagram
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF0095F6), // Azul de Instagram
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 8,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Hace 2 horas',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // More options
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.more_horiz,
              color: Colors.black,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstagramImage() {
    // Usar el preview actualizado si está disponible, sino el original
    final currentPreview = _updatedPreview ?? widget.preview;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // En web, limitar el tamaño máximo del preview
        final isWeb = MediaQuery.of(context).size.width > 600;
        final maxSize = isWeb ? 600.0 : constraints.maxWidth;
        
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxSize,
              maxHeight: maxSize,
            ),
            child: AspectRatio(
              aspectRatio: currentPreview.type == 'story' ? 9 / 16 : 1.0, // Stories: formato vertical 9:16, Posts/Reels: 1:1
              child: Stack(
                children: [
                  // Media principal (imagen o video)
                  MediaPreviewWidget(
                    mediaUrl: currentPreview.type == 'reel' && currentPreview.videoUrl != null && currentPreview.videoUrl!.isNotEmpty
                        ? currentPreview.videoUrl!
                        : currentPreview.previewImage,
                    aspectRatio: currentPreview.type == 'story' ? 9 / 16 : 1.0, // Stories: formato vertical 9:16
                  ),
                  
                  // Overlay de loading cuando se están aplicando correcciones
                  if (_isUpdatingPreview)
                    Container(
                      color: Colors.white.withOpacity(0.9),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5B1DF4)),
                              strokeWidth: 3,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Aplicando correcciones...',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'La IA está generando una nueva versión',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ],
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
  }

  Widget _buildInstagramActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco para light mode
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Like button
          GestureDetector(
            onTap: () {},
            child: Icon(
              CupertinoIcons.heart,
              color: Colors.black,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          
          // Comment button
          GestureDetector(
            onTap: () {},
            child: Icon(
              CupertinoIcons.chat_bubble,
              color: Colors.black,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          
          // Share button
          GestureDetector(
            onTap: () {},
            child: Icon(
              CupertinoIcons.paperplane,
              color: Colors.black,
              size: 24,
            ),
          ),
          
          const Spacer(),
          
          // Save button
          GestureDetector(
            onTap: () {},
            child: Icon(
              CupertinoIcons.bookmark,
              color: Colors.black,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstagramCaption() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco para light mode
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'magnetoempleos ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(left: 2, right: 2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF0095F6), // Azul de Instagram
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 8,
                    ),
                  ),
                ),
                const TextSpan(text: ' '),
                TextSpan(
                  text: _captionController.text.isNotEmpty 
                      ? _captionController.text
                      : widget.preview.caption,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Show selected hashtags
          if (_selectedHashtags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: _selectedHashtags.map((hashtag) {
                return Text(
                  hashtag,
                  style: const TextStyle(
                    color: Color(0xFF5B1DF4),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
          ],
          
          // Mostrar indicador de actualización en el caption
          if (_isUpdatingPreview) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5B1DF4)),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Actualizando contenido...',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
          
        ],
      ),
    );
  }




  // Cupertino Style Tab
  Widget _buildCupertinoTab(String title, int index, IconData icon) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected 
                ? const Color(0xFF5B1DF4).withOpacity(0.15) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected 
                    ? const Color(0xFF5B1DF4) 
                    : const Color(0xFF9CA3AF),
                size: 18,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: isSelected 
                      ? const Color(0xFF5B1DF4) 
                      : const Color(0xFF9CA3AF),
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  letterSpacing: -0.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTabContent() {
    // Para stories, mapear los índices: 0 = Visual, 1 = Revisar
    if (widget.preview.type == 'story') {
      switch (_selectedTab) {
        case 0:
          return _buildVisualTab();
        case 1:
          return _buildReviewTab();
        default:
          return const SizedBox.shrink();
      }
    }
    
    // Para posts y reels, usar los índices originales
    switch (_selectedTab) {
      case 0:
        return _buildSuggestionsTab();
      case 1:
        return _buildVisualTab();
      case 2:
        return _buildTextTab();
      case 3:
        return _buildReviewTab();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSuggestionsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sugerencias de IA',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
          ..._getRealSuggestions().map((suggestion) {
            final isSelected = _selectedCorrections.contains(suggestion['title']);
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => _toggleCorrection(suggestion['title']),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? const Color(0xFF5B1DF4).withOpacity(0.15)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected 
                                ? const Color(0xFF5B1DF4)
                                : Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: isSelected 
                                        ? const Color(0xFF5B1DF4)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: isSelected 
                                          ? const Color(0xFF5B1DF4)
                                          : Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          CupertinoIcons.checkmark,
                                          color: Colors.white,
                                          size: 14,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    suggestion['title'],
                                    style: TextStyle(
                                      color: isSelected ? const Color(0xFF5B1DF4) : Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getCategoryColor(suggestion['category']).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    suggestion['category'],
                                    style: TextStyle(
                                      color: _getCategoryColor(suggestion['category']),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (suggestion['description'].isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                suggestion['description'],
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ],
                            if (suggestion['impact'].isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.trending_up,
                                    color: Colors.green.shade600,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      suggestion['impact'],
                                      style: TextStyle(
                                        color: Colors.green.shade600,
                                        fontSize: 11,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getRealSuggestions() {
    // Usar el preview actualizado si está disponible, sino el original
    final currentPreview = _updatedPreview ?? widget.preview;
    
    // Extraer sugerencias reales del preview si están disponibles
    if (currentPreview.metadata != null && 
        currentPreview.metadata!['improve_suggestions'] != null) {
      final suggestions = currentPreview.metadata!['improve_suggestions'] as List;
      print('DEBUG: Raw suggestions from API: $suggestions');
      return suggestions.map((s) {
        if (s is Map<String, dynamic>) {
          return {
            'title': s['title']?.toString() ?? 'Sugerencia',
            'description': s['description']?.toString() ?? '',
            'category': s['category']?.toString() ?? 'General',
            'priority': s['priority']?.toString() ?? 'medium',
            'impact': s['impact']?.toString() ?? '',
          };
        }
        // Si es un string, intentar parsearlo como diccionario de string
        if (s is String) {
          try {
            // Remover llaves y parsear como diccionario de string
            String cleanString = s.replaceAll('{', '').replaceAll('}', '');
            Map<String, String> parsed = {};
            
            // Dividir por comas pero respetando las comas dentro de los valores
            List<String> parts = [];
            String current = '';
            bool inQuotes = false;
            
            for (int i = 0; i < cleanString.length; i++) {
              if (cleanString[i] == '"' || cleanString[i] == "'") {
                inQuotes = !inQuotes;
              } else if (cleanString[i] == ',' && !inQuotes) {
                parts.add(current.trim());
                current = '';
                continue;
              }
              current += cleanString[i];
            }
            if (current.trim().isNotEmpty) {
              parts.add(current.trim());
            }
            
            // Parsear cada parte
            for (String part in parts) {
              final colonIndex = part.indexOf(':');
              if (colonIndex > 0) {
                String key = part.substring(0, colonIndex).trim();
                String value = part.substring(colonIndex + 1).trim();
                // Remover comillas si las tiene
                if (value.startsWith('"') && value.endsWith('"')) {
                  value = value.substring(1, value.length - 1);
                }
                parsed[key] = value;
              }
            }
            
            return {
              'title': parsed['title'] ?? s,
              'description': parsed['description'] ?? '',
              'category': parsed['category'] ?? 'General',
              'priority': parsed['priority'] ?? 'medium',
              'impact': parsed['impact'] ?? '',
            };
          } catch (e) {
            // Si no se puede parsear, usar el string como título
            return {
              'title': s,
              'description': '',
              'category': 'General',
              'priority': 'medium',
              'impact': '',
            };
          }
        }
        return {
          'title': s.toString(),
          'description': '',
          'category': 'General',
          'priority': 'medium',
          'impact': '',
        };
      }).toList();
    }
    
    // Fallback a sugerencias mock si no hay datos reales
    return [
      {
        'title': 'Mejorar el contraste de colores para mayor legibilidad',
        'description': 'Ajustar los colores para mejorar la visibilidad del texto',
        'category': 'Visual',
        'priority': 'high',
        'impact': 'Mayor legibilidad y accesibilidad',
      },
      {
        'title': 'Agregar más información sobre beneficios salariales',
        'description': 'Incluir datos específicos sobre salarios en el sector',
        'category': 'Contenido',
        'priority': 'medium',
        'impact': 'Mayor engagement y credibilidad',
      },
      {
        'title': 'Incluir testimonios de profesionales exitosos',
        'description': 'Añadir casos de éxito y experiencias reales',
        'category': 'Contenido',
        'priority': 'high',
        'impact': 'Mayor confianza y conexión emocional',
      },
    ];
  }

  List<Map<String, dynamic>> _getRealCaptionOptions() {
    // Usar el preview actualizado si está disponible, sino el original
    final currentPreview = _updatedPreview ?? widget.preview;
    
    // Extraer opciones de caption reales del preview si están disponibles
    if (currentPreview.metadata != null && 
        currentPreview.metadata!['suggested_caption'] != null) {
      final captionData = currentPreview.metadata!['suggested_caption'] as Map<String, dynamic>;
      if (captionData['captions'] is List) {
        final captions = captionData['captions'] as List;
        return captions.map((caption) {
          if (caption is Map<String, dynamic>) {
            return {
              'id': caption['id'] ?? 'option_${captions.indexOf(caption) + 1}',
              'title': caption['title'] ?? 'Opción ${captions.indexOf(caption) + 1}',
              'content': caption['content'] ?? '',
              'style': caption['style'] ?? 'Estilo personalizado',
              'hashtags': caption['hashtags'] is List 
                  ? List<String>.from(caption['hashtags'])
                  : <String>[],
              'call_to_action': caption['call_to_action'] ?? '¡Acción!'
            };
          }
          return null;
        }).where((item) => item != null).cast<Map<String, dynamic>>().toList();
      }
    }
    
    // Fallback a opciones mock si no hay datos reales
    return [
      {
        'id': 'option_1',
        'title': 'Opción Profesional',
        'content': 'Construyendo el futuro con React en Google...',
        'style': 'Profesional y directo',
        'hashtags': ['#ReactDeveloper', '#Google', '#TechJobs'],
        'call_to_action': '¡Aplica ahora!'
      },
      {
        'id': 'option_2',
        'title': 'Opción Personal',
        'content': 'Mi día a día en Google desarrollando con React...',
        'style': 'Personal y motivacional',
        'hashtags': ['#GoogleLife', '#ReactDev', '#CareerGrowth'],
        'call_to_action': '¡Comparte tu experiencia!'
      },
      {
        'id': 'option_3',
        'title': 'Opción Creativa',
        'content': '🚀 React + Google = Innovación pura...',
        'style': 'Creativo y llamativo',
        'hashtags': ['#React', '#GoogleTech', '#Innovation'],
        'call_to_action': '¡Comenta si te interesa!'
      }
    ];
  }

  Widget _buildVisualTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Selecciones Visuales',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Visual Selection Tools
                  _buildVisualSelectionTools(),
                  const SizedBox(height: 20),
                  
                  // Feedback Visual
                  Text(
                    'Feedback Visual',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: (value) => setState(() => _customFeedback = value),
                    maxLines: 3,
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Describe los cambios visuales que quieres aplicar...',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF5B1DF4)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Style Changes
                  Text(
                    'Cambios de Estilo',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: (value) => setState(() => _styleChanges = value),
                    maxLines: 3,
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Especifica cambios de estilo, colores, tipografía...',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF5B1DF4)),
                      ),
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

  Widget _buildVisualSelectionTools() {
    // Comentado temporalmente - Herramientas de selección
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Las herramientas de selección visual estarán disponibles próximamente',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
    
    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Text(
    //       'Herramientas de Selección',
    //       style: TextStyle(
    //         color: Colors.white,
    //         fontSize: 12,
    //         fontWeight: FontWeight.w600,
    //       ),
    //     ),
    //     const SizedBox(height: 8),
    //     Wrap(
    //       spacing: 8,
    //       runSpacing: 8,
    //       children: [
    //         _buildSelectionTool('Rectángulo', Icons.crop_square, () {}),
    //         _buildSelectionTool('Círculo', Icons.radio_button_unchecked, () {}),
    //         _buildSelectionTool('Texto', Icons.text_fields, () {}),
    //         _buildSelectionTool('Imagen', Icons.image, () {}),
    //         _buildSelectionTool('Color', Icons.palette, () {}),
    //         _buildSelectionTool('Tamaño', Icons.aspect_ratio, () {}),
    //       ],
    //     ),
    //     const SizedBox(height: 12),
    //     Container(
    //       padding: const EdgeInsets.all(12),
    //       decoration: BoxDecoration(
    //         color: const Color(0xFF2D2D2D),
    //         borderRadius: BorderRadius.circular(8),
    //         border: Border.all(
    //           color: const Color(0xFF4B5563),
    //         ),
    //       ),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             'Áreas Seleccionadas',
    //             style: TextStyle(
    //               color: Colors.white,
    //               fontSize: 12,
    //               fontWeight: FontWeight.w600,
    //             ),
    //           ),
    //           const SizedBox(height: 8),
    //           Text(
    //             'Toca y arrastra en la imagen para seleccionar áreas específicas',
    //             style: TextStyle(
    //               color: Colors.grey[400],
    //               fontSize: 10,
    //             ),
    //           ),
    //           const SizedBox(height: 8),
    //           Row(
    //             children: [
    //               Icon(
    //                 Icons.touch_app,
    //                 color: Colors.grey[400],
    //                 size: 16,
    //               ),
    //               const SizedBox(width: 8),
    //               Text(
    //                 'Selecciona elementos para editarlos',
    //                 style: TextStyle(
    //                   color: Colors.grey[400],
    //                   fontSize: 10,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }

  // Comentado temporalmente - Herramientas de selección
  // Widget _buildSelectionTool(String label, IconData icon, VoidCallback onTap) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //       decoration: BoxDecoration(
  //         color: const Color(0xFF2D2D2D),
  //         borderRadius: BorderRadius.circular(6),
  //         border: Border.all(
  //           color: const Color(0xFF4B5563),
  //         ),
  //       ),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Icon(
  //             icon,
  //             color: Colors.white,
  //             size: 14,
  //           ),
  //           const SizedBox(width: 6),
  //           Text(
  //             label,
  //             style: const TextStyle(
  //               color: Colors.white,
  //               fontSize: 10,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildReviewTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Revisar y Publicar',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Resumen de Correcciones
                  _buildCorrectionsSummary(),
                  const SizedBox(height: 20),
                  
                  // Resumen de Caption (solo para posts y reels, no para stories)
                  if (widget.preview.type != 'story') ...[
                    _buildCaptionSummary(),
                    const SizedBox(height: 20),
                  ],
                  
                  // Acciones
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorrectionsSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_fix_high,
                color: const Color(0xFF5B1DF4),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Correcciones Seleccionadas',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_selectedCorrections.isEmpty)
            Text(
              'No hay correcciones seleccionadas',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            )
          else
            Column(
              children: _selectedCorrections.map((correction) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5B1DF4).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFF5B1DF4).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: const Color(0xFF5B1DF4),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          correction,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildCaptionSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.text_fields,
                color: Colors.green.shade600,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Caption Final',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              _captionController.text.isNotEmpty 
                  ? _captionController.text
                  : 'No se ha editado el caption',
              style: TextStyle(
                color: _captionController.text.isNotEmpty 
                    ? Colors.black 
                    : Colors.grey.shade600,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Apply Corrections Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _applyCorrections,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5B1DF4),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isApplyingCorrections)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else
                  const Icon(Icons.auto_fix_high, size: 20),
                const SizedBox(width: 8),
                Text(
                  _isApplyingCorrections 
                      ? 'Aplicando Correcciones...' 
                      : 'Aplicar Correcciones (${_selectedCorrections.length})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        
        // Publish Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _showPublishDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isPublishing)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else
                  const Icon(Icons.publish, size: 20),
                const SizedBox(width: 8),
                Text(
                  _isPublishing ? 'Publicando...' : 'Publicar',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Opciones de Caption',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Caption Options
                  _buildCaptionOptions(),
                  const SizedBox(height: 20),
                  
                  // Custom Caption Editor
                  Text(
                    'Editor Personalizado',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _captionController,
                    maxLines: 4,
                    maxLength: 2200,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      height: 1.4,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Escribe tu caption personalizado...',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF5B1DF4)),
                      ),
                      counterStyle: TextStyle(
                        color: _captionController.text.length > 2000 
                            ? Colors.red 
                            : Colors.grey.shade600,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Text Changes
                  Text(
                    'Cambios de Texto',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: (value) => setState(() => _textChanges = value),
                    maxLines: 3,
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Especifica cambios de texto, tono, mensaje...',
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF5B1DF4)),
                      ),
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

  Widget _buildCaptionOptions() {
    final captionOptions = _getRealCaptionOptions();

    if (captionOptions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.grey.shade600, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'No hay opciones de caption disponibles. Las opciones aparecerán después de generar el preview.',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: captionOptions.map((option) {
        final isSelected = _selectedCaptionId == option['id'];
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedCaptionId = option['id'] as String;
                _captionController.text = option['content'] as String;
                _selectedHashtags = List<String>.from(option['hashtags'] as List<String>);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected 
                    ? const Color(0xFF5B1DF4).withOpacity(0.15)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected 
                      ? const Color(0xFF5B1DF4)
                      : Colors.grey.shade200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? const Color(0xFF5B1DF4)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                            color: isSelected 
                                ? const Color(0xFF5B1DF4)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 10,
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        option['title'] as String,
                        style: TextStyle(
                          color: isSelected ? const Color(0xFF5B1DF4) : Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        option['style'] as String,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    option['content'] as String,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF5B1DF4) : Colors.black,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: (option['hashtags'] as List<String>).map((hashtag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? const Color(0xFF5B1DF4).withOpacity(0.2)
                              : const Color(0xFF5B1DF4).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          hashtag,
                          style: TextStyle(
                            color: const Color(0xFF5B1DF4),
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'CTA: ${option['call_to_action']}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _toggleCorrection(String correction) {
    setState(() {
      if (_selectedCorrections.contains(correction)) {
        _selectedCorrections.remove(correction);
      } else {
        _selectedCorrections.add(correction);
      }
    });
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'visual':
        return const Color(0xFF8B5CF6); // Purple
      case 'contenido':
        return const Color(0xFF10B981); // Green
      case 'engagement':
        return const Color(0xFFF59E0B); // Orange
      case 'técnico':
        return const Color(0xFF3B82F6); // Blue
      case 'estrategia':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  Future<void> _applyCorrections() async {
    if (_selectedCorrections.isEmpty && 
        _customFeedback.trim().isEmpty &&
        _textChanges.trim().isEmpty &&
        _styleChanges.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona al menos una corrección o agrega feedback'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isApplyingCorrections = true;
      _isUpdatingPreview = true; // Activar loading en la preview
    });

    try {
      final request = ApplyCorrectionsRequest(
        corrections: _selectedCorrections,
        visualFeedback: _customFeedback.trim().isNotEmpty 
            ? _customFeedback.trim() 
            : null,
        textChanges: _textChanges.trim().isNotEmpty 
            ? _textChanges.trim() 
            : null,
        styleChanges: _styleChanges.trim().isNotEmpty 
            ? _styleChanges.trim() 
            : null,
      );

      final result = await ref.read(previewDetailsProvider.notifier).applyCorrections(
        widget.preview.id,
        request,
      );

      // Actualizar el preview con los nuevos datos si hay resultado
      if (result != null) {
        setState(() {
          // Guardar el preview actualizado
          _updatedPreview = result;
          
          // Actualizar el caption en el controlador
          _captionController.text = result.caption;
        });
        
        // Mostrar mensaje de actualización
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preview actualizado con las correcciones aplicadas'),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Clear form
      _selectedCorrections.clear();
      _customFeedback = '';
      _textChanges = '';
      _styleChanges = '';

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Correcciones aplicadas exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al aplicar correcciones: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isApplyingCorrections = false;
        _isUpdatingPreview = false; // Desactivar loading en la preview
      });
    }
  }

  void _showPublishDialog() {
    final isWeb = MediaQuery.of(context).size.width > 600;
    
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isWeb ? 500 : double.infinity,
            maxHeight: isWeb ? (MediaQuery.of(context).size.height * 0.9) : double.infinity,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header con icono
              Container(
                padding: EdgeInsets.all(isWeb ? 32 : 24),
                decoration: BoxDecoration(
                  color: const Color(0xFF5B1DF4).withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: isWeb ? 64 : 56,
                      height: isWeb ? 64 : 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5B1DF4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        CupertinoIcons.check_mark_circled_solid,
                        color: Colors.white,
                        size: isWeb ? 36 : 32,
                      ),
                    ),
                    SizedBox(height: isWeb ? 20 : 16),
                    Text(
                      'Publicar Contenido',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: isWeb ? 24 : 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: isWeb ? 12 : 8),
                    Text(
                      '¿Estás seguro de que quieres publicar este ${widget.preview.type}?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                        fontSize: isWeb ? 16 : 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Contenido
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isWeb ? 32 : 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _captionController,
                        maxLines: isWeb ? 6 : 4,
                        maxLength: 2200,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: isWeb ? 15 : 14,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Caption final (opcional)',
                          labelStyle: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                            fontSize: isWeb ? 15 : 14,
                          ),
                          hintText: 'Escribe el caption que se publicará...',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey.shade400,
                            fontSize: isWeb ? 15 : 14,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF5B1DF4),
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(isWeb ? 20 : 16),
                          counterStyle: TextStyle(
                            color: _captionController.text.length > 2000 
                                ? Colors.red 
                                : Colors.grey.shade600,
                            fontSize: isWeb ? 13 : 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Botones
              Container(
                padding: EdgeInsets.all(isWeb ? 24 : 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: isWeb ? 16 : 14,
                            horizontal: isWeb ? 24 : 16,
                          ),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancelar',
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade700,
                            fontSize: isWeb ? 17 : 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: isWeb ? 16 : 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _publishContent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5B1DF4),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: isWeb ? 16 : 14,
                            horizontal: isWeb ? 24 : 16,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.paperplane_fill,
                              size: isWeb ? 20 : 18,
                            ),
                            SizedBox(width: isWeb ? 10 : 8),
                            Text(
                              'Publicar',
                              style: GoogleFonts.poppins(
                                fontSize: isWeb ? 17 : 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
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
  }

  Future<void> _publishContent() async {
    Navigator.pop(context); // Close dialog
    
    setState(() {
      _isPublishing = true;
    });

    try {
      // Obtener el caption final - usar el seleccionado o el personalizado
      String finalCaption = '';
      
      if (_selectedCaptionId != null) {
        // Usar el caption seleccionado de las opciones
        final captionOptions = _getRealCaptionOptions();
        final selectedOption = captionOptions.firstWhere(
          (option) => option['id'] == _selectedCaptionId,
          orElse: () => captionOptions.first,
        );
        finalCaption = selectedOption['content'] ?? '';
        
        // Agregar hashtags si están seleccionados
        if (_selectedHashtags.isNotEmpty) {
          finalCaption += '\n\n${_selectedHashtags.join(' ')}';
        }
      } else if (_captionController.text.trim().isNotEmpty) {
        // Usar el caption personalizado
        finalCaption = _captionController.text.trim();
      } else {
        // Fallback al caption original del preview
        finalCaption = widget.preview.caption;
      }
      
      print('DEBUG: Publishing with final caption: $finalCaption');
      
      final request = PublishPreviewRequest(
        finalCaption: finalCaption.isNotEmpty ? finalCaption : null,
      );

      await ref.read(previewDetailsProvider.notifier).publishPreview(
        widget.preview.id,
        request,
      );

      // Actualizar estado ANTES de navegar para evitar que se quede cargando
      if (mounted) {
        setState(() {
          _isPublishing = false;
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contenido publicado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to main app
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/main-app',
          (route) => false,
          arguments: {'initialIndex': widget.preview.type == 'post' ? 2 : 3},
        );
      }
    } catch (e) {
      print('DEBUG: Error publishing: $e');
      
      // Actualizar estado en caso de error también
      if (mounted) {
        setState(() {
          _isPublishing = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al publicar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

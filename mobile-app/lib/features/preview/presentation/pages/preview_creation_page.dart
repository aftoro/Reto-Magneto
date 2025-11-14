import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/preview_entity.dart';
import '../providers/preview_provider.dart';
import '../providers/reel_generation_monitor_provider.dart';
import '../widgets/preview_skeleton_loader.dart';
import 'preview_corrections_page.dart';
import 'reel_preview_page.dart';
import 'previews_list_page.dart';
import '../widgets/media_preview_widget.dart';

class PreviewCreationPage extends ConsumerStatefulWidget {
  final String? initialType;
  
  const PreviewCreationPage({
    super.key,
    this.initialType,
  });

  @override
  ConsumerState<PreviewCreationPage> createState() => _PreviewCreationPageState();
}

class _PreviewCreationPageState extends ConsumerState<PreviewCreationPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _picker = ImagePicker();
  
  PreviewType _selectedType = PreviewType.post;
  PreviewStyle _selectedStyle = PreviewStyle.modern;
  TargetAudience _selectedAudience = TargetAudience.jobSeekers;
  String? _selectedImagePath;
  
  // Campos específicos para reels
  String _selectedAccent = 'neutral';
  int _selectedDuration = 8;
  String _selectedReelStyle = 'moderno_profesional';
  
  // Guardar el tema del reel para el monitoreo
  String? _currentReelTopic;
  
  // Opciones para los dropdowns de reels
  final List<Map<String, String>> _accentOptions = [
    {'value': 'neutral', 'label': 'Neutral'},
    {'value': 'mexicano', 'label': 'Mexicano'},
    {'value': 'español', 'label': 'Español'},
    {'value': 'argentino', 'label': 'Argentino'},
    {'value': 'colombiano', 'label': 'Colombiano'},
  ];

  final List<Map<String, dynamic>> _durationOptions = [
    {'value': 3, 'label': '3 segundos'},
    {'value': 4, 'label': '4 segundos'},
    {'value': 5, 'label': '5 segundos'},
    {'value': 6, 'label': '6 segundos'},
    {'value': 7, 'label': '7 segundos'},
    {'value': 8, 'label': '8 segundos'},
  ];

  // Opciones de estilo visual específicas para reels
  final List<Map<String, String>> _reelStyleOptions = [
    {'value': 'moderno_profesional', 'label': 'Moderno y Profesional'},
    {'value': 'corporativo', 'label': 'Corporativo'},
    {'value': 'minimalista', 'label': 'Minimalista'},
    {'value': 'realista', 'label': 'Realista'},
    {'value': 'caricaturesco', 'label': 'Caricaturesco'},
    {'value': 'dinamico', 'label': 'Dinámico'},
    {'value': 'ilustrativo', 'label': 'Ilustrativo'},
    {'value': 'elegante', 'label': 'Elegante'},
    {'value': 'tech', 'label': 'Tech'},
    {'value': 'vibrante', 'label': 'Vibrante'},
    {'value': 'profesional', 'label': 'Profesional'},
    {'value': 'creativo', 'label': 'Creativo'},
    {'value': 'audaz', 'label': 'Audaz'},
    {'value': 'suave', 'label': 'Suave'},
    {'value': 'geometrico', 'label': 'Geométrico'},
    {'value': 'abstracto', 'label': 'Abstracto'},
    {'value': 'cinematico', 'label': 'Cinematográfico'},
    {'value': 'retro', 'label': 'Retro'},
    {'value': 'futurista', 'label': 'Futurista'},
    {'value': 'naturaleza', 'label': 'Naturaleza'},
  ];
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Set initial type if provided
    if (widget.initialType == 'story') {
      _selectedType = PreviewType.story;
    } else if (widget.initialType == 'post') {
      _selectedType = PreviewType.post;
    } else if (widget.initialType == 'reel') {
      _selectedType = PreviewType.reel;
    }
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeController.forward();
    _slideController.forward();
    
    // Load recent previews
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(previewsListProvider.notifier).loadPreviews();
    });
  }

  @override
  void dispose() {
    _topicController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final creationState = ref.watch(previewCreationProvider);
    
    // Listen to state changes
    ref.listen<PreviewCreationState>(previewCreationProvider, (previous, next) {
      if (next is PreviewCreationStreaming) {
        // Si es un reel generándose en background (con o sin previewId)
        // Verificar si es un nuevo reel (cambió de estado)
        if (previous is! PreviewCreationStreaming || 
            previous.previewId != next.previewId) {
          // Iniciar monitoreo global del reel con el tema real
          if (next.previewId == null && _currentReelTopic != null) {
            ref.read(reelGenerationMonitorProvider.notifier).startMonitoring(_currentReelTopic!);
          }
          
          // Redirigir al dashboard (página principal)
          Navigator.of(context).popUntil((route) => route.isFirst);
          
          // Mostrar toast inicial
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(next.statusMessage ?? 'Tu reel se está generando en background...'),
                  ),
                ],
              ),
              backgroundColor: AppConstants.primaryColor,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (previous.statusMessage != next.statusMessage) {
          // Actualizar toast con nuevo progreso
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
                      next.statusMessage ?? 'Generando reel...',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppConstants.primaryColor,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else if (next is PreviewCreationSuccess) {
        // Verificar si viene de un estado "generating" (reel en background)
        final wasGenerating = previous is PreviewCreationStreaming;
        
        // Reload recent previews
        ref.read(previewsListProvider.notifier).loadPreviews();
        
        // Si era un reel generándose en background, mostrar toast
        if (wasGenerating && next.response.preview.type == 'reel') {
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
                        preview: next.response.preview,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
        
        // Navigate to appropriate page based on preview type
        // Solo navegar automáticamente si NO era un reel en background (para dar tiempo al usuario de ver el toast)
        if (!wasGenerating) {
        if (next.response.preview.type == 'reel') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReelPreviewPage(
                preview: next.response.preview,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PreviewCorrectionsPage(
                preview: next.response.preview,
                suggestedCorrections: next.response.suggestedCorrections,
              ),
            ),
          );
          }
        }
      } else if (next is PreviewCreationError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Colors.red,
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20), // Icono iOS blanco
            onPressed: () => Navigator.pop(context),
            padding: const EdgeInsets.only(left: 8), // Padding ajustado
          ),
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white.withOpacity(0.2),
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
                'Crear Contenido',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PreviewsListPage(),
                  ),
                );
              },
              icon: Icon(
                CupertinoIcons.clock,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppConstants.brandGradient, // Gradiente de marca para light mode
            ),
          ),
        ),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildContent(creationState),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(PreviewCreationState state) {
    if (state is PreviewCreationLoading) {
      return PreviewSkeletonLoader(
        type: _selectedType.name,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 32),
            
            // Type Selection
            _buildTypeSelection(),
            const SizedBox(height: 24),
            
            // Topic Input
            _buildTopicInput(),
            const SizedBox(height: 24),
            
            // Style Selection (solo para posts y stories)
            if (_selectedType != PreviewType.reel) ...[
              _buildStyleSelection(),
              const SizedBox(height: 24),
            ],
            
            // Audience Selection
            _buildAudienceSelection(),
            const SizedBox(height: 24),
            
            // Campos específicos para reels
            if (_selectedType == PreviewType.reel) ...[
              _buildReelStyleSelection(),
              const SizedBox(height: 24),
              _buildAccentSelection(),
              const SizedBox(height: 24),
              _buildDurationSelection(),
              const SizedBox(height: 24),
            ],
            
            // Reference Image (solo para posts y stories)
            if (_selectedType != PreviewType.reel) ...[
              _buildReferenceImage(),
              const SizedBox(height: 24),
            ],
            const SizedBox(height: 32),
            
            // Create Buttons
            _buildCreateButtons(),
            const SizedBox(height: 24),
            
            // Recent Previews
            _buildRecentPreviews(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Crea contenido increíble',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Déjate inspirar por la IA para crear posts e historias que conecten con tu audiencia',
          style: GoogleFonts.poppins(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de contenido',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: PreviewType.values.map((type) {
            final isSelected = _selectedType == type;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedType = type),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF5B1DF4) : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF5B1DF4) : Colors.grey.shade200,
                      width: 1,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: const Color(0xFF5B1DF4).withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                  child: Column(
                    children: [
                      _getTypeIcon(type, isSelected),
                      const SizedBox(height: 8),
                      Text(
                        type.label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTopicInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¿Sobre qué quieres crear?',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _topicController,
          maxLines: 3,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Ej: "Tendencias de marketing digital para 2024"',
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey.shade500,
              fontSize: 16,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFF5B1DF4), width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'El tema es requerido';
            }
            if (value.trim().length < 10) {
              return 'El tema debe tener al menos 10 caracteres';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStyleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estilo visual',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<PreviewStyle>(
          value: _selectedStyle,
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedStyle = value);
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppConstants.primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
          ),
          dropdownColor: Colors.white,
          icon: Icon(
            CupertinoIcons.chevron_down,
            color: Colors.grey.shade600,
            size: 20,
          ),
          items: PreviewStyle.values.map((style) {
            return DropdownMenuItem<PreviewStyle>(
              value: style,
              child: Text(
                style.label,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAudienceSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Audiencia objetivo',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<TargetAudience>(
          value: _selectedAudience,
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedAudience = value);
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppConstants.primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
          ),
          dropdownColor: Colors.white,
          icon: Icon(
            CupertinoIcons.chevron_down,
            color: Colors.grey.shade600,
            size: 20,
          ),
          items: TargetAudience.values.map((audience) {
            return DropdownMenuItem<TargetAudience>(
              value: audience,
              child: Text(
                audience.label,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReelStyleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estilo Visual',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _selectedReelStyle,
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedReelStyle = value);
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppConstants.primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
          ),
          dropdownColor: Colors.white,
          icon: Icon(
            CupertinoIcons.chevron_down,
            color: Colors.grey.shade600,
            size: 20,
          ),
          items: _reelStyleOptions.map((option) {
            return DropdownMenuItem<String>(
              value: option['value'],
              child: Text(
                option['label']!,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAccentSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acento del Audio',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _selectedAccent,
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedAccent = value);
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppConstants.primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
          ),
          dropdownColor: Colors.white,
          icon: Icon(
            CupertinoIcons.chevron_down,
            color: Colors.grey.shade600,
            size: 20,
          ),
          items: _accentOptions.map((option) {
            return DropdownMenuItem<String>(
              value: option['value'],
              child: Text(
                option['label']!,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDurationSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duración',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          value: _selectedDuration,
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedDuration = value);
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppConstants.primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
          ),
          dropdownColor: Colors.white,
          icon: Icon(
            CupertinoIcons.chevron_down,
            color: Colors.grey.shade600,
            size: 20,
          ),
          items: _durationOptions.map((option) {
            return DropdownMenuItem<int>(
              value: option['value'] as int,
              child: Text(
                option['label'],
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReferenceImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Imagen de referencia (opcional)',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: _selectedImagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      _selectedImagePath!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.photo_fill_on_rectangle_fill,
                        color: Colors.grey.shade400,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Toca para agregar imagen',
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateButtons() {
    final creationState = ref.watch(previewCreationProvider);
    final isLoading = creationState is PreviewCreationLoading;
    
    return Row(
      children: [
        Expanded(
          child: CupertinoButton(
            onPressed: isLoading ? null : _createContent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: const Color(0xFF5B1DF4), // Púrpura Magneto
            borderRadius: BorderRadius.circular(16),
            child: isLoading && _selectedType == PreviewType.reel
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CupertinoActivityIndicator(
                        color: Colors.white,
                        radius: 10,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Generando Reel...',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Text(
                  _selectedType == PreviewType.reel 
                    ? 'Generar Reel (Background)'
                    : 'Crear ${_selectedType.label}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentPreviews() {
    final previewsState = ref.watch(previewsListProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recientes',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PreviewsListPage(),
                  ),
                );
              },
              child: Text(
                'Ver todos',
                style: TextStyle(
                  color: const Color(0xFF5B1DF4),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 180,
          child: _buildPreviewsList(previewsState),
        ),
      ],
    );
  }

  Widget _buildPreviewsList(PreviewsListState state) {
    if (state is PreviewsListLoading) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5B1DF4)),
              ),
            ),
          );
        },
      );
    }

    if (state is PreviewsListError) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red.shade400,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                'Error al cargar previews',
                style: TextStyle(
                  color: Colors.red.shade400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state is PreviewsListLoaded) {
      final previews = state.response.previews;
      
      if (previews.isEmpty) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  color: Colors.grey.shade400,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  'No hay previews recientes',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            // Cargar más previews cuando llegue al final
            _loadMorePreviews();
          }
          return false;
        },
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: previews.length + (state.response.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= previews.length) {
              // Mostrar indicador de loading al final
              return Container(
                width: 60,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5B1DF4)),
                  ),
                ),
              );
            }
            
            final preview = previews[index];
            return _buildPreviewCard(preview);
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _loadMorePreviews() {
    final currentState = ref.read(previewsListProvider);
    if (currentState is PreviewsListLoaded) {
      final currentOffset = currentState.response.offset;
      final limit = currentState.response.limit;
      
      ref.read(previewsListProvider.notifier).loadPreviews(
        limit: limit,
        offset: currentOffset + limit,
        append: true,
      );
    }
  }

  Widget _buildPreviewCard(PreviewEntity preview) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewCorrectionsPage(
              preview: preview,
              suggestedCorrections: [
                'Mejorar el contraste de colores para mayor legibilidad',
                'Agregar más información sobre beneficios salariales',
                'Incluir testimonios de profesionales exitosos',
                'Optimizar el texto para redes sociales',
                'Añadir call-to-action más persuasivo',
              ],
            ),
          ),
        );
      },
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Image
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  color: Colors.grey[800],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: preview.type == 'reel' && preview.videoUrl != null && preview.videoUrl!.isNotEmpty
                      ? MediaPreviewWidget(
                          mediaUrl: preview.videoUrl!,
                          aspectRatio: 1.0,
                        )
                      : MediaPreviewWidget(
                          mediaUrl: preview.previewImage,
                          aspectRatio: 1.0,
                        ),
                ),
              ),
            ),
            
            // Caption truncado
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        preview.caption.isNotEmpty 
                            ? preview.caption 
                            : preview.topic,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          height: 1.1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: preview.type == 'post' 
                                ? const Color(0xFF3B82F6).withOpacity(0.2)
                                : const Color(0xFF10B981).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            preview.type.toUpperCase(),
                            style: TextStyle(
                              color: preview.type == 'post' 
                                  ? const Color(0xFF3B82F6)
                                  : const Color(0xFF10B981),
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[400],
                          size: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al seleccionar imagen: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Mapear estilo del frontend al backend para reels
  String _mapReelStyleToBackend(String frontendStyle) {
    switch (frontendStyle) {
      case "moderno_profesional": return "realista";
      case "corporativo": return "corporativo";
      case "minimalista": return "minimalista";
      case "realista": return "realista";
      case "caricaturesco": return "cartoonish";
      case "dinamico": return "dinámico";
      case "ilustrativo": return "cartoonish";
      case "elegante": return "realista";
      case "tech": return "dinámico";
      case "vibrante": return "dinámico";
      case "profesional": return "realista";
      case "creativo": return "cartoonish";
      case "audaz": return "dinámico";
      case "suave": return "realista";
      case "geometrico": return "dinámico";
      case "abstracto": return "cartoonish";
      case "cinematico": return "realista";
      case "retro": return "cartoonish";
      case "futurista": return "dinámico";
      case "naturaleza": return "realista";
      default: return "realista";
    }
  }

  void _createContent() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedType == PreviewType.reel) {
      // Guardar el tema para el monitoreo
      _currentReelTopic = _topicController.text.trim();
      
      // Crear reel normalmente
      final reelRequest = CreateReelRequest(
        prompt: _currentReelTopic!,
        accent: _selectedAccent,
        style: _mapReelStyleToBackend(_selectedReelStyle),
        duration: _selectedDuration,
        targetAudience: _selectedAudience.value,
      );
      ref.read(previewCreationProvider.notifier).createReelPreview(reelRequest);
    } else {
      // Crear post o story
      final request = CreatePreviewRequest(
        topic: _topicController.text.trim(),
        style: _selectedStyle.value,
        targetAudience: _selectedAudience.value,
        referenceImage: _selectedImagePath,
      );

      if (_selectedType == PreviewType.post) {
        ref.read(previewCreationProvider.notifier).createPostPreview(request);
      } else if (_selectedType == PreviewType.story) {
        ref.read(previewCreationProvider.notifier).createStoryPreview(request);
      }
    }
  }

  Widget _getTypeIcon(PreviewType type, bool isSelected) {
    String iconPath;
    switch (type) {
      case PreviewType.post:
        iconPath = 'assets/icons/media.svg';
        break;
      case PreviewType.story:
        iconPath = 'assets/icons/storie.svg';
        break;
      case PreviewType.reel:
        iconPath = 'assets/icons/reel.svg';
        break;
    }
    
    return SvgPicture.asset(
      iconPath,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(
        isSelected ? Colors.white : Colors.grey.shade600,
        BlendMode.srcIn,
      ),
    );
  }
}

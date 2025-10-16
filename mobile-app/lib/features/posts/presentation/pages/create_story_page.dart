import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/permission_service.dart';
import '../providers/post_provider.dart';
import '../../data/models/post_model.dart';

class CreateStoryPage extends ConsumerStatefulWidget {
  const CreateStoryPage({super.key});

  @override
  ConsumerState<CreateStoryPage> createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends ConsumerState<CreateStoryPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  String? _selectedStyle;
  String? _selectedTargetAudience;
  String? _selectedImagePath;
  final ImagePicker _picker = ImagePicker();
  
  late AnimationController _loadingController;
  late AnimationController _successController;
  late Animation<double> _loadingAnimation;
  late Animation<double> _successAnimation;
  
  bool _isLoading = false;
  bool _showSuccess = false;
  String? _createdStoryUrl;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _successController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));
    
    _successAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _topicController.dispose();
    _loadingController.dispose();
    _successController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final hasPermissions = await PermissionService.hasAllImagePermissions();
      if (!hasPermissions) {
        final granted = await PermissionService.requestAllImagePermissions();
        if (!granted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Se necesitan permisos para acceder a las imágenes'),
                backgroundColor: const Color(0xFFEF4444),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
          return;
        }
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar imagen: $e'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  void _createStory() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _showSuccess = false;
      });
      
      _loadingController.forward();
      
      final story = StoryModel(
        topic: _topicController.text.trim(),
        style: _selectedStyle,
        targetAudience: _selectedTargetAudience,
        referenceImagePath: _selectedImagePath,
      );

      ref.read(postNotifierProvider.notifier).createStory(story);
    }
  }

  void _resetForm() {
    setState(() {
      _isLoading = false;
      _showSuccess = false;
      _createdStoryUrl = null;
    });
    _loadingController.reset();
    _successController.reset();
    _topicController.clear();
    setState(() {
      _selectedStyle = null;
      _selectedTargetAudience = null;
      _selectedImagePath = null;
    });
  }


  @override
  Widget build(BuildContext context) {
    ref.listen<PostState>(postNotifierProvider, (previous, next) {
      next.whenOrNull(
        storySuccess: (message, storyUrl) {
          setState(() {
            _isLoading = false;
          });
          _loadingController.reverse();
          
          // Navegar de vuelta a la app principal en el tab de Stories después de un breve delay
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              // Regresar a la página principal y cambiar al tab de Stories (índice 2)
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/main-app',
                (route) => false,
                arguments: {'initialIndex': 2}, // Tab de Stories
              );
            }
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        error: (error) {
          setState(() {
            _isLoading = false;
          });
          _loadingController.reverse();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: const Color(0xFFEF4444),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0F0F),
              Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: SafeArea(
          child: _showSuccess ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.auto_stories,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Crear Historia con IA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Genera historias promocionales automáticamente',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Form Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F1F),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF2D2D2D),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contenido de la Historia',
                    style: TextStyle(
                      color: Color(0xFFE5E7EB),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Topic Field
                  _buildDarkTextField(
                    controller: _topicController,
                    labelText: 'Tema de la Historia',
                    hintText: 'Nueva vacante: Desarrollador Frontend',
                    prefixIcon: Icons.topic_outlined,
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El tema es requerido';
                      }
                      if (value.trim().length < 5) {
                        return 'El tema debe tener al menos 5 caracteres';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Style Dropdown
                  _buildDropdownField(
                    labelText: 'Estilo del Contenido',
                    value: _selectedStyle,
                    items: const [
                      DropdownMenuItem(value: 'dynamic', child: Text('Dinámico')),
                      DropdownMenuItem(value: 'minimalist', child: Text('Minimalista')),
                      DropdownMenuItem(value: 'bold', child: Text('Audaz')),
                      DropdownMenuItem(value: 'elegant', child: Text('Elegante')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedStyle = value;
                      });
                    },
                    hintText: 'Selecciona un estilo (opcional)',
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Target Audience Dropdown
                  _buildDropdownField(
                    labelText: 'Audiencia Objetivo',
                    value: _selectedTargetAudience,
                    items: const [
                      DropdownMenuItem(value: 'job_seekers', child: Text('Buscadores de empleo')),
                      DropdownMenuItem(value: 'employers', child: Text('Empleadores')),
                      DropdownMenuItem(value: 'students', child: Text('Estudiantes')),
                      DropdownMenuItem(value: 'professionals', child: Text('Profesionales')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedTargetAudience = value;
                      });
                    },
                    hintText: 'Selecciona una audiencia (opcional)',
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Image Selection
                  const Text(
                    'Imagen de Referencia (Opcional)',
                    style: TextStyle(
                      color: Color(0xFFE5E7EB),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D2D2D),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _selectedImagePath != null 
                              ? const Color(0xFF8B5CF6) 
                              : const Color(0xFF4B5563),
                          width: 2,
                        ),
                      ),
                      child: _selectedImagePath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.asset(
                                _selectedImagePath!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildImagePlaceholder();
                                },
                              ),
                            )
                          : _buildImagePlaceholder(),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Create Button
            Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _isLoading ? null : _createStory,
                  child: Center(
                    child: _isLoading
                        ? AnimatedBuilder(
                            animation: _loadingAnimation,
                            builder: (context, child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                      value: _loadingAnimation.value,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Creando historia...',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8 + 0.2 * _loadingAnimation.value),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                        : const Text(
                            'Crear Historia',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFF8B5CF6),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'La IA generará automáticamente una historia promocional basada en tu tema',
                      style: TextStyle(
                        color: const Color(0xFF8B5CF6).withOpacity(0.9),
                        fontSize: 14,
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
  }

  Widget _buildSuccessView() {
    return AnimatedBuilder(
      animation: _successAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + 0.2 * _successAnimation.value,
          child: Opacity(
            opacity: _successAnimation.value,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Success Icon
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                        ),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_circle_outline,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    const Text(
                      '¡Historia Creada Exitosamente!',
                      style: TextStyle(
                        color: Color(0xFFE5E7EB),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Text(
                      'Tu historia ha sido generada y publicada en Instagram',
                      style: TextStyle(
                        color: const Color(0xFF9CA3AF),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Story URL
                    if (_createdStoryUrl != null) ...[
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F1F1F),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF2D2D2D),
                          ),
                        ),
                        child: _buildUrlButton(
                          'Ver Historia',
                          _createdStoryUrl!,
                          Icons.auto_stories_outlined,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                    
                    // Create Another Button
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: _resetForm,
                          child: const Center(
                            child: Text(
                              'Crear Otra Historia',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDarkTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            color: Color(0xFFE5E7EB),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          style: const TextStyle(
            color: Color(0xFFE5E7EB),
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 16,
            ),
            prefixIcon: Icon(
              prefixIcon,
              color: const Color(0xFF6B7280),
            ),
            filled: true,
            fillColor: const Color(0xFF2D2D2D),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF4B5563),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF4B5563),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF8B5CF6),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFEF4444),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFEF4444),
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add_photo_alternate_outlined,
            size: 48,
            color: Color(0xFF6B7280),
          ),
          const SizedBox(height: 12),
          const Text(
            'Toca para seleccionar imagen',
            style: TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Opcional - Mejora el resultado',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String labelText,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            color: Color(0xFFE5E7EB),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D2D),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF4B5563),
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            dropdownColor: const Color(0xFF2D2D2D),
            style: const TextStyle(
              color: Color(0xFFE5E7EB),
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: items,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUrlButton(String label, String url, IconData icon) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4B5563),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // TODO: Abrir URL
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Abriendo $label...'),
                backgroundColor: const Color(0xFF8B5CF6),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFF8B5CF6),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFFE5E7EB),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(
                  Icons.open_in_new,
                  color: Color(0xFF6B7280),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
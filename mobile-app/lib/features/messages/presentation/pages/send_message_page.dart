import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../providers/message_provider.dart';
import '../../data/models/message_model.dart';

class SendMessagePage extends ConsumerStatefulWidget {
  const SendMessagePage({super.key});

  @override
  ConsumerState<SendMessagePage> createState() => _SendMessagePageState();
}

class _SendMessagePageState extends ConsumerState<SendMessagePage> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _recipientIdController = TextEditingController();
  final _senderNameController = TextEditingController();
  
  @override
  void dispose() {
    _messageController.dispose();
    _recipientIdController.dispose();
    _senderNameController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_formKey.currentState!.validate()) {
      final message = MessageModel(
        message: _messageController.text.trim(),
        recipientId: _recipientIdController.text.trim(),
        senderName: _senderNameController.text.trim().isEmpty 
            ? null 
            : _senderNameController.text.trim(),
      );

      ref.read(messageNotifierProvider.notifier).sendMessage(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageState = ref.watch(messageNotifierProvider);

    ref.listen<MessageState>(messageNotifierProvider, (previous, next) {
      next.whenOrNull(
        success: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppConstants.successColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
            ),
          );
          _clearForm();
        },
        error: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: AppConstants.errorColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
              ),
            ),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enviar Mensaje'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppConstants.brandGradient,
          ),
        ),
        foregroundColor: Colors.white,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingL),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Card
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingL),
                    decoration: BoxDecoration(
                      gradient: AppConstants.brandGradient,
                      borderRadius: BorderRadius.circular(AppConstants.radiusL),
                      boxShadow: AppConstants.elevatedShadow,
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.message_outlined,
                          size: 48,
                          color: Colors.white,
                        ),
                        const SizedBox(height: AppConstants.spacingM),
                        Text(
                          'Enviar Mensaje Directo',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingS),
                        Text(
                          'Comunícate directamente con tus candidatos',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.spacingXL),
                  
                  // Form Fields
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.spacingL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detalles del Mensaje',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingL),
                          
                          // Recipient ID Field
                          CustomTextField(
                            controller: _recipientIdController,
                            labelText: 'ID del Destinatario',
                            hintText: 'Ej: 804406915847834',
                            prefixIcon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El ID del destinatario es requerido';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: AppConstants.spacingL),
                          
                          // Sender Name Field (Optional)
                          CustomTextField(
                            controller: _senderNameController,
                            labelText: 'Nombre del Remitente (Opcional)',
                            hintText: 'Ej: Equipo Magneto',
                            prefixIcon: Icons.business_outlined,
                          ),
                          
                          const SizedBox(height: AppConstants.spacingL),
                          
                          // Message Field
                          CustomTextField(
                            controller: _messageController,
                            labelText: 'Mensaje',
                            hintText: 'Escribe tu mensaje aquí...',
                            prefixIcon: Icons.message_outlined,
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El mensaje es requerido';
                              }
                              if (value.trim().length < 10) {
                                return 'El mensaje debe tener al menos 10 caracteres';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.spacingXL),
                  
                  // Send Button
                  GradientButton(
                    onPressed: messageState.maybeWhen(
                      loading: () => null,
                      orElse: () => _sendMessage,
                    ),
                    child: messageState.maybeWhen(
                      loading: () => const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      orElse: () => const Text(
                        'Enviar Mensaje',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.spacingL),
                  
                  // Info Card
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    decoration: BoxDecoration(
                      color: AppConstants.infoColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppConstants.radiusM),
                      border: Border.all(
                        color: AppConstants.infoColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppConstants.infoColor,
                          size: 20,
                        ),
                        const SizedBox(width: AppConstants.spacingM),
                        Expanded(
                          child: Text(
                            'Los mensajes se enviarán directamente a través de Instagram',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppConstants.infoColor,
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
        ),
      ),
    );
  }

  void _clearForm() {
    _messageController.clear();
    _recipientIdController.clear();
    _senderNameController.clear();
  }
}

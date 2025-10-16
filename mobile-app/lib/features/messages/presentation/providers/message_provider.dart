import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/message_model.dart';
import '../../data/repositories/message_repository_impl.dart';
import '../../domain/usecases/send_message_usecase.dart';

part 'message_provider.freezed.dart';

final messageRepositoryProvider = Provider((ref) => MessageRepositoryImpl());

final sendMessageUseCaseProvider = Provider((ref) {
  final repository = ref.watch(messageRepositoryProvider);
  return SendMessageUseCase(repository: repository);
});

class MessageNotifier extends StateNotifier<MessageState> {
  final SendMessageUseCase _sendMessageUseCase;

  MessageNotifier({required SendMessageUseCase sendMessageUseCase})
      : _sendMessageUseCase = sendMessageUseCase,
        super(const MessageState.initial());

  Future<void> sendMessage(MessageModel message) async {
    state = const MessageState.loading();
    
    try {
      final response = await _sendMessageUseCase(message);
      
      if (response.success) {
        state = MessageState.success(response.message ?? 'Mensaje enviado exitosamente');
      } else {
        state = MessageState.error(response.error ?? 'Error al enviar mensaje');
      }
    } catch (e) {
      state = MessageState.error('Error inesperado: $e');
    }
  }

  void reset() {
    state = const MessageState.initial();
  }
}

@freezed
class MessageState with _$MessageState {
  const factory MessageState.initial() = _Initial;
  const factory MessageState.loading() = _Loading;
  const factory MessageState.success(String message) = _Success;
  const factory MessageState.error(String error) = _Error;
}

final messageNotifierProvider = StateNotifierProvider<MessageNotifier, MessageState>((ref) {
  final useCase = ref.watch(sendMessageUseCaseProvider);
  return MessageNotifier(sendMessageUseCase: useCase);
});

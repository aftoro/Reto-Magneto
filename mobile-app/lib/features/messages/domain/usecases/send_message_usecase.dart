import '../../data/models/message_model.dart';
import '../repositories/message_repository.dart';

class SendMessageUseCase {
  final MessageRepository _repository;

  SendMessageUseCase({required MessageRepository repository})
      : _repository = repository;

  Future<SendMessageResponse> call(MessageModel message) async {
    return await _repository.sendMessage(message);
  }
}

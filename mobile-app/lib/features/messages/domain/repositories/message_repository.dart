import '../../data/models/message_model.dart';

abstract class MessageRepository {
  Future<SendMessageResponse> sendMessage(MessageModel message);
}

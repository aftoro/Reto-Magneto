import '../models/message_model.dart';
import '../datasources/message_datasource.dart';
import '../../domain/repositories/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageService _dataSource;

  MessageRepositoryImpl({MessageService? dataSource})
      : _dataSource = dataSource ?? MessageService();

  @override
  Future<SendMessageResponse> sendMessage(MessageModel message) async {
    return await _dataSource.sendMessage(message);
  }
}

import '../models/conversation_entity.dart';
import '../datasources/conversation_datasource.dart';
import '../../domain/repositories/conversation_repository.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationService _dataSource;

  ConversationRepositoryImpl({ConversationService? dataSource})
      : _dataSource = dataSource ?? ConversationService();

  @override
  Future<List<ConversationWithMessages>> getConversations() async {
    return await _dataSource.getConversations();
  }

  @override
  Future<ConversationWithMessages?> getConversationById(String id) async {
    return await _dataSource.getConversationById(id);
  }

  @override
  Future<List<ConversationWithMessages>> getConversationsByUserId(String userId) async {
    return await _dataSource.getConversationsByUserId(userId);
  }

  @override
  Future<Map<String, int>> getConversationStats() async {
    return await _dataSource.getConversationStats();
  }
}

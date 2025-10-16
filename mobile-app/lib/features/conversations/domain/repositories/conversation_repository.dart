import '../../data/models/conversation_entity.dart';

abstract class ConversationRepository {
  Future<List<ConversationWithMessages>> getConversations();
  Future<ConversationWithMessages?> getConversationById(String id);
  Future<List<ConversationWithMessages>> getConversationsByUserId(String userId);
  Future<Map<String, int>> getConversationStats();
}

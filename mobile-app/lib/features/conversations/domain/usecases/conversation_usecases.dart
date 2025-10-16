import '../../data/models/conversation_entity.dart';
import '../repositories/conversation_repository.dart';

class GetConversationsUseCase {
  final ConversationRepository _repository;

  GetConversationsUseCase({required ConversationRepository repository})
      : _repository = repository;

  Future<List<ConversationWithMessages>> call() async {
    return await _repository.getConversations();
  }
}

class GetConversationByIdUseCase {
  final ConversationRepository _repository;

  GetConversationByIdUseCase({required ConversationRepository repository})
      : _repository = repository;

  Future<ConversationWithMessages?> call(String id) async {
    return await _repository.getConversationById(id);
  }
}

class GetConversationsByUserIdUseCase {
  final ConversationRepository _repository;

  GetConversationsByUserIdUseCase({required ConversationRepository repository})
      : _repository = repository;

  Future<List<ConversationWithMessages>> call(String userId) async {
    return await _repository.getConversationsByUserId(userId);
  }
}

class GetConversationStatsUseCase {
  final ConversationRepository _repository;

  GetConversationStatsUseCase({required ConversationRepository repository})
      : _repository = repository;

  Future<Map<String, int>> call() async {
    return await _repository.getConversationStats();
  }
}

import '../../data/models/post_model.dart';
import '../repositories/post_repository.dart';

class CreatePostUseCase {
  final PostRepository _repository;

  CreatePostUseCase({required PostRepository repository})
      : _repository = repository;

  Future<CreatePostResponse> call(PostModel post) async {
    return await _repository.createPost(post);
  }
}

class CreateStoryUseCase {
  final PostRepository _repository;

  CreateStoryUseCase({required PostRepository repository})
      : _repository = repository;

  Future<CreateStoryResponse> call(StoryModel story) async {
    return await _repository.createStory(story);
  }
}

import '../../data/models/post_model.dart';

abstract class PostRepository {
  Future<CreatePostResponse> createPost(PostModel post);
  Future<CreateStoryResponse> createStory(StoryModel story);
}

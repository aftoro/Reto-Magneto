import '../models/post_model.dart';
import '../datasources/post_datasource.dart';
import '../../domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostService _dataSource;

  PostRepositoryImpl({PostService? dataSource})
      : _dataSource = dataSource ?? PostService();

  @override
  Future<CreatePostResponse> createPost(PostModel post) async {
    return await _dataSource.createPost(post);
  }

  @override
  Future<CreateStoryResponse> createStory(StoryModel story) async {
    return await _dataSource.createStory(story);
  }
}

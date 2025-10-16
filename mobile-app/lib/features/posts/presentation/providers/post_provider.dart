import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/post_model.dart';
import '../../data/repositories/post_repository_impl.dart';
import '../../domain/repositories/post_repository.dart' as domain;
import '../../domain/usecases/post_usecases.dart';

part 'post_provider.freezed.dart';

final postRepositoryProvider = Provider<domain.PostRepository>((ref) => PostRepositoryImpl());

final createPostUseCaseProvider = Provider((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return CreatePostUseCase(repository: repository);
});

final createStoryUseCaseProvider = Provider((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return CreateStoryUseCase(repository: repository);
});

class PostNotifier extends StateNotifier<PostState> {
  final CreatePostUseCase _createPostUseCase;
  final CreateStoryUseCase _createStoryUseCase;

  PostNotifier({
    required CreatePostUseCase createPostUseCase,
    required CreateStoryUseCase createStoryUseCase,
  })  : _createPostUseCase = createPostUseCase,
        _createStoryUseCase = createStoryUseCase,
        super(const PostState.initial());

  Future<void> createPost(PostModel post) async {
    state = const PostState.loading();
    
    try {
      final response = await _createPostUseCase(post);
      
      if (response.success) {
        state = PostState.postSuccess(
          message: response.message ?? 'Post creado exitosamente',
          postUrl: response.post_url,
          storyUrl: response.story_url,
        );
      } else {
        state = PostState.error(response.error ?? 'Error al crear post');
      }
    } catch (e) {
      state = PostState.error('Error inesperado: $e');
    }
  }

  Future<void> createStory(StoryModel story) async {
    state = const PostState.loading();
    
    try {
      final response = await _createStoryUseCase(story);
      
      if (response.success) {
        state = PostState.storySuccess(
          message: response.message ?? 'Historia creada exitosamente',
          storyUrl: response.story_url,
        );
      } else {
        state = PostState.error(response.error ?? 'Error al crear historia');
      }
    } catch (e) {
      state = PostState.error('Error inesperado: $e');
    }
  }

  void reset() {
    state = const PostState.initial();
  }
}

@freezed
class PostState with _$PostState {
  const factory PostState.initial() = _Initial;
  const factory PostState.loading() = _Loading;
  const factory PostState.postSuccess({
    required String message,
    String? postUrl,
    String? storyUrl,
  }) = _PostSuccess;
  const factory PostState.storySuccess({
    required String message,
    String? storyUrl,
  }) = _StorySuccess;
  const factory PostState.error(String error) = _Error;
}

final postNotifierProvider = StateNotifierProvider<PostNotifier, PostState>((ref) {
  final createPostUseCase = ref.watch(createPostUseCaseProvider);
  final createStoryUseCase = ref.watch(createStoryUseCaseProvider);
  return PostNotifier(
    createPostUseCase: createPostUseCase,
    createStoryUseCase: createStoryUseCase,
  );
});

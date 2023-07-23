import '../../../../data/model/post/create/create_post_model.dart';
import '../../../../data/model/post/item/post_item_state.dart';
import '../../../repository/post/post_repository.dart';

class CreatePostUseCase {
  final PostRepository _postRepository;

  CreatePostUseCase({required PostRepository postRepository})
      : _postRepository = postRepository;

  Future<PostItemState> execute({required CreatePostModel createPostModel}) async {
    return await _postRepository.createPost(createPostModel: createPostModel);
  }
}
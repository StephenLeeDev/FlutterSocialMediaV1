import '../../../../data/model/common/single_integer_state.dart';
import '../../../repository/post/post_repository.dart';

class PostLikeUseCase {
  final PostRepository _postRepository;

  PostLikeUseCase({required PostRepository postRepository})
      : _postRepository = postRepository;

  Future<SingleIntegerState> execute({required int postId}) async {
    return await _postRepository.postLike(postId: postId);
  }

}
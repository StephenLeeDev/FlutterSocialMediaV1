import '../../../../data/model/common/common_state.dart';
import '../../../repository/post/post_repository.dart';

class DeletePostUseCase {
  final PostRepository _postRepository;

  DeletePostUseCase({required PostRepository postRepository})
      : _postRepository = postRepository;

  Future<CommonState> execute({required int postId}) async {
    return await _postRepository.deletePost(postId: postId);
  }
}
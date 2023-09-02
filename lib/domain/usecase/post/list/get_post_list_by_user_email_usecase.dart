import '../../../../data/model/post/list/post_list_state.dart';
import '../../../repository/post/post_repository.dart';

class GetPostListByUserEmailUseCase {
  final PostRepository _postRepository;

  GetPostListByUserEmailUseCase({required PostRepository postRepository})
      : _postRepository = postRepository;

  Future<PostListState> execute({required int page, required int limit, required String email}) async {
    return await _postRepository.getPostListByUserEmail(page: page, limit: limit, email: email);
  }

}
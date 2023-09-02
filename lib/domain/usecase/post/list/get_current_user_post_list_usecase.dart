import '../../../../data/model/post/list/post_list_state.dart';
import '../../../repository/post/post_repository.dart';

class GetCurrentUserPostListUseCase {
  final PostRepository _postRepository;

  GetCurrentUserPostListUseCase({required PostRepository postRepository})
      : _postRepository = postRepository;

  Future<PostListState> execute({required int page, required int limit}) async {
    return await _postRepository.getCurrentUserPostList(page: page, limit: limit);
  }

}
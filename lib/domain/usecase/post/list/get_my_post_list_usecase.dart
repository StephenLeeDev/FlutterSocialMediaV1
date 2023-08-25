import '../../../../data/model/post/list/post_list_state.dart';
import '../../../repository/post/post_repository.dart';

class GetMyPostListUseCase {
  final PostRepository _postRepository;

  GetMyPostListUseCase({required PostRepository postRepository})
      : _postRepository = postRepository;

  Future<PostListState> execute({required int page, required int limit}) async {
    return await _postRepository.getMyPostList(page: page, limit: limit);
  }

}
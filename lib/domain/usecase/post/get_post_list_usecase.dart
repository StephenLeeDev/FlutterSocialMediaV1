import 'package:flutter_social_media_v1/data/model/post/post_list_state.dart';

import '../../repository/post/post_repository.dart';

class GetPostListUseCase {
  final PostRepository _postRepository;

  GetPostListUseCase({required PostRepository postRepository})
      : _postRepository = postRepository;

  Future<PostListState> execute({required int page, required int limit}) async {
    return await _postRepository.getPostList(page: page, limit: limit);
  }

}
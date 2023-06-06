import 'package:flutter/foundation.dart';
import 'package:flutter_social_media_v1/domain/usecase/post/get_post_list_usecase.dart';

import '../../../data/model/post/post_list_state.dart';

class PostListViewModel extends ChangeNotifier {
  final GetPostListUseCase _getPostListUseCase;

  PostListViewModel({
    required GetPostListUseCase getPostListUseCase,
  }) : _getPostListUseCase = getPostListUseCase;

  PostListState _postListState = Ready();
  PostListState get postListState => _postListState;

  setPostListState({required PostListState postListState}) {
    _postListState = postListState;
  }

  Future<void> getPostList({required int page, required int limit}) async {
    final state = await _getPostListUseCase.execute(page: page, limit: limit);
    if (state is Success) {
      debugPrint("state.total : ${state.total}");
      debugPrint("state.list : ${state.list}");
    }
    setPostListState(postListState: state);
  }

}
import 'package:flutter/foundation.dart';

import '../../../data/model/common/common_state.dart';
import '../../../domain/usecase/user/post_bookmark_usecase.dart';

class BookmarkViewModel extends ChangeNotifier {
  final PostBookmarkUseCase _postBookmarkUseCase;

  BookmarkViewModel({
    required PostBookmarkUseCase postBookmarkUseCase,
  }) : _postBookmarkUseCase = postBookmarkUseCase;

  CommonState _state = Ready();
  CommonState get state => _state;
  bool get isLoading => state is Loading;

  setState({required CommonState state}) {
    _state = state;
  }

  /// Request update the bookmark/unbookmark to the app server
  Future<CommonState> postBookmark({required int postId}) async {
    setState(state: Loading());
    final result = await _postBookmarkUseCase.execute(postId: postId);
    setState(state: result);
    return state;
  }
}
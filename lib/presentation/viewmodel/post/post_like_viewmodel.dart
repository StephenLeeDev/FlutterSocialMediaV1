import 'package:flutter/foundation.dart';

import '../../../data/model/common/single_integer_state.dart';
import '../../../domain/usecase/post/post_like_usecase.dart';

class PostLikeViewModel extends ChangeNotifier {
  final PostLikeUseCase _postLikeUseCase;

  PostLikeViewModel({
    required PostLikeUseCase postLikeUseCase,
  }) : _postLikeUseCase = postLikeUseCase;

  SingleIntegerState _state = Ready();
  SingleIntegerState get state => _state;
  bool get isLoading => state is Loading;

  setState({required SingleIntegerState state}) {
    _state = state;
  }

  /// Request update the like/unlike to the app server
  Future<SingleIntegerState> postLike({required int postId}) async {
    setState(state: Loading());
    final result = await _postLikeUseCase.execute(postId: postId);
    setState(state: result);
    return state;
  }
}
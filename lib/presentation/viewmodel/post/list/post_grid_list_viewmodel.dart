import '../../../../domain/usecase/post/list/get_my_post_list_usecase.dart';
import '../../../../data/model/post/list/post_list_state.dart' as PostListState;
import 'post_list_viewmodel.dart';

class MyPostGridListViewModel extends PostListViewModel {
  final GetMyPostListUseCase _getMyPostListUseCase;

  MyPostGridListViewModel({
    required super.getPostListUseCase,
    required getMyPostListUseCase,
  }) : _getMyPostListUseCase = getMyPostListUseCase;

  /// Fetch additional paginated my posts
  @override
  Future<PostListState.PostListState> getPostList() async {
    setPostListState(postListState: PostListState.Loading());

    final state = await _getMyPostListUseCase.execute(page: page, limit: limit);
    setPostListState(postListState: state);

    if (state is PostListState.Success) {
      setLimit(value: 6);
      increasePage();

      addAdditionalList(additionalList: state.list);

      if (currentList.length >= state.total) setHasNext(value: false);
    }
    return state;
  }
}
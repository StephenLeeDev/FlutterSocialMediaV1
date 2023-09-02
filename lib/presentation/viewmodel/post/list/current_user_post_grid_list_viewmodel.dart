import '../../../../data/model/post/item/post_model.dart';
import '../../../../domain/usecase/post/list/get_current_user_post_list_usecase.dart';
import '../../../../data/model/post/list/post_list_state.dart' as PostListState;
import 'post_list_viewmodel.dart';

class CurrentUserPostGridListViewModel extends PostListViewModel {
  final GetCurrentUserPostListUseCase _getMyPostListUseCase;

  CurrentUserPostGridListViewModel({
    required super.getPostListUseCase,
    required getMyPostListUseCase,
  }) : _getMyPostListUseCase = getMyPostListUseCase;

  /// Fetch additional paginated my posts
  @override
  Future<void> getPostList() async {
    if (postListState is PostListState.Loading || !hasNext) return;
    setPostListState(postListState: PostListState.Loading());

    final state = await _getMyPostListUseCase.execute(page: page, limit: limit);
    setPostListState(postListState: state);

    if (state is PostListState.Success) {
      // FIXME : ErrorNumber 01
      // FIXME : This initializing from setLimit() not actually working with getPostList() from MyPageScreen, and I don't know why yet
      // setLimit(value: 6);
      increasePage();

      addAdditionalList(additionalList: state.list);

      if (currentList.length >= state.total) setHasNext(value: false);
    }
  }

  /// Check if the current user's post
  /// It's always 'true' because CurrentUserPostGridListViewModel is for the current user's feed
  /// So setIsMineStatusAndReturn() simply sets 'true' to all items
  @override
  List<PostModel> setIsMineStatusAndReturn({required List<PostModel> list}) {
    final copyList = List.of(list);
    for (int i = 0; i < copyList.length; i++) {
      copyList[i].isMine = true;
    }
    return copyList;
  }

}
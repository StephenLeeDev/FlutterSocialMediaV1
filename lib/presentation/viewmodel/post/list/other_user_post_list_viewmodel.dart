import '../../../../data/model/post/list/post_list_state.dart' as PostListState;
import '../../../../domain/usecase/post/list/get_post_list_by_user_email_usecase.dart';
import 'post_list_viewmodel.dart';

class OtherUserPostGridListViewModel extends PostListViewModel {
  final GetPostListByUserEmailUseCase _getPostListByUserEmailUseCase;

  OtherUserPostGridListViewModel({
    required super.getPostListUseCase,
    required getPostListByUserEmailUseCase,
  }) : _getPostListByUserEmailUseCase = getPostListByUserEmailUseCase;

  /// The user's email address
  String _email = "";
  String get email => _email;

  setEmail({required String email}) {
    _email = email;
  }

  /// Fetch additional paginated feed
  @override
  Future<void> getPostList() async {
    if (postListState is PostListState.Loading || !hasNext) return;
    setPostListState(postListState: PostListState.Loading());

    final state = await _getPostListByUserEmailUseCase.execute(page: page, limit: limit, email: email);
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
}
import '../../../../domain/usecase/post/list/get_post_list_usecase.dart';
import 'post_list_viewmodel.dart';

class PostGridListViewModel extends PostListViewModel {
  final GetPostListUseCase _getPostListUseCase;

  PostGridListViewModel({
    required super.getPostListUseCase,
  }) : _getPostListUseCase = getPostListUseCase;

  // TODO : Fetch feed for grid view

  // TODO : Branch limit first/others
}
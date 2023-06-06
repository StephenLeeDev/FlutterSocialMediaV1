import '../../../data/model/post/post_list_state.dart';

abstract class PostRepository {
  Future<PostListState> getPostList({required int page, required int limit});
}
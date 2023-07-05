import '../../../data/model/common/single_integer_state.dart';
import '../../../data/model/post/list/post_list_state.dart';

abstract class PostRepository {
  Future<PostListState> getPostList({required int page, required int limit});
  Future<SingleIntegerState> postLike({required int postId});
}
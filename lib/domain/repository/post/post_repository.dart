import '../../../data/model/common/common_state.dart';
import '../../../data/model/common/single_integer_state.dart';
import '../../../data/model/post/create/create_post_model.dart';
import '../../../data/model/post/item/post_item_state.dart';
import '../../../data/model/post/list/post_list_state.dart';
import '../../../data/model/post/update/update_post_description_model.dart';

abstract class PostRepository {
  Future<PostItemState> createPost({required CreatePostModel createPostModel});
  Future<PostListState> getPostList({required int page, required int limit});
  Future<PostListState> getCurrentUserPostList({required int page, required int limit});
  Future<PostListState> getPostListByUserEmail({required int page, required int limit, required String email});
  Future<PostItemState> updatePostDescription({required UpdatePostDescriptionModel updatePostDescriptionModel});
  Future<SingleIntegerState> postLike({required int postId});
  Future<CommonState> deletePost({required int postId});
}
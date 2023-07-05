import '../../../data/model/comment/list/comment_list_state.dart';
import '../../../data/model/comment/create/create_comment_model.dart';
import '../../../data/model/comment/create/create_comment_state.dart';

abstract class CommentRepository {
  Future<CommentListState> getCommentList({required int postId, required int page, required int limit});
  Future<CreateCommentState> createComment({required CreateCommentModel createCommentModel});
}
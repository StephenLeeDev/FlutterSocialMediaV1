import '../../../data/model/comment/comment_list_state.dart';

abstract class CommentRepository {
  Future<CommentListState> getCommentList({required int postId, required int page, required int limit});
}
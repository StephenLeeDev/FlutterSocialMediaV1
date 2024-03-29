import '../../../../data/model/comment/list/comment_list_state.dart';
import '../../../repository/comment/comment_repository.dart';

class GetCommentListUseCase {
  final CommentRepository _commentRepository;

  GetCommentListUseCase({required CommentRepository commentRepository})
      : _commentRepository = commentRepository;

  Future<CommentListState> execute({required int postId, int? parentCommentId, required int page, required int limit}) async {
    return await _commentRepository.getCommentList(postId: postId, parentCommentId: parentCommentId, page: page, limit: limit);
  }
}
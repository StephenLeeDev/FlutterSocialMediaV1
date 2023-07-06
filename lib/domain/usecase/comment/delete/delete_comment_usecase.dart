import '../../../../data/model/common/common_state.dart';
import '../../../repository/comment/comment_repository.dart';

class DeleteCommentUseCase {
  final CommentRepository _commentRepository;

  DeleteCommentUseCase({required CommentRepository commentRepository})
      : _commentRepository = commentRepository;

  Future<CommonState> execute({required int commentId}) async {
    return await _commentRepository.deleteComment(commentId: commentId);
  }
}
import '../../../../data/model/comment/item/comment_item_state.dart';
import '../../../../data/model/comment/update/update_comment_model.dart';
import '../../../repository/comment/comment_repository.dart';

class UpdateCommentItemUseCase {
  final CommentRepository _commentRepository;

  UpdateCommentItemUseCase({required CommentRepository commentRepository})
      : _commentRepository = commentRepository;

  Future<CommentItemState> execute({required UpdateCommentModel updateCommentModel}) async {
    return await _commentRepository.updateComment(updateCommentModel: updateCommentModel);
  }
}
import '../../../data/model/comment/create/create_comment_model.dart';
import '../../../data/model/comment/create/create_comment_state.dart';
import '../../repository/comment/comment_repository.dart';

class CreateCommentUseCase {
  final CommentRepository _commentRepository;

  CreateCommentUseCase({required CommentRepository commentRepository})
      : _commentRepository = commentRepository;

  Future<CreateCommentState> execute({required CreateCommentModel createCommentModel}) async {
    return await _commentRepository.createComment(createCommentModel: createCommentModel);
  }
}
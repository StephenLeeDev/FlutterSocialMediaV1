import '../../../../data/model/post/item/post_item_state.dart';
import '../../../../data/model/post/update/update_post_description_model.dart';
import '../../../repository/post/post_repository.dart';

class UpdatePostDescriptionUseCase {
  final PostRepository _postRepository;

  UpdatePostDescriptionUseCase({required PostRepository postRepository})
      : _postRepository = postRepository;

  Future<PostItemState> execute({required UpdatePostDescriptionModel updatePostDescriptionModel}) async {
    return await _postRepository.updatePostDescription(updatePostDescriptionModel: updatePostDescriptionModel);
  }
}
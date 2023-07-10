import '../item/comment_model.dart';

abstract class CommentItemState {}

class Ready extends CommentItemState {}

class Loading extends CommentItemState {}

class Fail extends CommentItemState {}

class Success extends CommentItemState {
  late CommentModel item;
  Success({required this.item});
}
import '../comment_model.dart';

abstract class CreateCommentState {}

class Ready extends CreateCommentState {}

class Loading extends CreateCommentState {}

class Fail extends CreateCommentState {}

class Success extends CreateCommentState {
  late CommentModel value;
  Success({required this.value});
}
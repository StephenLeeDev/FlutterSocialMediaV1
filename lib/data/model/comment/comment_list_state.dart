import 'comment_model.dart';

abstract class CommentListState {}

class Ready extends CommentListState {}

class Loading extends CommentListState {}

class Fail extends CommentListState {}

class Success extends CommentListState {
  final int total;
  late List<CommentModel> list;
  Success({required this.total, required this.list});

  int get getTotal => total;
  List<CommentModel> get getList => list;
}
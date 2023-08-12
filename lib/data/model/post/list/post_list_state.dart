import '../item/post_model.dart';

abstract class PostListState {}

class Ready extends PostListState {}

/// Fetch my user information first before the list
class MyUserInfoLoading extends PostListState {}

class Loading extends PostListState {}

class Fail extends PostListState {}

class Success extends PostListState {
  final int total;
  late List<PostModel> list;
  Success({required this.total, required this.list});

  int get getTotal => total;
  List<PostModel> get getList => list;
}

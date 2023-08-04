import '../item/post_model.dart';

abstract class PostItemState {}

class Ready extends PostItemState {}

class Loading extends PostItemState {}

class Fail extends PostItemState {}

class Success extends PostItemState {
  late PostModel item;
  Success({required this.item});

  PostModel get getItem => item;
}

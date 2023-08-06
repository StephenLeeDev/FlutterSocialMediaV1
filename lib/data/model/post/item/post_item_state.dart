import '../item/post_model.dart';

abstract class PostItemState {}

class Ready extends PostItemState {}

class Loading extends PostItemState {}

class Fail extends PostItemState {}

class Success extends PostItemState {
  late final PostModel _item;
  Success({required PostModel item}) : _item = item;

  PostModel get getItem => _item;
}

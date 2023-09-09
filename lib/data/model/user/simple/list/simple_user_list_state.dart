import '../item/simple_user_info_model.dart';

abstract class SimpleUserListState {}

class Ready extends SimpleUserListState {}

/// Fetch my user information first before the list
class MyUserInfoLoading extends SimpleUserListState {}

class Loading extends SimpleUserListState {}

class Fail extends SimpleUserListState {}

class Success extends SimpleUserListState {
  final int total;
  late List<SimpleUserInfoModel> list;
  Success({required this.total, required this.list});

  int get getTotal => total;
  List<SimpleUserInfoModel> get getList => list;
}

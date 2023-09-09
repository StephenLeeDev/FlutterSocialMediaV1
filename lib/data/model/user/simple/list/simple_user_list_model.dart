import '../item/simple_user_info_model.dart';

class SimpleUserListModel {
  List<SimpleUserInfoModel> userList;
  int total;

  SimpleUserListModel({
    required this.userList,
    required this.total,
  });

  factory SimpleUserListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> users = json['userList'];
    List<SimpleUserInfoModel> userList = users.map((item) => SimpleUserInfoModel.fromJson(item)).toList();

    return SimpleUserListModel(
      userList: userList,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> users = userList.map((item) => item.toJson()).toList();

    return {
      'userList': users,
      'total': total,
    };
  }

  @override
  String toString() {
    return 'SimpleUserListModel(userList: $userList, total: $total)';
  }
}
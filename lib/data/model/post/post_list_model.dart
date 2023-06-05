import 'package:flutter_social_media_v1/data/model/post/post_model.dart';

class PostListModel {
  List<PostModel> postList;
  int total;

  PostListModel({
    required this.postList,
    required this.total,
  });

  factory PostListModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> postList = json['posts'];
    List<PostModel> posts = postList.map((item) => PostModel.fromJson(item)).toList();

    return PostListModel(
      postList: posts,
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> posts = postList.map((item) => item.toJson()).toList();

    return {
      'posts': posts,
      'total': total,
    };
  }

  @override
  String toString() {
    return 'PostListModel(posts: $postList, total: $total)';
  }
}

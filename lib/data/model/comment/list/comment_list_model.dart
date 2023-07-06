import '../item/comment_model.dart';

class CommentListModel {
  final List<CommentModel>? commentList;
  List<CommentModel> get getCommentList => commentList ?? [];

  final int? total;
  int get getTotal => total ?? 0;

  CommentListModel({this.commentList, this.total});

  factory CommentListModel.fromJson(Map<String, dynamic> json) {
    return CommentListModel(
      commentList: (json['comments'] as List<dynamic>?)
          ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comments': commentList?.map((comment) => comment.toJson()).toList(),
      'total': total,
    };
  }

  @override
  String toString() {
    return 'CommentListModel(comments: $commentList, total: $total)';
  }
}

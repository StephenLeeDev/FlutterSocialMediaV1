class UpdateCommentModel {
  int commentId;
  String content;

  UpdateCommentModel({
    required this.content,
    required this.commentId,
  });

  factory UpdateCommentModel.fromJson(Map<String, dynamic> json) {
    return UpdateCommentModel(
      commentId: json['commentId'] as int,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'content': content,
    };
  }

  @override
  String toString() {
    return 'UpdateCommentModel(commentId: $commentId, content: $content)';
  }
}

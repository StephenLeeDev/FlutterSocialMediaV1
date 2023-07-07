class UpdateCommentModel {
  int postId;
  String content;

  UpdateCommentModel({
    required this.content,
    required this.postId,
  });

  factory UpdateCommentModel.fromJson(Map<String, dynamic> json) {
    return UpdateCommentModel(
      postId: json['postId'] as int,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'content': content,
    };
  }

  @override
  String toString() {
    return 'UpdateCommentModel(postId: $postId, content: $content)';
  }
}

class UpdateCommentModel {
  int id;
  String content;

  UpdateCommentModel({
    required this.id,
    required this.content,
  });

  factory UpdateCommentModel.fromJson(Map<String, dynamic> json) {
    return UpdateCommentModel(
      id: json['id'] as int,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
    };
  }

  @override
  String toString() {
    return 'UpdateCommentModel(id: $id, content: $content)';
  }
}

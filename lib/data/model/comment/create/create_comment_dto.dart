class CreateCommentDto {
  String? content;
  int? postId;
  int? parentCommentId;
  String? parentCommentAuthor;

  CreateCommentDto({
    this.content,
    this.postId,
    this.parentCommentId,
    this.parentCommentAuthor,
  });

  factory CreateCommentDto.fromJson(Map<String, dynamic> json) {
    return CreateCommentDto(
      content: json['content'] as String?,
      postId: json['postId'] as int?,
      parentCommentId: json['parentCommentId'] as int?,
      parentCommentAuthor: json['parentCommentAuthor'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'postId': postId,
      'parentCommentId': parentCommentId,
      'parentCommentAuthor': parentCommentAuthor,
    };
  }

  @override
  String toString() {
    return 'CreateCommentDto(content: $content, postId: $postId, parentCommentId: $parentCommentId, parentCommentAuthor: $parentCommentAuthor)';
  }
}

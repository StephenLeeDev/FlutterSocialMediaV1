import '../user/simple_user_info.dart';

class CommentModel {
  int? id;
  String? content;
  CommentType? type;
  int? parentCommentId;
  String? parentCommentAuthor;
  int? postId;
  SimpleUserInfo? user;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? childrenCount;

  CommentModel({
    this.id,
    this.content,
    this.type,
    this.parentCommentId,
    this.parentCommentAuthor,
    this.postId,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.childrenCount,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      content: json['content'],
      type: CommentType.values.firstWhere((type) => type.toString() == 'CommentType.${json['type']}'),
      parentCommentId: json['parentCommentId'],
      parentCommentAuthor: json['parentCommentAuthor'],
      postId: json['postId'],
      user: SimpleUserInfo.fromJson(json['user']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      childrenCount: json['childrenCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type?.toString().split('.').last,
      'parentCommentId': parentCommentId,
      'parentCommentAuthor': parentCommentAuthor,
      'postId': postId,
      'user': user?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'childrenCount': childrenCount,
    };
  }

  @override
  String toString() {
    return 'CommentModel(id: $id, content: $content, type: $type, parentCommentId: $parentCommentId, '
        'parentCommentAuthor: $parentCommentAuthor, postId: $postId, user: $user, createdAt: $createdAt, '
        'updatedAt: $updatedAt, childrenCount: $childrenCount)';
  }

  CommentModel copyWith({
    int? id,
    String? content,
    CommentType? type,
    int? parentCommentId,
    String? parentCommentAuthor,
    int? postId,
    SimpleUserInfo? user,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? childrenCount,
  }) {
    return CommentModel(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      parentCommentAuthor: parentCommentAuthor ?? this.parentCommentAuthor,
      postId: postId ?? this.postId,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      childrenCount: childrenCount ?? this.childrenCount,
    );
  }
}

enum CommentType {
  COMMENT,
  REPLY,
}
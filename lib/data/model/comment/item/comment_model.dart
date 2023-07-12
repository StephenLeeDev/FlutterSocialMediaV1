import '../../user/simple_user_info.dart';

class CommentModel {
  int? id;
  int get commentId => id ?? -1;
  String? content;
  String get getContent => content ?? "";
  CommentType? type;
  int? parentCommentId;
  String? parentCommentAuthor;
  int? postId;
  SimpleUserInfo? user;
  String get getUserName => user?.username ?? "Unknown";
  String get getUserEmail => user?.email ?? "Unknown";
  DateTime? createdAt;
  DateTime? updatedAt;
  int? childrenCount;
  int get getChildrenCount => childrenCount ?? 0;
  bool isMine = false;

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
    this.isMine = false,
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
      isMine: json['isMine'] ?? false,
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
      'isMine': isMine,
    };
  }

  @override
  String toString() {
    return 'CommentModel(id: $id, content: $content, type: $type, parentCommentId: $parentCommentId, '
        'parentCommentAuthor: $parentCommentAuthor, postId: $postId, user: $user, createdAt: $createdAt, '
        'updatedAt: $updatedAt, childrenCount: $childrenCount, isMine: $isMine)';
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
    bool isMine = false,
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
      isMine: this.isMine,
    );
  }

  bool isMyComment({required String myEmail}) => getUserEmail == myEmail;

  bool isUpdated() => createdAt != null && updatedAt != null && createdAt != updatedAt;

  String getSimpleName() {
    return runtimeType.toString();
  }

}

enum CommentType {
  COMMENT,
  REPLY,
}
import '../user/user_model.dart';

class PostModel {
  int? id;
  String? description;
  String? status;
  UserModel? user;
  DateTime? createdAt;
  List<String>? imageUrls;
  List<String>? likes;
  List<String>? bookMarkedUsers;
  int? commentCount;

  PostModel({
    this.id,
    this.description,
    this.status,
    this.user,
    this.createdAt,
    this.imageUrls,
    this.likes,
    this.bookMarkedUsers,
    this.commentCount,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    List<String> imageUrls = List<String>.from(json['imageUrls']);
    UserModel user = UserModel.fromJson(json['user']);

    return PostModel(
      id: json['id'],
      description: json['description'],
      status: json['status'],
      user: user,
      createdAt: DateTime.parse(json['createdAt']),
      imageUrls: imageUrls,
      likes: List<String>.from(json['likes']),
      bookMarkedUsers: List<String>.from(json['bookMarkedUsers']),
      commentCount: json['commentCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'status': status,
      'user': user?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'imageUrls': imageUrls,
      'likes': likes,
      'bookMarkedUsers': bookMarkedUsers,
      'commentCount': commentCount,
    };
  }

  @override
  String toString() {
    return 'PostModel(id: $id, description: $description, status: $status, user: $user, createdAt: $createdAt, imageUrls: $imageUrls, likes: $likes, bookMarkedUsers: $bookMarkedUsers, commentCount: $commentCount)';
  }

  String getUserName() {
    return user?.username ?? "Unknown";
  }

  bool isLikedThisPost(String myEmail) {
    return likes?.contains(myEmail) ?? false;
  }

}
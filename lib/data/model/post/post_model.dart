import '../user/user_model.dart';

class PostModel {
  int? id;
  String? description;
  String? status;
  UserModel? user;
  DateTime? createdAt;
  List<String>? imageUrls;
  bool? isLiked;
  bool? isBookmarked;
  int? commentCount;

  PostModel({
    this.id,
    this.description,
    this.status,
    this.user,
    this.createdAt,
    this.imageUrls,
    this.isLiked,
    this.isBookmarked,
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
      isLiked: json['isLiked'],
      isBookmarked: json['isBookmarked'],
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
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
      'commentCount': commentCount,
    };
  }

  @override
  String toString() {
    return 'PostModel(id: $id, description: $description, status: $status, user: $user, createdAt: $createdAt, imageUrls: $imageUrls, isLiked: $isLiked, isBookmarked: $isBookmarked, commentCount: $commentCount)';
  }

  PostModel copyWith({
    int? id,
    String? description,
    String? status,
    UserModel? user,
    DateTime? createdAt,
    List<String>? imageUrls,
    bool? isLiked,
    bool? isBookmarked,
    int? commentCount,
  }) {
    return PostModel(
      id: id ?? this.id,
      description: description ?? this.description,
      status: status ?? this.status,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      imageUrls: imageUrls ?? this.imageUrls,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      commentCount: commentCount ?? this.commentCount,
    );
  }

  String getUserName() {
    return user?.username ?? "Unknown";
  }

  setBookmark() {
    if (isBookmarked != null) isBookmarked = !isBookmarked!;
  }
}

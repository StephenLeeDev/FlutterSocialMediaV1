import '../../user/simple/item/simple_user_info_model.dart';

class PostModel {
  int? id;
  int get getId => id ?? -1;
  String? description;
  String get getDescription => description ?? "";
  String? status;
  SimpleUserInfoModel? user;
  String get getUserThumbnail => user?.getThumbnail ?? "";
  String get getUserEmail => user?.getEmail ?? "Unknown";
  String get getUserName => user?.getUserName ?? "Unknown";
  DateTime? createdAt;
  List<String>? imageUrls;
  String get getFirstImage => imageUrls?.first ?? "";
  int? likeCount;
  bool? isLiked;
  bool? isBookmarked;
  int? commentCount;
  bool isMine = false;

  PostModel({
    this.id,
    this.description,
    this.status,
    this.user,
    this.createdAt,
    this.imageUrls,
    this.likeCount,
    this.isLiked,
    this.isBookmarked,
    this.commentCount,
    this.isMine = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    List<String> imageUrls = List<String>.from(json['imageUrls']);
    SimpleUserInfoModel user = SimpleUserInfoModel.fromJson(json['user']);

    return PostModel(
      id: json['id'],
      description: json['description'],
      status: json['status'],
      user: user,
      createdAt: DateTime.parse(json['createdAt']),
      imageUrls: imageUrls,
      likeCount: json['likeCount'],
      isLiked: json['isLiked'],
      isBookmarked: json['isBookmarked'],
      commentCount: json['commentCount'],
      isMine: json['isMine'] ?? false,
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
      'likeCount': likeCount,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
      'commentCount': commentCount,
      'isMine': isMine,
    };
  }

  @override
  String toString() {
    return 'PostModel(id: $id, description: $description, status: $status, user: $user, createdAt: $createdAt, imageUrls: $imageUrls, likeCount: $likeCount, isLiked: $isLiked, isBookmarked: $isBookmarked, commentCount: $commentCount, isMine: $isMine))';
  }

  PostModel copyWith({
    int? id,
    String? description,
    String? status,
    SimpleUserInfoModel? user,
    DateTime? createdAt,
    List<String>? imageUrls,
    int? likeCount,
    bool? isLiked,
    bool? isBookmarked,
    int? commentCount,
    bool isMine = false,
  }) {
    return PostModel(
      id: id ?? this.id,
      description: description ?? this.description,
      status: status ?? this.status,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      imageUrls: imageUrls ?? this.imageUrls,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      commentCount: commentCount ?? this.commentCount,
      isMine: this.isMine,
    );
  }

  setBookmark() {
    if (isBookmarked != null) isBookmarked = !isBookmarked!;
  }

  setLike() {
    if (isLiked != null) isLiked = !isLiked!;
  }

  setLikeCount({required int value}) {
    likeCount = value;
  }

  bool isMyPost({required String myEmail}) => getUserEmail == myEmail;

  String getSimpleName() {
    return runtimeType.toString();
  }

}

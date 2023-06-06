import '../user/user_model.dart';

class PostModel {
  int id;
  String title;
  String description;
  String status;
  DateTime createdAt;
  List<String> imageUrls;
  UserModel user;

  PostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.imageUrls,
    required this.user,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    List<String> imageUrls = List<String>.from(json['imageUrls']);
    UserModel user = UserModel.fromJson(json['user']);

    return PostModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      imageUrls: imageUrls,
      user: user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'imageUrls': imageUrls,
      'user': user.toJson(),
    };
  }

  @override
  String toString() {
    return 'PostModel(id: $id, title: $title, description: $description, status: $status, createdAt: $createdAt, imageUrls: $imageUrls, user: $user)';
  }
}

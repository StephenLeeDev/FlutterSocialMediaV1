class UpdatePostDescriptionModel {
  int postId;
  String description;

  UpdatePostDescriptionModel({
    required this.postId,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'description': description,
    };
  }

  factory UpdatePostDescriptionModel.fromJson(Map<String, dynamic> json) {
    return UpdatePostDescriptionModel(
      postId: json['postId'],
      description: json['description'],
    );
  }

}
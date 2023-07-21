import 'package:image_picker/image_picker.dart';

class CreatePostModel {
  String? description;
  List<XFile>? images;

  CreatePostModel({
    this.description,
    this.images,
  });

  factory CreatePostModel.fromJson(Map<String, dynamic> json) {
    return CreatePostModel(
      description: json['description'],
      images: _parseImages(json['images']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'images': _convertImagesToJson(),
    };
  }

  static List<XFile> _parseImages(List<dynamic> imagesJson) {
    return imagesJson.map((imagePath) => XFile(imagePath)).toList();
  }

  List<String>? _convertImagesToJson() {
    return images?.map((image) => image.path).toList();
  }
}
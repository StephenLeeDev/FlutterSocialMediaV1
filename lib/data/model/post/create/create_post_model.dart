import 'package:dio/dio.dart';

class CreatePostModel {
  String description;
  List<MultipartFile> images;

  CreatePostModel({
    required this.description,
    required this.images,
  });
}
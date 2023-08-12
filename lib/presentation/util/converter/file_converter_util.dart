import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

/// It returns List<XFile> input as List<MultipartFile> format
Future<List<MultipartFile>> convertXFilesToMultipart({required List<XFile> files}) async {
  List<Future<MultipartFile>> imageFiles = files.map((image) => MultipartFile.fromFile(image.path)).toList();
  final List<MultipartFile> images = await Future.wait(imageFiles);
  return images;
}

/// It returns XFile input as MultipartFile format
Future<MultipartFile> convertXFileToMultipart({required XFile file}) async {
  Future<MultipartFile> imageFile = MultipartFile.fromFile(file.path);
  return imageFile;
}
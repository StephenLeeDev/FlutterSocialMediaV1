import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// It prints image file's information
Future<void> printImageInfo({String fileName = "", required File file}) async {

  int fileSizeInBytes = file.lengthSync();

  double fileSizeInKB = fileSizeInBytes / 1024;
  double fileSizeInMB = fileSizeInKB / 1024;

  Uint8List bytes = await file.readAsBytes();
  ui.Image imageUI = await decodeImageFromList(bytes);

  int width = imageUI.width;
  int height = imageUI.height;

  debugPrint('\nfileName : $fileName');

  debugPrint('Image Width: $width');
  debugPrint('Image Height: $height');

  // debugPrint('Size (Bytes): $fileSizeInBytes');
  debugPrint('Size (KB): $fileSizeInKB');
  // debugPrint('Size (MB): $fileSizeInMB');

}
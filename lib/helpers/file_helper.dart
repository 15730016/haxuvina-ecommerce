import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:open_filex/open_filex.dart';

import '../app_config.dart';

class FileHelper {
  static String getBase64FormateFile(String path) {
    File file = File(path);
    List<int> fileInByte = file.readAsBytesSync();
    return base64Encode(fileInByte);
  }

  static String buildFullImageUrl(dynamic raw) {
    final photo = raw?.toString().trim() ?? '';
    if (photo.isEmpty) {
      return '${AppConfig.BASE_URL}/assets/img/placeholder.png';
    }
    if (photo.startsWith('http')) return photo;
    return '${AppConfig.BASE_URL}/uploads/all/$photo';
  }
}

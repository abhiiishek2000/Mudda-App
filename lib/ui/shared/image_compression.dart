import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageCompression{
  static const imageQuality = 30;
  static Future<File?> compressAndGetFile(
      File file,
      String targetPath,
      ) async {
    final compressionFactor = (250 * 100) / (file.lengthSync() * 1000);
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: int.parse(compressionFactor
          .toString()
          .substring(0, compressionFactor.toString().indexOf('.'))),
    );

    print(file.lengthSync());
    print(result?.lengthSync());

    return result;
  }
}
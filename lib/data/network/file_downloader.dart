import 'dart:io';

import 'package:http/http.dart' as http;

class FileDownloader {
  Future downloadFile(String url, File targetFile) async {
    var response = await http.get(url);

    await targetFile.create(recursive: true);

    await targetFile.writeAsBytes(response.bodyBytes, mode: FileMode.write, flush: true);
  }
}

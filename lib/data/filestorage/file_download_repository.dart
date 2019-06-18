import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileDownloadRepository {
  Future<File> getFile(String directory, String filename) async {
    var path = join("downloaded", directory, filename);

    var documentsDirectory = await getApplicationDocumentsDirectory();

    return File(join(documentsDirectory.path, path));
  }

  Future<bool> fileExists(String directory, String filename) async {
    return await (await getFile(directory, filename)).exists();
  }
}

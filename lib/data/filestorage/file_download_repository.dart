import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'file_repository.dart';

class FileDownloadRepository extends FileRepository {
  Future<File> getFile(String directory, String filename) async {
    var path = join("downloaded", directory, filename);

    var documentsDirectory = await getApplicationDocumentsDirectory();

    return File(join(documentsDirectory.path, path));
  }
}

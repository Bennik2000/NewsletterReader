import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'file_repository.dart';

class FilePublicRepository extends FileRepository {
  @override
  Future<File> getFile(String directory, String filename) async {
    var path = join(directory, filename);

    Directory storageDirectory;

    if (Platform.isAndroid) {
      storageDirectory = await getExternalStorageDirectory();
    } else {
      storageDirectory = await getApplicationDocumentsDirectory();
    }

    return File(join(storageDirectory.path, path));
  }
}

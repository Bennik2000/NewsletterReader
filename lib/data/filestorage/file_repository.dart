import 'dart:io';

abstract class FileRepository {
  Future<File> getFile(String directory, String filename);

  Future<bool> fileExists(String directory, String filename) async {
    return await (await getFile(directory, filename)).exists();
  }
}

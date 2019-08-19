import 'dart:io';

import 'package:newsletter_reader/model/model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class NewsletterStoragePath {
  Future<String> getPathToNewsletterDirectory(Newsletter newsletter) async {
    var documentsDirectory = await getApplicationDocumentsDirectory();

    var path = join(documentsDirectory.path, "newsletters", newsletter.name);

    return path;
  }

  Future<String> getPathToArticleDirectory(Newsletter newsletter, Article article) async {
    var directory = await getPathToNewsletterDirectory(newsletter);
    return join(directory, article.id.toString());
  }

  Future<File> getArticleStorageFile(Newsletter newsletter, Article article) async {
    var directory = await getPathToArticleDirectory(newsletter, article);

    var filename = newsletter.name ?? newsletter.id.toString();

    filename += ".pdf";

    var file = File.fromUri(Uri.file(join(directory, filename)));

    await createFileIfNeeded(file);

    return file;
  }

  Future<File> getThumbnailFile(Newsletter newsletter, Article article) async {
    var directory = await getPathToArticleDirectory(newsletter, article);

    var filename = "thumbnail.png";

    return File.fromUri(Uri.file(join(directory, filename)));
  }

  Future createFileIfNeeded(File file) async {
    if (!(await file.exists())) {
      await file.create(recursive: true);
    }
  }
}

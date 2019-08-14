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

  Future<File> getNewsletterFile(Newsletter newsletter) async {
    var directory = await getPathToNewsletterDirectory(newsletter);

    var filename = newsletter.name ?? newsletter.id.toString();

    return File.fromUri(Uri.file(join(directory, filename)));
  }

  Future<File> getThumbnailFile(Newsletter newsletter) async {
    var directory = await getPathToNewsletterDirectory(newsletter);

    var filename = "thumbnail.png";

    return File.fromUri(Uri.file(join(directory, filename)));
  }
}

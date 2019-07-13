import 'dart:io';

import 'package:newsletter_reader/data/filestorage/file_public_repository.dart';
import 'package:newsletter_reader/data/model/model.dart';

class NewsletterShare {
  final Newsletter _newsletter;
  final FilePublicRepository _filePublicRepository;

  NewsletterShare(this._newsletter, this._filePublicRepository);

  Future shareNewsletter() async {
    var file = await _filePublicRepository.getFile("Newsletters", (_newsletter.name ?? _newsletter.id.toString()) + ".json");

    file.create(recursive: true);

    var json = NewsletterJsonHelper.toJson(_newsletter);

    await file.writeAsString(json, mode: FileMode.write);
  }
}

import 'dart:io';

import 'package:newsletter_reader/data/repository/newsletter_repository.dart';
import 'package:newsletter_reader/model/model.dart';

class NewsletterImport {
  final NewsletterRepository _newsletterRepository;

  NewsletterImport(this._newsletterRepository);

  Future importNewsletter(String path) async {
    var file = new File(path);

    var json = await file.readAsString();

    var newsletter = NewsletterJsonHelper.fromJson(json);

    newsletter.id = null;

    await _newsletterRepository.saveNewsletter(newsletter);
  }
}

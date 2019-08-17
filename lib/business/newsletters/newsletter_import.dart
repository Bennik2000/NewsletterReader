import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:newsletter_reader/data/repository/newsletter_repository.dart';
import 'package:newsletter_reader/model/model.dart';

class NewsletterImport {
  final NewsletterRepository _newsletterRepository;

  NewsletterImport(this._newsletterRepository);

  Future<bool> importNewsletter() async {
    var data = (await Clipboard.getData(Clipboard.kTextPlain)).text;

    var newsletterData = getNewsletterData(data);

    if (newsletterData == null) return false;

    try {
      var newsletter = NewsletterJsonHelper.fromJson(newsletterData);

      newsletter.id = null;
      newsletter.lastUpdated = null;

      await _newsletterRepository.saveNewsletter(newsletter);

      return true;
    } catch (e) {
      return false;
    }
  }

  String getNewsletterData(String data) {
    if (data == null) return null;

    var header = "===========Newsletter===========";
    var footer = "================================";

    var indexStart = data.indexOf(new RegExp(header));
    var indexEnd = data.indexOf(new RegExp(footer), indexStart > 0 ? indexStart : 0);

    if (indexStart < 0 || indexEnd < header.length) {
      return null;
    }

    try {
      var encodedData = data.substring(indexStart + header.length + 1, indexEnd - 1);
      return utf8.decode(base64.decode(encodedData));
    } catch (e) {
      return null;
    }
  }
}

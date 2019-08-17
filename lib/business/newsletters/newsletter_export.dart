import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:newsletter_reader/model/model.dart';

class NewsletterExport {
  final Newsletter _newsletter;

  NewsletterExport(this._newsletter);

  Future<bool> exportNewsletter() async {
    var header = "===========Newsletter===========";
    var footer = "================================";

    try {
      var json = NewsletterJsonHelper.toJson(_newsletter);

      var output = "$header\n${base64.encode(utf8.encode(json))}\n$footer";

      await Clipboard.setData(ClipboardData(text: output));

      return true;
    } catch (e) {
      return false;
    }
  }
}

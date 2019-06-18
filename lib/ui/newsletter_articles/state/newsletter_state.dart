import 'package:flutter/foundation.dart';
import 'package:newsletter_reader/data/model/model.dart';

class NewsletterState with ChangeNotifier {
  Newsletter _newsletter;

  Newsletter get newsletter => _newsletter;

  set newsletter(Newsletter newsletter) {
    _newsletter = newsletter;
    notifyListeners();
  }

  NewsletterState(this._newsletter);
}

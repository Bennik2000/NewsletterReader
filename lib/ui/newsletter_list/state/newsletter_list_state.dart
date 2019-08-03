import 'package:flutter/foundation.dart';
import 'package:newsletter_reader/data/repository/newsletter_repository.dart';
import 'package:newsletter_reader/model/model.dart';

class NewsletterListState with ChangeNotifier {
  bool isLoaded = false;
  bool isLoading = false;
  List<Newsletter> newsletters = <Newsletter>[];

  final NewsletterRepository _newsletterRepository;

  NewsletterListState(this._newsletterRepository);

  Future loadNewsletters() async {
    isLoading = true;
    isLoaded = false;
    notifyListeners();

    newsletters = await _newsletterRepository.queryNewsletters();

    isLoading = false;
    isLoaded = true;
    notifyListeners();
  }
}

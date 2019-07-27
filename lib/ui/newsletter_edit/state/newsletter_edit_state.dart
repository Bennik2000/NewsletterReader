import 'package:flutter/foundation.dart';
import 'package:newsletter_reader/data/repository/newsletter_repository.dart';
import 'package:newsletter_reader/model/model.dart';

class NewsletterEditState with ChangeNotifier {
  String _nameError;
  String get nameError => _nameError;
  set nameError(String nameError) {
    _nameError = nameError;
    notifyListeners();
  }

  String _urlError;
  String get urlError => _urlError;
  set urlError(String urlError) {
    _urlError = urlError;
    notifyListeners();
  }

  String _updateStrategyError;
  String get updateStrategyError => _updateStrategyError;
  set updateStrategyError(String updateStrategyError) {
    _updateStrategyError = updateStrategyError;
    notifyListeners();
  }

  String _updateIntervalError;
  String get updateIntervalError => _updateIntervalError;
  set updateIntervalError(String updateIntervalError) {
    _updateIntervalError = updateIntervalError;
    notifyListeners();
  }

  Newsletter _newsletter;
  Newsletter get newsletter => _newsletter;
  set newsletter(Newsletter newsletter) {
    _newsletter = newsletter;
    notifyListeners();
  }

  set updateInterval(UpdateInterval updateInterval) {
    _newsletter.updateInterval = updateInterval;
    notifyListeners();
  }

  set updateStrategy(UpdateStrategy updateStrategy) {
    _newsletter.updateStrategy = updateStrategy;
    notifyListeners();
  }

  set autoUpdateEnabled(bool isEnabled) {
    _newsletter.isAutoUpdateEnabled = isEnabled;
    notifyListeners();
  }

  set autoDownloadEnabled(bool isEnabled) {
    _newsletter.isAutoDownloadEnabled = isEnabled;
    notifyListeners();
  }

  bool get hasError =>
      (nameError?.isNotEmpty ?? false) ||
      (urlError?.isNotEmpty ?? false) ||
      (updateStrategyError?.isNotEmpty ?? false) ||
      (updateIntervalError?.isNotEmpty ?? false);

  final NewsletterRepository _newsletterRepository;

  NewsletterEditState(this._newsletter, this._newsletterRepository) {
    _nameError = null;
    _urlError = null;
    _updateIntervalError = null;
    _updateStrategyError = null;
  }

  void validate() {
    nameError = newsletter.name?.isEmpty ?? true ? "Der name darf nicht leer sein!" : null;
    updateStrategyError = newsletter.updateStrategy == null ? "Es muss eine update Strategie ausgewählt sein!" : null;
    urlError = newsletter.url?.isEmpty ?? true == null ? "Es muss eine Url angegeben sein!" : null;

    updateIntervalError = null;
    if (newsletter.isAutoUpdateEnabled ?? false) {
      updateIntervalError = newsletter.updateInterval == null ? "Es muss ein update Interval ausgewählt sein!" : null;
    }
  }

  Future save() async {
    await _newsletterRepository.saveNewsletter(newsletter);
  }

  Future delete() async {
    await _newsletterRepository.deleteNewsletter(newsletter);
  }
}

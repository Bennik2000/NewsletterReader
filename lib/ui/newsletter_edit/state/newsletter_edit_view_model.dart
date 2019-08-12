import 'package:flutter/foundation.dart';
import 'package:newsletter_reader/data/repository/newsletter_repository.dart';
import 'package:newsletter_reader/model/model.dart';
import 'package:newsletter_reader/ui/view_models/view_models.dart';

class NewsletterEditViewModel with ChangeNotifier {
  final NewsletterViewModel newsletter;

  String nameError;
  String urlError;
  String updateStrategyError;
  String updateIntervalError;

  String name;
  String url;

  UpdateInterval _updateInterval;
  UpdateInterval get updateInterval => _updateInterval;
  set updateInterval(UpdateInterval updateInterval) {
    _updateInterval = updateInterval;
    notifyListeners();
  }

  UpdateStrategy _updateStrategy;
  UpdateStrategy get updateStrategy => _updateStrategy;
  set updateStrategy(UpdateStrategy updateStrategy) {
    _updateStrategy = updateStrategy;
    notifyListeners();
  }

  bool _autoUpdateEnabled;
  bool get autoUpdateEnabled => _autoUpdateEnabled;
  set autoUpdateEnabled(bool autoUpdateEnabled) {
    _autoUpdateEnabled = autoUpdateEnabled;
    notifyListeners();
  }

  bool _autoDownloadEnabled;
  bool get autoDownloadEnabled => _autoDownloadEnabled;
  set autoDownloadEnabled(bool autoDownloadEnabled) {
    _autoDownloadEnabled = autoDownloadEnabled;
    notifyListeners();
  }

  bool get hasError =>
      (nameError?.isNotEmpty ?? false) ||
      (urlError?.isNotEmpty ?? false) ||
      (updateStrategyError?.isNotEmpty ?? false) ||
      (updateIntervalError?.isNotEmpty ?? false);

  final NewsletterRepository _newsletterRepository;

  NewsletterEditViewModel(this.newsletter, this._newsletterRepository){
    name = newsletter.newsletter.name;
    url = newsletter.newsletter.url;
    updateInterval = newsletter.newsletter.updateInterval;
    updateStrategy = newsletter.newsletter.updateStrategy;
    autoDownloadEnabled = newsletter.newsletter.isAutoDownloadEnabled;
    autoUpdateEnabled = newsletter.newsletter.isAutoUpdateEnabled;
  }

  void validate() {
    nameError = name?.isEmpty ?? true ? "Der name darf nicht leer sein!" : null;
    updateStrategyError = updateStrategy == null ? "Es muss eine update Strategie ausgewählt sein!" : null;
    urlError = url?.isEmpty ?? true == null ? "Es muss eine Url angegeben sein!" : null;

    updateIntervalError = null;
    if (autoUpdateEnabled ?? false) {
      updateIntervalError = updateInterval == null ? "Es muss ein update Interval ausgewählt sein!" : null;
    }
  }

  Future save() async {
    newsletter.newsletter.name = name;
    newsletter.newsletter.url = url;
    newsletter.newsletter.updateInterval = updateInterval;
    newsletter.newsletter.updateStrategy = updateStrategy;
    newsletter.newsletter.isAutoDownloadEnabled = autoDownloadEnabled;
    newsletter.newsletter.isAutoUpdateEnabled = autoUpdateEnabled;

    await _newsletterRepository.saveNewsletter(newsletter.newsletter);
  }
}

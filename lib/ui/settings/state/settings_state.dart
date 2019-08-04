import 'package:flutter/foundation.dart';
import 'package:newsletter_reader/data/repository/settings_repository.dart';

class SettingsState with ChangeNotifier {
  bool _notifyOnNewArticles = false;
  bool get notifyOnNewArticles => _notifyOnNewArticles;
  set notifyOnNewArticles(bool value) {
    _notifyOnNewArticles = value;
    notifyListeners();
    _settingsRepository.setNotifyOnNewArticles(value);
  }

  bool _notifyOnNewArticlesDownloaded = false;
  bool get notifyOnNewArticlesDownloaded => _notifyOnNewArticlesDownloaded;
  set notifyOnNewArticlesDownloaded(bool value) {
    _notifyOnNewArticlesDownloaded = value;
    notifyListeners();
    _settingsRepository.setNotifyOnNewArticlesDownloaded(value);
  }

  bool _notifyOnNoWifi = false;
  bool get notifyOnNoWifi => _notifyOnNoWifi;
  set notifyOnNoWifi(bool value) {
    _notifyOnNoWifi = value;
    notifyListeners();
    _settingsRepository.setNotifyOnNoWifi(value);
  }

  bool _notifyOnNoNewArticles = false;
  bool get notifyOnNoNewArticles => _notifyOnNoNewArticles;
  set notifyOnNoNewArticles(bool value) {
    _notifyOnNoNewArticles = value;
    notifyListeners();
    _settingsRepository.setNotifyOnNoNewArticles(value);
  }

  bool _notifyOnUpdateError = false;
  bool get notifyOnUpdateError => _notifyOnUpdateError;
  set notifyOnUpdateError(bool value) {
    _notifyOnUpdateError = value;
    notifyListeners();
    _settingsRepository.setNotifyOnUpdateError(value);
  }

  final SettingsRepository _settingsRepository;

  SettingsState(this._settingsRepository) {
    loadValues();
  }

  Future loadValues() async {
    notifyOnNewArticles = await _settingsRepository.getNotifyOnNewArticles();
    notifyOnNewArticlesDownloaded = await _settingsRepository.getNotifyOnNewArticlesDownloaded();
    notifyOnNoWifi = await _settingsRepository.getNotifyOnNoWifi();
    notifyOnNoNewArticles = await _settingsRepository.getNotifyOnNoNewArticles();
    notifyOnUpdateError = await _settingsRepository.getNotifyOnUpdateError();
  }
}

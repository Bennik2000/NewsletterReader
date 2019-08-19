import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  Future<bool> getNotifyOnNewArticles() async => await getBool("NotifyOnNewArticles", fallback: true);

  Future setNotifyOnNewArticles(bool value) async {
    await setBool("NotifyOnNewArticles", value);
  }

  Future<bool> getNotifyOnNewArticlesDownloaded() async => await getBool("NotifyOnNewArticlesDownloaded");

  Future setNotifyOnNewArticlesDownloaded(bool value) async {
    await setBool("NotifyOnNewArticlesDownloaded", value);
  }

  Future<bool> getNotifyOnNoWifi() async => await getBool("NotifyOnNoWifi");

  Future setNotifyOnNoWifi(bool value) async {
    await setBool("NotifyOnNoWifi", value);
  }

  Future<bool> getNotifyOnNoNewArticles() async => await getBool("NotifyOnNoNewArticles");

  Future setNotifyOnNoNewArticles(bool value) async {
    await setBool("NotifyOnNoNewArticles", value);
  }

  Future<bool> getNotifyOnUpdateError() async => await getBool("NotifyOnUpdateError");

  Future setNotifyOnUpdateError(bool value) async {
    await setBool("NotifyOnUpdateError", value);
  }

  Future<bool> getBool(String key, {bool fallback}) async {
    fallback = fallback ?? false;

    return (await _getPreferences()).getBool(key) ?? fallback;
  }

  Future setBool(String key, bool value) async {
    (await _getPreferences()).setBool(key, value);
  }

  Future<SharedPreferences> _getPreferences() async {
    return await SharedPreferences.getInstance();
  }
}

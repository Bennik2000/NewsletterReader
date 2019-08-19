import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'localization_strings.dart';

class L {
  String get articleFileOpening => _getValue(ArticleFileOpening);
  String get buttonCancel => _getValue(ButtonCancel);
  String get buttonDelete => _getValue(ButtonDelete);
  String get buttonOk => _getValue(ButtonOk);
  String get editNewsletterAutoDownloadArticles => _getValue(EditNewsletterAutoDownloadArticles);
  String get editNewsletterAutoUpdateArticles => _getValue(EditNewsletterAutoUpdateArticles);
  String get editNewsletterNameHint => _getValue(EditNewsletterNameHint);
  String get editNewsletterPageTitle => _getValue(EditNewsletterPageTitle);
  String get editNewsletterUpdateIntervalHelper => _getValue(EditNewsletterUpdateIntervalHelper);
  String get editNewsletterUpdateIntervalLabel => _getValue(EditNewsletterUpdateIntervalLabel);
  String get editNewsletterUpdateStrategyHelper => _getValue(EditNewsletterUpdateStrategyHelper);
  String get editNewsletterUpdateStrategyLabel => _getValue(EditNewsletterUpdateStrategyLabel);
  String get editNewsletterUrlHelper => _getValue(EditNewsletterUrlHelper);
  String get editNewsletterUrlLabel => _getValue(EditNewsletterUrlLabel);
  String get exportNewsletterDialogMessage => _getValue(ExportNewsletterDialogMessage);
  String get exportNewsletterDialogTitle => _getValue(ExportNewsletterDialogTitle);
  String get exportNewsletterFailedDialogMessage => _getValue(ExportNewsletterFailedDialogMessage);
  String get exportNewsletterFailedDialogTitle => _getValue(ExportNewsletterFailedDialogTitle);
  String get importArticleButton => _getValue(ImportArticleButton);
  String get importNewsletterButton => _getValue(ImportNewsletterButton);
  String get importNewsletterDialogTitle => _getValue(ImportNewsletterDialogTitle);
  String get importNewsletterFailedDialogMessage => _getValue(ImportNewsletterFailedDialogMessage);
  String get importNewsletterFailedDialogTitle => _getValue(ImportNewsletterFailedDialogTitle);
  String get newsletterAvailableArticles => _getValue(NewsletterAvailableArticles);
  String get newsletterNeverUpdated => _getValue(NewsletterNeverUpdated);
  String get newslettersListPageTitle => _getValue(NewslettersListPageTitle);
  String get noArticlesAvailable => _getValue(NoArticlesAvailable);
  String get noNewslettersEmptyState => _getValue(NoNewslettersEmptyState);
  String get settingsNotificationOnNewArticles => _getValue(SettingsNotificationOnNewArticles);
  String get settingsNotificationOnNewArticlesDownloaded => _getValue(SettingsNotificationOnNewArticlesDownloaded);
  String get settingsNotificationOnNoNewArticles => _getValue(SettingsNotificationOnNoNewArticles);
  String get settingsNotificationOnNoWifi => _getValue(SettingsNotificationOnNoWifi);
  String get settingsNotificationOnUpdateError => _getValue(SettingsNotificationOnUpdateError);
  String get settingsPageTitle => _getValue(SettingsPageTitle);
  String get articleMenuDelete => _getValue(ArticleMenuDelete);
  String get articleMenuDeleteDownload => _getValue(ArticleMenuDeleteDownload);
  String get articleMenuDownload => _getValue(ArticleMenuDownload);
  String get articleMenuRead => _getValue(ArticleMenuRead);
  String get newsletterMenuDelete => _getValue(NewsletterMenuDelete);
  String get newsletterMenuEdit => _getValue(NewsletterMenuEdit);
  String get newsletterMenuExport => _getValue(NewsletterMenuExport);
  String get newsletterUpdatedTodayAt => _getValue(NewsletterUpdatedTodayAt);
  String get newsletterUpdatedYesterdayAt => _getValue(NewsletterUpdatedYesterdayAt);
  String get newsletterUpdatedAt => _getValue(NewsletterUpdatedAt);

  String get couldImportNewsletterDialogTitle => _getValue(CouldImportNewsletterDialogTitle);
  String get couldImportNewsletterDialogMessage => _getValue(CouldImportNewsletterDialogMessage);
  String get couldImportNewsletterDialogButtonNewNewsletter => _getValue(CouldImportNewsletterDialogButtonNewNewsletter);
  String get couldImportNewsletterDialogButtonImportNewsletter => _getValue(CouldImportNewsletterDialogButtonImportNewsletter);

  final Locale locale;

  L(this.locale);

  static L of(BuildContext context) {
    return Localizations.of<L>(context, L);
  }

  static Map<String, Map<String, String>> _localizedValues = {"de": de, "en": en};

  _getValue(String key) => _localizedValues[locale.languageCode][key] ?? "";
}

class LocalizationDelegate extends LocalizationsDelegate<L> {
  const LocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['de', 'en'].contains(locale.languageCode);

  @override
  Future<L> load(Locale locale) {
    return SynchronousFuture<L>(L(locale));
  }

  @override
  bool shouldReload(LocalizationDelegate old) => false;
}

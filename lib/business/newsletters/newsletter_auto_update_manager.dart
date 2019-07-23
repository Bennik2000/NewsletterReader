import 'package:newsletter_reader/business/newsletters/newsletter_article_updater.dart';
import 'package:newsletter_reader/data/repository/newsletter_repository.dart';
import 'package:newsletter_reader/model/model.dart';
import 'package:newsletter_reader/util/cancellation_token.dart';

class NewsletterAutoUpdateManager {
  final NewsletterRepository newsletterRepository;
  final NewsletterArticleUpdaterFactory newsletterUpdaterFactory;

  NewsletterAutoUpdateManager(this.newsletterRepository, this.newsletterUpdaterFactory);

  Future tick(DateTime now, CancellationToken token) async {
    var newsletters = await newsletterRepository.queryNewsletters();

    var startDateTime = DateTime.now();

    newsletters.forEach((n) async {
      // The tick() function may be executed in the background. iOS limits the background time to 30s so
      // we try to stay in this limit
      if (startDateTime.add(Duration(seconds: 20)).isBefore(DateTime.now())) {
        return;
      }

      await _updateNewsletterIfNeeded(now, n);
    });
  }

  Future _updateNewsletterIfNeeded(DateTime now, Newsletter newsletter) async {
    if (_canDoUpdateNow(now, newsletter)) {
      await newsletterUpdaterFactory.getNewArticleUpdaterInstance(newsletter).updateArticles();
    }
  }

  bool _canDoUpdateNow(DateTime now, Newsletter newsletter) {
    var preferredUpdateTime = newsletter.updateTime;
    var updateInterval = newsletter.updateInterval;

    var nextUpdate = newsletter.lastUpdated;

    nextUpdate = _alignWithUpdateTimeIfNeeded(nextUpdate, preferredUpdateTime, updateInterval);
    nextUpdate = _getNextUpdate(nextUpdate, updateInterval);

    return now.isAfter(nextUpdate);
  }

  DateTime _getNextUpdate(DateTime lastUpdate, UpdateInterval updateInterval) {
    switch (updateInterval) {
      case UpdateInterval.Hourly:
        return lastUpdate.add(Duration(hours: 1));
      case UpdateInterval.Daily:
        return lastUpdate.add(Duration(days: 1));
      case UpdateInterval.Weekly:
        return lastUpdate.add(Duration(days: 7));
      case UpdateInterval.Monthly:
        var newMonth = lastUpdate.month;
        var newYear = lastUpdate.year;

        if (newMonth > 12) {
          newMonth -= 12;
          newYear += 1;
        }

        return DateTime(
          newYear,
          newMonth,
          lastUpdate.hour,
          lastUpdate.minute,
          lastUpdate.second,
          lastUpdate.millisecond,
          lastUpdate.microsecond,
        );
      case UpdateInterval.Manual:
        break;
    }

    return lastUpdate;
  }

  DateTime _alignWithUpdateTimeIfNeeded(DateTime nextUpdate, DateTime preferredUpdateTime, UpdateInterval updateInterval) {
    switch (updateInterval) {
      case UpdateInterval.Hourly:
        return DateTime(
          nextUpdate.year,
          nextUpdate.month,
          nextUpdate.hour,
          preferredUpdateTime.minute,
        );
      case UpdateInterval.Weekly:
      case UpdateInterval.Monthly:
      case UpdateInterval.Daily:
        return DateTime(
          nextUpdate.year,
          nextUpdate.month,
          preferredUpdateTime.hour,
          preferredUpdateTime.minute,
        );
      case UpdateInterval.Manual:
        break;
    }

    return nextUpdate;
  }
}

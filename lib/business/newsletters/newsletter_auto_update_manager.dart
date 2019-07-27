import 'package:newsletter_reader/business/newsletters/newsletter_article_updater.dart';
import 'package:newsletter_reader/business/notification/notificator.dart';
import 'package:newsletter_reader/data/repository/newsletter_repository.dart';
import 'package:newsletter_reader/model/model.dart';

class NewsletterAutoUpdateManager {
  final NewsletterRepository newsletterRepository;
  final NewsletterArticleUpdaterFactory newsletterUpdaterFactory;
  final Notificator notificator;

  NewsletterAutoUpdateManager(this.newsletterRepository, this.newsletterUpdaterFactory, this.notificator);

  Future tick(DateTime now) async {
    var newsletters = await newsletterRepository.queryNewsletters();

    var startDateTime = DateTime.now();

    newsletters.forEach((n) async {
      // The tick() function may be executed in the background. iOS limits the background time to 30s so
      // we try to stay in this limit
      if (startDateTime.add(Duration(seconds: 25)).isBefore(DateTime.now())) {
        return;
      }

      await _updateNewsletterIfNeeded(now, n);
    });
  }

  Future _updateNewsletterIfNeeded(DateTime now, Newsletter newsletter) async {
    if (newsletter.isAutoUpdateEnabled && _canDoUpdateNow(now, newsletter)) {
      var newNewsletters = await newsletterUpdaterFactory.getNewArticleUpdaterInstance(newsletter).updateArticles();

      if (newNewsletters.isNotEmpty) {
        notificator.showSimpleTextNotification(
            "Neue Beiträge für ${newsletter.name}", "Es gibt neue Beiträge für ${newsletter.name}");
      }
    }
  }

  bool _canDoUpdateNow(DateTime now, Newsletter newsletter) {
    var preferredUpdateTime = newsletter.updateTime ?? DateTime.now();
    var updateInterval = newsletter.updateInterval ?? UpdateInterval.Daily;
    var nextUpdate = newsletter.lastUpdated ?? DateTime.fromMillisecondsSinceEpoch(0);

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
      default:
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
          nextUpdate.day,
          nextUpdate.hour,
          preferredUpdateTime.minute,
        );
      case UpdateInterval.Weekly:
      case UpdateInterval.Monthly:
      case UpdateInterval.Daily:
        return DateTime(
          nextUpdate.year,
          nextUpdate.month,
          nextUpdate.day,
          preferredUpdateTime.hour,
          preferredUpdateTime.minute,
        );
      default:
        break;
    }

    return nextUpdate;
  }
}

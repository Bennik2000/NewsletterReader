import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/business/articles/article_auto_download_manager.dart';
import 'package:newsletter_reader/business/newsletters/newsletter_auto_update_manager.dart';
import 'package:newsletter_reader/business/util/cancellation_token.dart';
import 'package:newsletter_reader/ui/dependency_injection.dart';

Future main() async {
  var startDateTime = DateTime.now();

  inject();

  var autoUpdateManager = new NewsletterAutoUpdateManager(
    kiwi.Container().resolve(),
    kiwi.Container().resolve(),
    kiwi.Container().resolve(),
  );

  var cancellationToken = new CancellationToken(startDateTime.add(Duration(seconds: 25)));
  await autoUpdateManager.tick(startDateTime, cancellationToken);

  var autoDownloadManager = new ArticleAutoDownloadManager(
    kiwi.Container().resolve(),
    kiwi.Container().resolve(),
    kiwi.Container().resolve(),
    kiwi.Container().resolve(),
  );

  await autoDownloadManager.tick(cancellationToken);
}

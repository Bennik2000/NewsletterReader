import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/business/newsletters/newsletter_article_updater.dart';
import 'package:newsletter_reader/business/newsletters/newsletter_auto_update_manager.dart';
import 'package:newsletter_reader/ui/dependency_injection.dart';

Future main() async {
  inject();

  await new NewsletterAutoUpdateManager(
    kiwi.Container().resolve(),
    new NewsletterArticleUpdaterFactory(
      kiwi.Container().resolve(),
      kiwi.Container().resolve(),
    ),
  ).tick(DateTime.now());
}

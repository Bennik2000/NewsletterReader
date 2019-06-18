import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/data/database/DatabaseAccess.dart';
import 'package:newsletter_reader/data/repository/ArticleRepository.dart';
import 'package:newsletter_reader/data/repository/NewsletterRepository.dart';

void inject() {
  kiwi.Container()
    ..registerInstance(new DatabaseAccess())
    ..registerFactory((c) => NewsletterRepository(c.resolve()))
    ..registerFactory((c) => ArticleRepository(c.resolve()));
}

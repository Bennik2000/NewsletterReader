import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/business/articles/article_download_delete.dart';
import 'package:newsletter_reader/business/articles/article_downloader.dart';
import 'package:newsletter_reader/business/newsletters/newsletter_article_updater.dart';
import 'package:newsletter_reader/data/database/DatabaseAccess.dart';
import 'package:newsletter_reader/data/filestorage/file_download_repository.dart';
import 'package:newsletter_reader/data/network/file_downloader.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/data/repository/newsletter_repository.dart';

void inject() {
  try {
    kiwi.Container()
      ..registerInstance(new DatabaseAccess())
      ..registerFactory((c) => NewsletterRepository(c.resolve()))
      ..registerFactory((c) => ArticleRepository(c.resolve()))
      ..registerFactory((c) => FileDownloadRepository())
      ..registerFactory((c) => FileDownloader())
      ..registerFactory((c) => NewsletterArticleUpdaterFactory(c.resolve(), c.resolve()))
      ..registerFactory((c) => ArticleDownloaderFactory(c.resolve(), c.resolve(), c.resolve()))
      ..registerFactory((c) => ArticleDownloadDeleteFactory(c.resolve()));
  } catch (e) {}
}

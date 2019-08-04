import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/business/articles/article_delete.dart';
import 'package:newsletter_reader/business/articles/article_download_delete.dart';
import 'package:newsletter_reader/business/articles/article_downloader.dart';
import 'package:newsletter_reader/business/articles/article_thumbnail_creator.dart';
import 'package:newsletter_reader/business/newsletters/newsletter_article_updater.dart';
import 'package:newsletter_reader/business/notification/notificator.dart';
import 'package:newsletter_reader/business/pdf/pdf_to_image_renderer.dart';
import 'package:newsletter_reader/data/database/DatabaseAccess.dart';
import 'package:newsletter_reader/data/filestorage/file_download_repository.dart';
import 'package:newsletter_reader/data/network/file_downloader.dart';
import 'package:newsletter_reader/data/repository/article_repository.dart';
import 'package:newsletter_reader/data/repository/newsletter_repository.dart';
import 'package:newsletter_reader/data/repository/settings_repository.dart';
import 'package:newsletter_reader/platform/native_pdf_to_image_renderer.dart';

import 'local_notificator.dart';

void inject() {
  try {
    kiwi.Container()
      ..registerInstance(new DatabaseAccess())
      ..registerFactory((c) => NewsletterRepository(c.resolve()))
      ..registerFactory((c) => ArticleRepository(c.resolve()))
      ..registerFactory((c) => FileDownloadRepository())
      ..registerFactory((c) => FileDownloader())
      ..registerFactory((c) => SettingsRepository())
      ..registerFactory((c) => NewsletterArticleUpdaterFactory(c.resolve(), c.resolve()))
      ..registerFactory((c) => ArticleDownloaderFactory(c.resolve(), c.resolve(), c.resolve(), c.resolve()))
      ..registerFactory((c) => ArticleDownloadDeleteFactory(c.resolve()))
      ..registerFactory((c) => ArticleDeleteFactory(c.resolve(), c.resolve()))
      ..registerFactory((c) => ArticleThumbnailCreatorFactory(c.resolve(), c.resolve(), c.resolve()))
      ..registerFactory<PdfToImageRenderer, NativePdfToImageRenderer>((c) => NativePdfToImageRenderer())
      ..registerFactory<Notificator, LocalNotificator>((c) => LocalNotificator());
  } catch (e) {}
}

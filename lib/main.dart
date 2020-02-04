import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/business/articles/database_article_sanitizer.dart';
import 'package:newsletter_reader/system/periodic_background_task.dart';
import 'package:newsletter_reader/ui/app.dart';
import 'package:newsletter_reader/ui/dependency_injection.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  inject();

  await new DatabaseArticleSanitizer(
    kiwi.Container().resolve(),
    kiwi.Container().resolve(),
  ).sanitize();

  runApp(MyApp());
  new PeriodicBackgroundTask().registerBackgroundTask();
}

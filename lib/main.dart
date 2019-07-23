import 'package:flutter/material.dart';
import 'package:newsletter_reader/system/periodic_background_task.dart';
import 'package:newsletter_reader/ui/app.dart';
import 'package:newsletter_reader/ui/dependency_injection.dart';

void main() {
  inject();
  runApp(MyApp());
  new PeriodicBackgroundTask().registerBackgroundTask();
}

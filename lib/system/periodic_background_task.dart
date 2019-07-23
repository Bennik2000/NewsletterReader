import 'dart:io';

import 'package:background_fetch/background_fetch.dart';
import 'package:newsletter_reader/data/filestorage/file_public_repository.dart';

void backgroundHeadlessTaskHandler() async {
  new PeriodicBackgroundTask().backgroundTaskHandler(DateTime.now(), true);
}

class PeriodicBackgroundTask {
  Future registerBackgroundTask() async {
    BackgroundFetch.registerHeadlessTask(backgroundHeadlessTaskHandler);

    var config = BackgroundFetchConfig(
      minimumFetchInterval: 30,
      stopOnTerminate: false,
      enableHeadless: true,
      startOnBoot: true,
    );

    var status = await BackgroundFetch.configure(config, () => backgroundTaskHandler(DateTime.now(), false));

    if (status != BackgroundFetch.STATUS_AVAILABLE) {
      throw new RegisterBackgroundFetchException();
    }
  }

  Future backgroundTaskHandler(DateTime now, bool isHeadless) async {
    try {
      await _writeLogEntry("[${DateTime.now().toIso8601String()}] Event received.\n");
    } finally {
      BackgroundFetch.finish();
    }
  }

  Future _writeLogEntry(String logMessage) async {
    var file = await new FilePublicRepository().getFile("Newsletter", "backgroundFetchLog.log");
    await file.writeAsString(logMessage, mode: FileMode.append);
  }
}

class RegisterBackgroundFetchException with Exception {}

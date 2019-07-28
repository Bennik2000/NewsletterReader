import 'package:background_fetch/background_fetch.dart';

import 'background_main.dart' as background_main;

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
    await background_main.main().catchError((e) {
      print(e);
    }).whenComplete(() {
      BackgroundFetch.finish();
    });
  }
}

class RegisterBackgroundFetchException with Exception {}

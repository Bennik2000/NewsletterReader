import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newsletter_reader/ui/utils/device_utils.dart' as device_utils;

import 'main_page/main_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    applyPreferredDeviceOrientations(context);

    return MaterialApp(
      title: 'Newsletter reader',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
      ),
      home: NewslettersMasterDetailContainer(),
    );
  }

  void applyPreferredDeviceOrientations(BuildContext context) {
    var deviceOrientations = [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ];

    if (device_utils.isTablet(context)) {
      deviceOrientations.addAll([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }

    SystemChrome.setPreferredOrientations(deviceOrientations);
  }
}

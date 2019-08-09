import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'newsletter_list/newsletter_list_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);

    return MaterialApp(
      title: 'Newsletter reader',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
      ),
      home: NewsletterListPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newsletter_reader/ui/newsletter_list/newsletters_master_detail_container.dart';

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
      home: NewslettersMasterDetailContainer(),
    );
  }
}

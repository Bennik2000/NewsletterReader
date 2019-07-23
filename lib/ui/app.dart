import 'package:flutter/material.dart';

import 'newsletter_list/newsletter_list_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Newsletter reader',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: NewsletterListPage(),
    );
  }
}

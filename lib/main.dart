import 'package:flutter/material.dart';
import 'package:newsletter_reader/ui/dependency_injection.dart';
import 'package:newsletter_reader/ui/newsletter_list/newsletter_list_page.dart';

void main() {
  inject();
  runApp(MyApp());
}

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

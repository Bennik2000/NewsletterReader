import 'package:flutter/material.dart';
import 'package:newsletter_reader/data/model/Newsletter.dart';
import 'package:newsletter_reader/ui/NewsletterListWidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Newsletter> newsletters = new List();

    newsletters.add(new Newsletter("Schwabo"));
    newsletters.add(new Newsletter("Mitteilungsblatt Beffendorf"));
    newsletters.add(new Newsletter(
        "Schwabo sd af dsaf asfd asd fadsfdaf asdf fdadf f asf ewr qw fad ycxv  ds ad fea fadsf asdf asd gsdgbd fhrtdg rds fasdf as fasdf asd"));
    newsletters.add(new Newsletter("Schwabo"));
    newsletters.add(new Newsletter("Schwabo"));
    newsletters.add(new Newsletter("Schwabo"));
    newsletters.add(new Newsletter("Schwabo"));
    newsletters.add(new Newsletter("Schwabo"));
    newsletters.add(new Newsletter("Schwabo"));
    newsletters.add(new Newsletter("Schwabo"));
    newsletters.add(new Newsletter("Schwabo"));
    newsletters.add(new Newsletter("Schwabo"));
    newsletters.add(new Newsletter("Schwabo"));
    newsletters.add(new Newsletter("Schwabo"));
    newsletters.add(new Newsletter("Schwabo"));
    newsletters.add(new Newsletter("Schwabo"));
    newsletters.add(new Newsletter("Schwabo"));
    newsletters.add(new Newsletter("Schwabo"));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: NewsletterListWidget(
          newsletters: newsletters,
          onNewsletterTap: (Newsletter newsletter){

          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

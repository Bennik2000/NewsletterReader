import 'package:flutter/material.dart';

class NewslettersEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(64, 128, 64, 64),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("Hier gibt es leider noch keine Newsletter zu sehen. Füge einen neuen Newsletter mit + hinzu"),
        ],
      ),
    );
  }
}

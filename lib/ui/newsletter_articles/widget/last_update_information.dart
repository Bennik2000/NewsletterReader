import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsletter_reader/ui/newsletter_articles/state/newsletter_state.dart';
import 'package:provider/provider.dart';

class LastUpdatedInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NewsletterState>(
      builder: (BuildContext context, NewsletterState value, Widget child) {
        if (value.newsletter?.lastUpdated != null) {
          return Text(
            getPrettyLastUpdatedString(value.newsletter?.lastUpdated),
            style: TextStyle(color: Colors.black54),
          );
        } else {
          return Text(
            "Noch nie aktualisiert",
            style: TextStyle(color: Colors.black54),
          );
        }
      },
    );
  }

  String getPrettyLastUpdatedString(DateTime date) {
    DateTime now = DateTime.now();

    String dateString = DateFormat.yMd().format(date);
    String timeString = DateFormat.Hm().format(date);

    if (date.day == now.day && date.month == now.month && date.year == now.year) {
      return "Zulezt aktualisiert heute um $timeString Uhr";
    } else if (date.day == now.day - 1 && date.month == now.month && date.year == now.year) {
      return "Zulezt aktualisiert gestern um $timeString Uhr";
    }

    return "Zuletzt aktualisiert am $dateString um $timeString";
  }
}

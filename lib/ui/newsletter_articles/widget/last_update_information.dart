import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newsletter_reader/ui/i18n/localizations.dart';
import 'package:newsletter_reader/ui/view_models/view_models.dart';
import 'package:newsletter_reader/util/util.dart';
import 'package:provider/provider.dart';

class LastUpdatedInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, NewsletterViewModel value, Widget child) {
        String text;

        if (value.newsletter?.lastUpdated != null) {
          text = getPrettyLastUpdatedString(context, value.newsletter?.lastUpdated);
        } else {
          text = L.of(context).newsletterNeverUpdated;
        }

        return Text(
          text,
          style: Theme.of(context).textTheme.body1,
        );
      },
    );
  }

  String getPrettyLastUpdatedString(BuildContext context, DateTime date) {
    DateTime now = DateTime.now();

    String dateString = DateFormat.yMd(L.of(context).locale.languageCode).format(date);
    String timeString = DateFormat.Hm(L.of(context).locale.languageCode).format(date);

    if (date.day == now.day && date.month == now.month && date.year == now.year) {
      return stringFormat(L.of(context).newsletterUpdatedTodayAt, [timeString]);
    } else if (date.day == now.day - 1 && date.month == now.month && date.year == now.year) {
      return stringFormat(L.of(context).newsletterUpdatedYesterdayAt, [timeString]);
    }

    return stringFormat(L.of(context).newsletterUpdatedAt, [dateString, timeString]);
  }
}

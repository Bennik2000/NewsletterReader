import 'package:flutter/material.dart';
import 'package:newsletter_reader/model/model.dart';
import 'package:provider/provider.dart';

import 'state/newsletter_edit_state.dart';

class NewsletterEdit extends StatefulWidget {
  final Newsletter newsletter;

  const NewsletterEdit({Key key, this.newsletter}) : super(key: key);

  @override
  _NewsletterEditState createState() => _NewsletterEditState(newsletter);
}

class _NewsletterEditState extends State<NewsletterEdit> {
  final TextEditingController _nameTextEditingController =
      new TextEditingController();
  final TextEditingController _urlTextEditingController =
      new TextEditingController();

  final Newsletter _newsletter;

  _NewsletterEditState(this._newsletter) {
    _nameTextEditingController.text = _newsletter.name;
    _urlTextEditingController.text = _newsletter.url;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Consumer(
              builder: (BuildContext context, NewsletterEditState state, _) =>
                  TextField(
                decoration: InputDecoration(
                  hintText: "Name",
                  errorText: state?.nameError,
                  alignLabelWithHint: true,
                ),
                controller: _nameTextEditingController,
                onChanged: (String value) {
                  _newsletter.name = value;
                },
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Padding(
              child: Consumer(
                builder: (BuildContext context, NewsletterEditState state, _) =>
                    InputDecorator(
                  child: DropdownButton(
                    isExpanded: true,
                    items: getUpdateStrategyMenuItems(),
                    onChanged: (value) {
                      state.updateStrategy = value;
                    },
                    value: state.newsletter.updateStrategy,
                    underline: Container(),
                    isDense: true,
                  ),
                  decoration: InputDecoration(
                    labelText: "Update Strategie",
                    helperText:
                        "Gibt an, wie nach neuen Ausgaben gesucht werden soll",
                    errorText: state.updateStrategyError,
                  ),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
            ),
            SizedBox(
              height: 16,
            ),
            Consumer(
              builder: (BuildContext context, NewsletterEditState state, _) {
                return TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.insert_link),
                    labelText: "Url",
                    helperText:
                        "Die Url, wo nach neuen Ausgaben gesucht werden soll",
                    errorText: state.urlError,
                    alignLabelWithHint: true,
                  ),
                  controller: _urlTextEditingController,
                  onChanged: (String value) {
                    _newsletter.url = value;
                  },
                );
              },
            ),
            SizedBox(
              height: 32,
            ),
            Container(
              color: Theme.of(context).dividerColor,
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
              child: Row(
                children: <Widget>[
                  Consumer(
                    builder:
                        (BuildContext context, NewsletterEditState state, _) =>
                            Checkbox(
                      onChanged: (isChecked) {
                        state.autoUpdateEnabled = isChecked;
                      },
                      value: state.newsletter.isAutoUpdateEnabled ?? false,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Automatisch nach neuen Beiträgen suchen",
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
            ),
            Consumer(
              builder: (BuildContext context, NewsletterEditState state, _) =>
                  AnimatedSwitcher(
                child: state.newsletter.isAutoUpdateEnabled ?? false
                    ? Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                            child: Row(
                              children: <Widget>[
                                Consumer(
                                  builder: (BuildContext context,
                                          NewsletterEditState state, _) =>
                                      Checkbox(
                                    onChanged: (isChecked) {
                                      state.autoDownloadEnabled = isChecked;
                                    },
                                    value: state
                                            .newsletter.isAutoDownloadEnabled ??
                                        false,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Neue Beiträge automatisch herunterladen",
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Consumer(
                            builder: (BuildContext context,
                                    NewsletterEditState state, _) =>
                                InputDecorator(
                              child: DropdownButton(
                                isExpanded: true,
                                items: getUpdateIntervalMenuItems(),
                                onChanged: (value) {
                                  state.updateInterval = value;
                                },
                                value: state.newsletter.updateInterval,
                                underline: Container(),
                                isDense: true,
                              ),
                              decoration: InputDecoration(
                                icon: Icon(Icons.watch_later),
                                labelText: "Update Interval",
                                helperText:
                                    "Das Interval, mit dem neue Ausgaben gesucht werden",
                                errorText: state.updateIntervalError,
                              ),
                            ),
                          )
                        ],
                      )
                    : Container(),
                duration: Duration(milliseconds: 200),
              ),
            ),
            SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<UpdateInterval>> getUpdateIntervalMenuItems() {
    return UpdateInterval.values
        .map((code) => new DropdownMenuItem(
            value: code, child: new Text(code.toString().split('.').last)))
        .toList();
  }

  List<DropdownMenuItem> getUpdateStrategyMenuItems() {
    return UpdateStrategy.values
        .map((code) => new DropdownMenuItem(
            value: code, child: new Text(code.toString().split('.').last)))
        .toList();
  }
}

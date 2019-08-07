import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/model/model.dart';
import 'package:newsletter_reader/ui/newsletter_edit/state/newsletter_edit_state.dart';
import 'package:provider/provider.dart';

class NewsletterEditPage extends StatefulWidget {
  final Newsletter newsletter;

  NewsletterEditPage(this.newsletter);

  @override
  State<StatefulWidget> createState() => _NewsletterEditPageState(newsletter);
}

class _NewsletterEditPageState extends State<NewsletterEditPage> {
  final TextEditingController _nameTextEditingController = new TextEditingController();
  final TextEditingController _urlTextEditingController = new TextEditingController();
  final Newsletter _newsletter;

  _NewsletterEditPageState(this._newsletter) {
    _nameTextEditingController.text = _newsletter.name;
    _urlTextEditingController.text = _newsletter.url;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (c) => new NewsletterEditState(_newsletter, kiwi.Container().resolve()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Newsletter bearbeiten"),
          actions: <Widget>[
            Consumer(
              builder: (BuildContext context, NewsletterEditState value, Widget child) => IconButton(
                icon: Icon(Icons.check),
                onPressed: () => okButtonClick(context, value),
              ),
            ),
            Consumer(
              builder: (BuildContext context, NewsletterEditState value, Widget child) => IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () => deleteButtonClick(context, value),
              ),
            ),
          ],
        ),
        body: buildPageContent(),
      ),
    );
  }

  Widget buildPageContent() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 150,
            color: Colors.green,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Consumer(
                  builder: (BuildContext context, NewsletterEditState state, _) => TextField(
                    decoration: InputDecoration(
                      hintText: "Name",
                      errorText: state?.nameError,
                      alignLabelWithHint: true,
                    ),
                    controller: _nameTextEditingController,
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                Consumer(
                  builder: (BuildContext context, NewsletterEditState state, _) => InputDecorator(
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
                      icon: Icon(Icons.add_shopping_cart),
                      labelText: "Update Strategie",
                      helperText: "Gibt an, wie nach neuen Ausgaben gesucht werden soll",
                      errorText: state.updateStrategyError,
                    ),
                  ),
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
                        helperText: "Die Url, wo nach neuen Ausgaben gesucht werden soll",
                        errorText: state.urlError,
                        alignLabelWithHint: true,
                      ),
                      controller: _urlTextEditingController,
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
                        builder: (BuildContext context, NewsletterEditState state, _) => Checkbox(
                          onChanged: (isChecked) {
                            state.autoDownloadEnabled = isChecked;
                          },
                          value: state.newsletter.isAutoDownloadEnabled ?? false,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                  child: Row(
                    children: <Widget>[
                      Consumer(
                        builder: (BuildContext context, NewsletterEditState state, _) => Checkbox(
                          onChanged: (isChecked) {
                            state.autoUpdateEnabled = isChecked;
                          },
                          value: state.newsletter.isAutoUpdateEnabled ?? false,
                        ),
                      ),
                      Text(
                        "Automatisch nach neuen Beiträgen suchen",
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                ),
                Consumer(
                  builder: (BuildContext context, NewsletterEditState state, _) => AnimatedSwitcher(
                    child: state.newsletter.isAutoUpdateEnabled ?? false
                        ? Consumer(
                            builder: (BuildContext context, NewsletterEditState state, _) => InputDecorator(
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
                                helperText: "Das Interval, mit dem neue Ausgaben gesucht werden",
                                errorText: state.updateIntervalError,
                              ),
                            ),
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
        ],
      ),
    );
  }

  List<DropdownMenuItem<UpdateInterval>> getUpdateIntervalMenuItems() {
    return UpdateInterval.values
        .map((code) => new DropdownMenuItem(value: code, child: new Text(code.toString().split('.').last)))
        .toList();
  }

  List<DropdownMenuItem> getUpdateStrategyMenuItems() {
    return UpdateStrategy.values
        .map((code) => new DropdownMenuItem(value: code, child: new Text(code.toString().split('.').last)))
        .toList();
  }

  Future okButtonClick(BuildContext context, NewsletterEditState state) async {
    state.newsletter.name = _nameTextEditingController.text;
    state.newsletter.url = _urlTextEditingController.text;

    state.validate();

    if (!state.hasError) {
      await state.save();
      Navigator.of(context).pop();
    }
  }

  Future deleteButtonClick(BuildContext context, NewsletterEditState state) async {
    state.newsletter.name = _nameTextEditingController.text;
    state.newsletter.url = _urlTextEditingController.text;

    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("${state.newsletter.name} löschen"),
              content: Text("Der Newsletter ${state.newsletter.name} wird endgültig gelöscht."),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Abbrechen".toUpperCase()),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("Löschen".toUpperCase()),
                  onPressed: () async {
                    await state.delete();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}

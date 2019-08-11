import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/model/model.dart';
import 'package:newsletter_reader/ui/newsletter_edit/state/newsletter_edit_state.dart';
import 'package:newsletter_reader/ui/utils/dialog_utils.dart';
import 'package:provider/provider.dart';

import 'newsletter_edit.dart';

class NewsletterEditPage extends StatefulWidget {
  final Newsletter newsletter;

  NewsletterEditPage(this.newsletter);

  @override
  State<StatefulWidget> createState() => _NewsletterEditPageState(newsletter);
}

class _NewsletterEditPageState extends State<NewsletterEditPage> {
  final Newsletter _newsletter;

  _NewsletterEditPageState(this._newsletter);

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
        body: Stack(
      children: <Widget>[
      SizedBox(
        height: 150,
        child: Container(
          color: Theme.of(context).primaryColor,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
        child: Card(
          margin: const EdgeInsets.fromLTRB(2, 2, 2, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          elevation: 16,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: NewsletterEdit(newsletter: _newsletter,),
              ),
            ],
          ),
        ),
      ),
      ],
    ),
      ),
    );
  }


  Future okButtonClick(BuildContext context, NewsletterEditState state) async {
    state.validate();

    if (!state.hasError) {
      await state.save();
      Navigator.of(context).pop();
    }
  }

  Future deleteButtonClick(BuildContext context, NewsletterEditState state) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => createAlertDialog(
        context,
        "${state.newsletter.name} löschen",
        "Der Newsletter ${state.newsletter.name} wird endgültig gelöscht.",
        okAction: () async {
          await state.delete();
          Navigator.of(context).pop();
        },
        cancelAction: () {},
        okText: "Löschen",
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:newsletter_reader/model/model.dart';
import 'package:newsletter_reader/ui/newsletter_edit/state/newsletter_edit_view_model.dart';
import 'package:newsletter_reader/ui/utils/dialog_utils.dart';
import 'package:newsletter_reader/ui/view_models/view_models.dart';
import 'package:provider/provider.dart';

import 'newsletter_edit_content.dart';

class NewsletterEditPage extends StatelessWidget {
  final NewsletterViewModel newsletter;

  NewsletterEditPage(this.newsletter);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (c) => new NewsletterEditViewModel(newsletter, kiwi.Container().resolve()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Newsletter bearbeiten"),
          actions: <Widget>[
            Consumer(
              builder: (BuildContext context, NewsletterEditViewModel value, Widget child) => IconButton(
                icon: Icon(Icons.check),
                onPressed: () => okButtonClick(context, value),
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
                child: NewsletterEditContent(newsletter: newsletter,),
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


  Future okButtonClick(BuildContext context, NewsletterEditViewModel state) async {
    state.validate();

    if (!state.hasError) {
      await state.save();
      Navigator.of(context).pop();
    }
  }
}

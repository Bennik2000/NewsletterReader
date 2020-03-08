import 'package:flutter/material.dart';
import 'package:newsletter_reader/model/model.dart';
import 'package:newsletter_reader/ui/i18n/localizations.dart';
import 'package:newsletter_reader/ui/style/text_style.dart';
import 'package:newsletter_reader/ui/view_models/view_models.dart';
import 'package:provider/provider.dart';

import 'state/newsletter_edit_view_model.dart';

class NewsletterEditContent extends StatefulWidget {
  final NewsletterViewModel newsletter;

  const NewsletterEditContent({Key key, this.newsletter}) : super(key: key);

  @override
  _NewsletterEditContentState createState() =>
      _NewsletterEditContentState(newsletter);
}

class _NewsletterEditContentState extends State<NewsletterEditContent> {
  final TextEditingController _nameTextEditingController =
      new TextEditingController();
  final TextEditingController _urlTextEditingController =
      new TextEditingController();

  final NewsletterViewModel _newsletter;

  _NewsletterEditContentState(this._newsletter) {
    _nameTextEditingController.text = _newsletter.newsletter.name;
    _urlTextEditingController.text = _newsletter.newsletter.url;
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
              builder:
                  (BuildContext context, NewsletterEditViewModel state, _) =>
                      TextField(
                decoration: InputDecoration(
                  hintText: L.of(context).editNewsletterNameHint,
                  errorText: state?.nameError,
                  alignLabelWithHint: true,
                ),
                controller: _nameTextEditingController,
                onChanged: (String value) {
                  state.name = value;
                },
                style: TextStyles(context).textFieldBig(),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Padding(
              child: Consumer(
                builder:
                    (BuildContext context, NewsletterEditViewModel state, _) =>
                        InputDecorator(
                  child: DropdownButton(
                    isExpanded: true,
                    items: getUpdateStrategyMenuItems(context),
                    onChanged: (value) {
                      state.updateStrategy = value;
                    },
                    value: state.updateStrategy,
                    underline: Container(),
                    isDense: true,
                  ),
                  decoration: InputDecoration(
                    labelText: L.of(context).editNewsletterUpdateStrategyLabel,
                    helperText:
                        L.of(context).editNewsletterUpdateStrategyHelper,
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
              builder:
                  (BuildContext context, NewsletterEditViewModel state, _) {
                return TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.insert_link),
                    labelText: L.of(context).editNewsletterUrlLabel,
                    helperText: L.of(context).editNewsletterUrlHelper,
                    errorText: state.urlError,
                    alignLabelWithHint: true,
                  ),
                  controller: _urlTextEditingController,
                  onChanged: (String value) {
                    state.url = value;
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
                    builder: (BuildContext context,
                            NewsletterEditViewModel state, _) =>
                        Checkbox(
                      onChanged: (isChecked) {
                        state.autoUpdateEnabled = isChecked;
                      },
                      value: state.autoUpdateEnabled ?? false,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      L.of(context).editNewsletterAutoUpdateArticles,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
            ),
            Consumer(
              builder:
                  (BuildContext context, NewsletterEditViewModel state, _) =>
                      AnimatedSwitcher(
                child: state.autoUpdateEnabled ?? false
                    ? Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 0, 0),
                            child: Row(
                              children: <Widget>[
                                Consumer(
                                  builder: (BuildContext context,
                                          NewsletterEditViewModel state, _) =>
                                      Checkbox(
                                    onChanged: (isChecked) {
                                      state.autoDownloadEnabled = isChecked;
                                    },
                                    value: state.autoDownloadEnabled ?? false,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    L
                                        .of(context)
                                        .editNewsletterAutoDownloadArticles,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Consumer(
                            builder: (BuildContext context,
                                    NewsletterEditViewModel state, _) =>
                                InputDecorator(
                              child: DropdownButton(
                                isExpanded: true,
                                items: getUpdateIntervalMenuItems(context),
                                onChanged: (value) {
                                  state.updateInterval = value;
                                },
                                value: state.updateInterval,
                                underline: Container(),
                                isDense: true,
                              ),
                              decoration: InputDecoration(
                                icon: Icon(Icons.watch_later),
                                labelText: L
                                    .of(context)
                                    .editNewsletterUpdateIntervalLabel,
                                helperText: L
                                    .of(context)
                                    .editNewsletterUpdateIntervalHelper,
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

  List<DropdownMenuItem<UpdateInterval>> getUpdateIntervalMenuItems(
      BuildContext context) {
    return UpdateInterval.values
        .map((code) => new DropdownMenuItem(
            value: code,
            child: new Text(L.of(context).getValue(code.toString()))))
        .toList();
  }

  List<DropdownMenuItem> getUpdateStrategyMenuItems(BuildContext context) {
    return UpdateStrategy.values
        .map((code) => new DropdownMenuItem(
            value: code,
            child: new Text(L.of(context).getValue(code.toString()))))
        .toList();
  }
}

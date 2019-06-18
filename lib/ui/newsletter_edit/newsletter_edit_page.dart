import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsletter_reader/data/model/model.dart';
import 'package:newsletter_reader/ui/newsletter_edit/newsletter_edit_bloc.dart';
import 'package:newsletter_reader/ui/newsletter_edit/newsletter_edit_event.dart';
import 'package:newsletter_reader/ui/newsletter_edit/newsletter_edit_state.dart';

class NewsletterEditPage extends StatefulWidget {
  final Newsletter newsletter;

  NewsletterEditPage(this.newsletter);

  @override
  State<StatefulWidget> createState() => _NewsletterEditPageState(newsletter);
}

class _NewsletterEditPageState extends State<NewsletterEditPage> {
  NewsletterEditBloc _newsletterEditBloc;

  final TextEditingController _nameTextEditingController = new TextEditingController();
  final TextEditingController _urlTextEditingController = new TextEditingController();

  _NewsletterEditPageState(Newsletter newsletter) {
    _newsletterEditBloc = new NewsletterEditBloc(newsletter);

    _nameTextEditingController.text = newsletter.name;
    _urlTextEditingController.text = newsletter.url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Newsletter bearbeiten"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _newsletterEditBloc
                  .dispatch(new FinishEditNewsletterEvent(_nameTextEditingController.text, _urlTextEditingController.text));
            },
          )
        ],
      ),
      body: BlocListener(
        bloc: _newsletterEditBloc,
        listener: (BuildContext context, NewsletterEditState state) {
          handleStateChange(state, context);
        },
        child: BlocBuilder(
          bloc: _newsletterEditBloc,
          builder: (BuildContext context, NewsletterEditState state) {
            return buildPageContent(state);
          },
        ),
      ),
    );
  }

  void handleStateChange(NewsletterEditState state, BuildContext context) {
    if (state is NewsletterEditFinishedState) {
      Navigator.of(context).pop();
    }
  }

  Widget buildPageContent(NewsletterEditState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.import_contacts),
                border: OutlineInputBorder(),
                labelText: "Name",
                errorText: state.errorState?.nameError?.isEmpty ?? true ? null : state.errorState?.nameError,
              ),
              controller: _nameTextEditingController,
            ),
            SizedBox(
              height: 32,
            ),
            InputDecorator(
              child: DropdownButton(
                isExpanded: true,
                items: getUpdateStrategyMenuItems(),
                onChanged: (value) {
                  _newsletterEditBloc.dispatch(new ChangeUpdateStrategyEvent(value));
                },
                value: state.newsletter.updateStrategy,
              ),
              decoration: InputDecoration(
                icon: Icon(Icons.all_out),
                border: OutlineInputBorder(),
                labelText: "Update Strategie",
                helperText: "Gibt an, wie nach neuen Ausgaben gesucht werden soll",
                errorText: state.errorState.updateStrategyError,
              ),
            ),
            SizedBox(
              height: 32,
            ),
            TextField(
              decoration: InputDecoration(
                icon: Icon(null),
                border: OutlineInputBorder(),
                labelText: "Url",
                helperText: "Die Url, wo nach neuen Ausgaben gesucht werden soll",
                errorText: state.errorState?.urlError?.isEmpty ?? true ? null : state.errorState?.urlError,
              ),
              controller: _urlTextEditingController,
            ),
            SizedBox(
              height: 32,
            ),
            InputDecorator(
              child: DropdownButton(
                isExpanded: true,
                items: getUpdateIntervalMenuItems(),
                onChanged: (value) {
                  _newsletterEditBloc.dispatch(new ChangeUpdateIntervalEvent(value));
                },
                value: state.newsletter.updateInterval,
              ),
              decoration: InputDecoration(
                  icon: Icon(null),
                  border: OutlineInputBorder(),
                  labelText: "Update Interval",
                  helperText: "Das Interval, mit dem neue Ausgaben gesucht werden",
                  errorText: state.errorState.updateIntervalError),
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
        .map((code) => new DropdownMenuItem(value: code, child: new Text(code.toString().split('.').last)))
        .toList();
  }

  List<DropdownMenuItem> getUpdateStrategyMenuItems() {
    return UpdateStrategy.values
        .map((code) => new DropdownMenuItem(value: code, child: new Text(code.toString().split('.').last)))
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
    _newsletterEditBloc.dispose();
  }

  Widget buildPatternUrlPart(NewsletterEditState state) {}
}

import 'package:flutter/material.dart';
import 'package:newsletter_reader/ui/i18n/localizations.dart';

Widget createAlertDialog(
  BuildContext context,
  String title, {
  String message,
  Function okAction,
  Function cancelAction,
  String okText: "",
  String cancelText: "",
}) {
  if (okText == "") {
    okText = L.of(context).buttonOk;
  }
  if (cancelText == "") {
    cancelText = L.of(context).buttonCancel;
  }

  var buttons = <Widget>[];

  if (okAction != null) {
    buttons.add(new FlatButton(
      child: new Text(okText.toUpperCase()),
      onPressed: () {
        Navigator.of(context).pop();
        okAction();
      },
    ));
  }
  if (cancelAction != null) {
    buttons.add(new FlatButton(
      child: new Text(cancelText.toUpperCase()),
      onPressed: () {
        Navigator.of(context).pop();
        cancelAction();
      },
    ));
  }

  if ((message == null) && title != null) {
    message = title;
    title = null;
  }

  return AlertDialog(
    title: title != null ? new Text(title) : null,
    content: message != null ? new Text(message) : null,
    actions: buttons,
  );
}

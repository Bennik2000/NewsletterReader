import 'package:flutter/material.dart';

Widget createAlertDialog(
  BuildContext context,
  String title,
  String message, {
  Function okAction,
  Function cancelAction,
  String okText: "OK",
  String cancelText: "Cancel",
}) {
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

  return AlertDialog(
    title: new Text(title),
    content: new Text(message),
    actions: buttons,
  );
}

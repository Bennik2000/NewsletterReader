import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextStyles {
  final BuildContext context;

  TextStyle cardTitle() => TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w300,
        color: Theme.of(context).textTheme.title.color,
      );

  TextStyles(this.context);

  TextStyle textFieldBig() => TextStyle(fontSize: 30);
  TextStyle textError() => TextStyle(color: Theme.of(context).errorColor);

  TextStyle titleBarFlatButton() => TextStyle(
        color: Theme.of(context).primaryTextTheme.button.color,
      );

  TextStyle pageTitle() => TextStyle(
        fontSize: 35,
        color: Theme.of(context).primaryTextTheme.title.color,
      );
}

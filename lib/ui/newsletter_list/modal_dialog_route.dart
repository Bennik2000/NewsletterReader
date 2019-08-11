
import 'package:flutter/material.dart';

class ModalDialogRoute extends ModalRoute<void> {

  final Widget content;

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => null;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => null;

  @override
  bool get opaque => null;

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  ModalDialogRoute({this.content});


  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return content;
  }

}
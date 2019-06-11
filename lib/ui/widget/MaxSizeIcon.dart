import 'package:flutter/material.dart';

class MaxSizeIcon extends StatelessWidget {
  final IconData icon;

  const MaxSizeIcon(this.icon) : super();

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(builder: (context, constraint) {
      return Icon(
        icon,
        size: constraint.biggest.height,
      );
    });
  }
}

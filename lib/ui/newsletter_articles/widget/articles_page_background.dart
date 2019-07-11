import 'package:flutter/material.dart';

class ArticlesPageBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
          child: Container(
            color: Colors.green,
          ),
          flex: 1,
        ),
        Flexible(
          child: Container(),
          flex: 4,
        )
      ],
    );
  }
}

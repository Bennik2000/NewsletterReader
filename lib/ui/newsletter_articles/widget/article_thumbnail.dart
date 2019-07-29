import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArticleThumbnail extends StatelessWidget {
  final double borderRadius;
  final String thumbnailPath;

  const ArticleThumbnail({Key key, this.borderRadius, this.thumbnailPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: borderRadius,
          bottom: borderRadius,
          left: 0,
          right: 0,
          child: Container(
            child: Ink.image(
              image: FileImage(File.fromUri(Uri.file(thumbnailPath))),
              child: Container(),
            ),
          ),
        ),
        Positioned(
          top: borderRadius,
          bottom: borderRadius,
          left: 0,
          right: 0,
          child: Ink(
            child: Container(),
            decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.white,
                ],
                stops: [0.0, 0.75],
              ),
            ),
          ),
        )
      ],
    );
  }
}

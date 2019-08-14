import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class ArticlePlaceholder extends StatelessWidget {
  final int iconId;

  const ArticlePlaceholder(this.iconId);

  @override
  Widget build(BuildContext context) {
    return FlareActor(
      "assets/flare/article_placeholder_$iconId.flr",
      alignment: Alignment.center,
      fit: BoxFit.contain,
    );
  }
}

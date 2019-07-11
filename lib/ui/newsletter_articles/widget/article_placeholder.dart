import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class ArticlePlaceholder extends StatelessWidget {
  final int icon_id;

  const ArticlePlaceholder(this.icon_id);

  @override
  Widget build(BuildContext context) {
    return FlareActor(
      "assets/flare/article_placeholder_$icon_id.flr",
      alignment: Alignment.center,
      fit: BoxFit.contain,
    );
  }
}

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class NoArticlesEmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 54, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 70,
            height: 70,
            child: FlareActor(
              "assets/flare/steaming_tea.flr",
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: "Untitled",
              //controller: LoopController(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 0, 0),
            child: Center(
              child: Text("Es sind noch keine Ausgaben verfügbar"),
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class MasterDetailNothingSelected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SizedBox(
          width: 250,
          height: 250,
          child: FlareActor(
            "assets/flare/empty_state.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            color: Theme.of(context).dividerColor,
            //controller: LoopController(),
          ),
        ),
      ),
    );
  }
}
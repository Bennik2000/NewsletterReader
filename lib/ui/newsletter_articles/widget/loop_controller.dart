import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare/math/mat2d.dart';
import 'package:flare_flutter/flare_actor.dart';

class LoopController extends FlareController {
  double _animationTime = 0;
  ActorAnimation _loop;

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    _animationTime += elapsed;
    _loop.apply(_animationTime % _loop.duration, artboard, 1.0);
    return true;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    _loop = artboard.getAnimation("Untitled");
  }

  @override
  void setViewTransform(Mat2D viewTransform) {
    // TODO: implement setViewTransform
  }
}

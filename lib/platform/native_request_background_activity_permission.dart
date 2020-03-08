import 'package:flutter/services.dart';

class NativeRequestBackgroundActivityPermission {
  final MethodChannel _platform;

  NativeRequestBackgroundActivityPermission()
      : _platform = new MethodChannel(
            "native/NativeRequestBackgroundActivityPermission");

  Future requestBackgroundActivity() async {
    try {
      await _platform.invokeMethod('requestBackgroundActivity');
    } catch (e) {
      print(e);
    }
  }
}

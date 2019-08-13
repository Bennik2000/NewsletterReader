import 'package:flutter/widgets.dart';

bool isTablet(BuildContext context) {
  var size = MediaQuery.of(context).size.shortestSide;
  return size > 600;
}

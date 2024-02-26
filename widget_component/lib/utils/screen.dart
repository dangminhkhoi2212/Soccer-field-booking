import 'package:flutter/material.dart';

class ScreenUtil {
  static double getWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double getHeigth(BuildContext context) =>
      MediaQuery.of(context).size.height;
}

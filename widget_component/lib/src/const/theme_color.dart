import 'package:flutter/material.dart';

class PrimaryColor {
  static const MaterialColor primary =
      MaterialColor(_primaryPrimaryValue, <int, Color>{
    50: Color(0xFFF9FEF8),
    100: Color(0xFFF0FBED),
    200: Color(0xFFE6F9E2),
    300: Color(0xFFDCF7D6),
    400: Color(0xFFD5F5CD),
    500: Color(_primaryPrimaryValue),
    600: Color(0xFFC8F1BE),
    700: Color(0xFFC1EFB6),
    800: Color(0xFFBAEDAF),
    900: Color(0xFFAEEAA2),
  });
  static const int _primaryPrimaryValue = 0xFFCDF3C4;

  static const MaterialColor primaryAccent =
      MaterialColor(_primaryAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_primaryAccentValue),
    400: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
  });
  static const int _primaryAccentValue = 0xFFFFFFFF;
}

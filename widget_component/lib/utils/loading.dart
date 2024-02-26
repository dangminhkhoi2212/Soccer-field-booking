import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:widget_component/const/colors.dart';

class MyLoading {
  static spinkit({double size = 45.0}) => SpinKitWaveSpinner(
        color: Colors.white,
        size: size,
        curve: Easing.emphasizedAccelerate,
        waveColor: MyColor.third,
        duration: const Duration(milliseconds: 3000),
      );
}

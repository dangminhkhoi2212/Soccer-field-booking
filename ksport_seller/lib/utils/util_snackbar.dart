import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksport_seller/const/colors.dart';

class SnackbarUtil {
  static SnackbarController getSnackBar(
          {required String title, required String message}) =>
      Get.snackbar(title, message,
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
          backgroundColor: MyColor.primary,
          // overlayBlur: 5,
          barBlur: 15,
          margin: const EdgeInsets.only(top: 10, right: 10, left: 10));
}

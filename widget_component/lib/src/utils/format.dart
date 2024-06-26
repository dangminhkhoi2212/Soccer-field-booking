import 'package:flutter/material.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:intl/intl.dart';

class FormatUtil {
  static NumberTextInputFormatter numberFormatter() {
    return NumberTextInputFormatter(
      integerDigits: 10,
      decimalDigits: 0,
      maxValue: '1000000000.00',
      decimalSeparator: '.',
      groupDigits: 3,
      groupSeparator: ',',
      allowNegative: false,
      overrideDecimalPoint: true,
      insertDecimalPoint: false,
      insertDecimalDigits: true,
    );
  }

  static formatNumber(num n) {
    NumberFormat formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 0,
    );
    return formatter.format(n);
  }

  static String formatDate(DateTime date) {
    final format = DateFormat('dd-MM-yyyy');
    return format.format(date);
  }

  static String formatTime(DateTime time) {
    final format = DateFormat('HH:mm');
    return format.format(time);
  }

  static String formatISOtoDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);

    return formattedDate;
  }

  static String formatISOtoTime(String timeString) {
    DateTime dateTime = DateTime.parse(timeString);
    String formattedTime = DateFormat('HH:mm').format(dateTime);

    return formattedTime;
  }
}

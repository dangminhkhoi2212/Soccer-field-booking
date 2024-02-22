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
      decimalDigits: 2,
    );
    return formatter.format(n);
  }
}

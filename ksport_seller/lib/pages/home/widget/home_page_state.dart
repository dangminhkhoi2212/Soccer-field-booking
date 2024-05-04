import 'package:get/get.dart';
import 'package:widget_component/my_library.dart';

class HomeController extends GetxController {
  final RxString year = DateTime.now().year.toString().obs;
  final RxString month = ''.obs;
  final RxString date = ''.obs;
  void changeYear(String year) {
    this.year.value = year;
    month.value = '';
    date.value = '';
  }

  void changeMonth(String month) {
    year.value = '';
    this.month.value = month;
    date.value = '';
  }

  void changeDate(String date) {
    year.value = '';
    month.value = '';
    this.date.value = date;
  }
}

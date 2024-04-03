import 'package:get/get.dart';

class MainScreenState extends GetxController {
  final RxInt indexPage = 99.obs;
  final int initValue = 99;
  void changeIndexPage(int index) {
    indexPage.value = index;
  }

  void resetValue() {
    indexPage.value = initValue;
  }
}

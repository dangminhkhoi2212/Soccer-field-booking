import 'package:get/get.dart';

class SellerListState extends GetxController {
  RxString textSearch = ''.obs;

  void changeText(String text) {
    textSearch.value = text;
  }
}

import 'package:get/get.dart';

class StoreUser extends GetxController {
  final _name = ''.obs;
  final _isLogin = false.obs;
  final _avatar = ''.obs;
  final _email = ''.obs;
  final _phone = ''.obs;
  final _isPublic = true.obs;
  final RxString _accessToken = ''.obs;
  final RxString _refreshToken = ''.obs;

  get name => _name.value;
  get isLogin => _isLogin.value;
  get avatar => _avatar.value;
  get email => _email.value;
  get isPublic => _isPublic.value;
  get phone => _phone.value;
  get accessToken => _accessToken.value;
  get refreshToken => _refreshToken.value;

  void setUser({
    required String name,
    required String email,
    required String avatar,
    required bool isPublic,
    required String accessToken,
    required String refreshToken,
    String? phone,
  }) {
    print('IN STORE: ${name.runtimeType}');
    _name.value = name;
    _email.value = email;
    _avatar.value = avatar;
    _phone.value = phone ?? '';
    _isPublic.value = isPublic;
    _accessToken.value = accessToken;
    _refreshToken.value = refreshToken;
  }

  void setIsLogin(bool isLogin) {
    print('IS LOGIN: $isLogin');
    _isLogin.value = isLogin;
  }
}

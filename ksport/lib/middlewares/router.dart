// import 'package:client_app/routes/route_path.dart';
import 'package:widget_component/my_library.dart';
import 'package:client_app/store/store_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RouterMiddleware extends GetMiddleware {
  final StoreUser storeUser = Get.put(StoreUser());
  final _box = GetStorage();
  @override
  RouteSettings? redirect(String? route) {
    // Map<String, dynamic> temp = _box.read('user') ?? {};
    // StorageUser storageUser = StorageUser();
    // String accessToken = storageUser.getAccessTokenLocal();
    // String refreshToken = storageUser.getRefreshTokenLocal();
    if (route == RoutePaths.signUp) {
      return null;
    }
    String? accessToken = _box.read('accessToken');
    String? refreshToken = _box.read('refreshToken');
    print('ACCESSTOKEN: $accessToken');
    print('REFRESHTOKEN: $refreshToken');
    if (accessToken == null || refreshToken == null) {
      if (route != RoutePaths.signIn) {
        return RouteSettings(name: RoutePaths.signIn);
      }
    }
    return null;
  }
}

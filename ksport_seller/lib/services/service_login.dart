import 'package:flutter/material.dart';
import 'package:ksport_seller/config/api_config.dart';
import 'package:ksport_seller/storage/storage_user.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:widget_component/my_library.dart';

class LoginService {
  final Dio _dio;
  final _box = GetStorage();
  final StorageUser _storageUser = StorageUser();
  final GoogleMapService _googleMapService = GoogleMapService();
  late AddressService _addressService;
  factory LoginService(Dio dio) {
    final instance = LoginService._internal(dio);
    instance._addressService = AddressService(dio);
    return instance;
  }
  LoginService._internal(this._dio);
  Future<void> login(
      {required String? accessToken,
      required String? name,
      required String? imageUrl}) async {
    try {
      debugPrint(accessToken);
      debugPrint(name);
      debugPrint(imageUrl);
      if (accessToken == null) {
        throw 'accessToken not found';
      }

      final response = await _dio.post(
        ApiConfig.authApiUrl,
        data: {'accessToken': accessToken, 'name': name, 'imageUrl': imageUrl},
        options: Options(
          contentType: 'application/json',
          validateStatus: (_) => true,
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        debugPrint(data.toString());
        final UserModel user = UserModel.fromJson(data);

        _storageUser.setTokenLocal(
            accessToken: user.accessToken ?? '',
            refreshToken: user.refreshToken ?? '');

        _storageUser.setUser(user: user.toJson());

        // update address
        if (data['isUpdatedAddress'] == false) {
          Position? position = await _googleMapService.determinePosition();
          if (position != null && user.sId != null) {
            await _addressService.updateAddress(
                userID: user.sId ?? '',
                lat: position.latitude,
                long: position.longitude);
          }
        }
        // update address
        await Get.offNamed(RoutePaths.mainScreen);
      } else {
        debugPrint('Error - Status Code: ${response.statusCode}');
        debugPrint('Error Response: ${response.data}');
        return;
      }
    } on DioException catch (e) {
      debugPrint('ERROR LOGIN: $e');
      if (e.type == DioExceptionType.connectionTimeout) {
        debugPrint('Connected timeout: login');
      } else if (e.type == DioExceptionType.connectionError) {
        debugPrint('Connected error: login');
      }
      return;
    }
  }
}

import 'package:client_app/config/api_config.dart';
import 'package:client_app/storage/storage_user.dart';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:widget_component/my_library.dart';

class LoginService {
  final Dio _dio = ApiConfig().dio;
  final _box = GetStorage();
  final StorageUser _storageUser = StorageUser();
  final GoogleMapService _googleMapService = GoogleMapService();
  final AddressService _addressService = AddressService(ApiConfig().dio);

  Future<void> login(
      {required String? accessToken,
      required String? name,
      required String? imageUrl}) async {
    try {
      print(accessToken);
      print(name);
      print(imageUrl);
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
        print(data);
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
        print('Error - Status Code: ${response.statusCode}');
        print('Error Response: ${response.data}');
        return;
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        print('Connected timeout: login');
      } else if (e.type == DioExceptionType.connectionError) {
        print('Connected error: login');
      }
      return;
    }
  }
}

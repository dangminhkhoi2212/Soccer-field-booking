import 'package:client_app/config/api_config.dart';
import 'package:client_app/utils/util_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class AddressService {
  final Dio _dio = Dio(ApiConfig.options);
  final GetStorage _box = GetStorage();
  Future? updateAddress(
      {required String userID,
      double? lat,
      double? long,
      String? district,
      String? province,
      String? ward}) async {
    try {
      final response = await _dio.put(ApiConfig.addressApiUrl, data: {
        'userID': userID,
        'latitude': lat,
        'longitude': long,
        'district': district,
        'province': province,
        'ward': ward,
      });
      if (response.statusCode == 200) {
        SnackbarUtil.getSnackBar(
            title: 'Update address.', message: 'Updated address successfully.');
        return response.data;
      } else {
        SnackbarUtil.getSnackBar(
            title: 'Update address.', message: 'Address update failed.');
        return null;
      }
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print('ERROR: ${e.response!.data}');
        print('ERROR: ${e.response!.headers}');
        print('ERROR: ${e.response!.requestOptions}');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print('ERROR: ${e.requestOptions}');
        print('ERROR: ${e.message}');
      }
      return {'Error': e.message ?? ''};
    }
  }

  Future? getAddress({required String userID}) async {
    try {
      String? userID = _box.read('id');
      if (userID == null) return 'userId not found';

      final Response response = await _dio
          .get(ApiConfig.addressApiUrl, queryParameters: {'userID': userID});
      return response.data;
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print('ERROR: ${e.response!.data}');
        print('ERROR: ${e.response!.headers}');
        print('ERROR: ${e.response!.requestOptions}');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print('ERROR: ${e.requestOptions}');
        print('ERROR: ${e.message}');
      }
      return {'Error': e.message ?? ''};
    }
  }
}

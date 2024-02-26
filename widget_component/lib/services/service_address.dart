import 'package:widget_component/config/api_config.dart';
import 'package:dio/dio.dart';

class AddressService {
  final Dio _dio = Dio(ApiConfig.options);
  Future<Response?> updateAddress(
      {required String userID,
      double? lat,
      double? long,
      String? address}) async {
    try {
      final response = await _dio.put(ApiConfig.addressApiUrl, data: {
        'userID': userID,
        'latitude': lat,
        'longitude': long,
        'address': address
      });
      return response;
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
    }
    return null;
  }

  Future<Response?> getAddress({String? userID}) async {
    try {
      final Response response = await _dio
          .get(ApiConfig.addressApiUrl, queryParameters: {'userID': userID});
      return response;
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
    }
    return null;
  }
}

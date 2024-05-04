import 'package:dio/dio.dart';

class AddressService {
  final Dio _dio;

  factory AddressService(Dio dio) {
    final instance = AddressService._internal(dio);
    return instance;
  }
  AddressService._internal(this._dio);
  Future<Response> updateAddress(
      {required String userID,
      double? lat,
      double? long,
      String? address}) async {
    final response = await _dio.put('/address', data: {
      'userID': userID,
      'latitude': lat,
      'longitude': long,
      'address': address
    });
    return response;
  }

  Future<Response> getAddress() async {
    final Response response =
        await _dio.get('/address/all', queryParameters: {});
    return response;
  }

  Future<Response> getOneAddress({required String userID}) async {
    final Response response = await _dio.get('/address', queryParameters: {
      'userID': userID,
    });
    return response;
  }
}

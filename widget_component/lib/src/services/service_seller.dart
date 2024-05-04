import 'package:dio/dio.dart';

class SellerService {
  final Dio _dio;
  factory SellerService(Dio dio) {
    final instance = SellerService._internal(dio);
    return instance;
  }
  SellerService._internal(this._dio);

  Future<Response> getSeller(
      {String? sellerID, String? userID, bool? isInfo = false}) async {
    final Response response = await _dio.get('/seller/all', queryParameters: {
      "sellerID": sellerID,
      'userID': userID,
      'isInfo': isInfo
    });
    return response;
  }

  Future<Response> getOneSeller({String? userID, bool? isInfo = false}) async {
    final Response response = await _dio
        .get('/seller', queryParameters: {'userID': userID, 'isInfo': isInfo});
    return response;
  }

  Future<Response> updateSeller(
      {required String userID,
      required String startTime,
      required String endTime,
      required bool isHalfHour}) async {
    final Response response = await _dio.post('/seller', data: {
      'userID': userID,
      'startTime': startTime,
      'endTime': endTime,
      'isHalfHour': isHalfHour
    });
    return response;
  }
}

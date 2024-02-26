import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:widget_component/config/api_config.dart';

class SellerService {
  final _dio = Dio(ApiConfig.options);
  Future<Response?> getSeller(
      {String? sellerID, String? userID, bool? isInfo = false}) async {
    try {
      final Response response = await _dio.get(ApiConfig.sellerUrl,
          queryParameters: {
            "sellerID": sellerID,
            'userID': userID,
            'isInfo': isInfo
          });
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint(e.response!.data.toString());
        debugPrint(e.response!.headers.toString());
        debugPrint(e.response!.requestOptions.toString());
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message.toString());
      }
    }
    return null;
  }

  Future<Response?> updateSeller(
      {required String userID,
      required String startTime,
      required String endTime,
      required bool isHalfHour}) async {
    try {
      final Response response = await _dio.post(ApiConfig.sellerUrl, data: {
        'userID': userID,
        'startTime': startTime,
        'endTime': endTime,
        'isHalfHour': isHalfHour
      });
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint(e.response!.data.toString());
        debugPrint(e.response!.headers.toString());
        debugPrint(e.response!.requestOptions.toString());
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message.toString());
      }
    }
    return null;
  }
}

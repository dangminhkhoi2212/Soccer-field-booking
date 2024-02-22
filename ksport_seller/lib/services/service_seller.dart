import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ksport_seller/config/api_config.dart';

class SellerService {
  final _dio = Dio(ApiConfig.options);
  Future<Response?> getSeller({required String userID}) async {
    try {
      final Response response = await _dio
          .get(ApiConfig.sellerUrl, queryParameters: {"userID": userID});
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
      required endTime}) async {
    try {
      final Response response = await _dio.post(ApiConfig.sellerUrl,
          data: {'userID': userID, 'startTime': startTime, 'endTime': endTime});
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

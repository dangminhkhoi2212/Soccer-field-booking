import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:widget_component/my_library.dart';

class OrderService {
  final _dio = Dio(ApiConfig.options);

  Future<Response?> createOrder(
      {required String userID,
      required String sellerID,
      required String fieldID,
      required String startTime,
      required String endTime,
      required String date,
      required double total}) async {
    try {
      Response response = await _dio.post(ApiConfig.orderUrl, data: {
        'userID': userID,
        'sellerID': sellerID,
        'fieldID': fieldID,
        'startTime': startTime,
        'endTime': endTime,
        'date': date,
        'total': total
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

  Future<Response?> updateOrder(
      {required String orderID, required String status}) async {
    try {
      Response response = await _dio.put(ApiConfig.orderUrl,
          data: {'orderID': orderID, 'status': status});
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

  Future<Response?> getAllOrder({
    String? userID,
    String? sellerID,
    String? status,
    String? date,
    String? sortBy,
  }) async {
    try {
      Response response =
          await _dio.get('${ApiConfig.orderUrl}/all', queryParameters: {
        'sellerID': sellerID,
        'userID': userID,
        'status': status,
        'date': date,
        'sortBy': sortBy,
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

  Future<Response?> getOneOrder({required String orderID}) async {
    try {
      Response response = await _dio.get(ApiConfig.orderUrl, queryParameters: {
        'orderID': orderID,
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

  Future<Response?> getOrderedTime(
      {required String fieldID, required String date}) async {
    try {
      Response response = await _dio.get('${ApiConfig.orderUrl}/time',
          queryParameters: {'fieldID': fieldID, 'date': date});
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

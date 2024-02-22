import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ksport_seller/config/api_config.dart';

class FieldService {
  final Dio _dio = Dio(ApiConfig.options);

  Future<dynamic> addSoccerField(
      {required String userID,
      String? fieldID,
      required num price,
      required num width,
      required num length,
      required num type,
      required String name,
      required bool isLock,
      required bool isRepair,
      required String description,
      required String coverImage}) async {
    try {
      final Response response = await _dio.post(ApiConfig.fieldUrl, data: {
        'userID': userID,
        'fieldID': fieldID,
        'price': price,
        'width': width,
        'length': length,
        'type': type,
        'name': name,
        'isLock': isLock,
        'isRepair': isRepair,
        'description': description,
        'coverImage': coverImage,
      });
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      print('ERROR ADD FIELD: $e');
      return null;
    }
  }

  Future<Response?> getSoccerField({String? userID, String? fieldID}) async {
    try {
      final Response response = await _dio.get(ApiConfig.fieldUrl,
          queryParameters: {"userID": userID, "fieldID": fieldID});
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

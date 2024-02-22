import 'package:dio/dio.dart';
import 'package:client_app/config/api_config.dart';

class FieldService {
  final Dio _dio = Dio(ApiConfig.options);

  Future<dynamic> addSoccerField(
      {required String userID,
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

  Future<List<dynamic>?> getSoccerField({required String userID}) async {
    try {
      final Response response = await _dio
          .get(ApiConfig.fieldUrl, queryParameters: {"userID": userID});
      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      print('ERROR GET FIELD: $e');
      return null;
    }
    return null;
  }
}

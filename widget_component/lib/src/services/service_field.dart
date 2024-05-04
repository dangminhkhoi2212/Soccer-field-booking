import 'package:dio/dio.dart';

class FieldService {
  final Dio _dio;
  factory FieldService(Dio dio) {
    final instance = FieldService._internal(dio);
    return instance;
  }
  FieldService._internal(this._dio);
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
    final Response response = await _dio.post('/field', data: {
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
    return response;
  }

  Future<dynamic> updateSoccerField(
      {required String userID,
      required String fieldID,
      required num price,
      required num width,
      required num length,
      required num type,
      required String name,
      required bool isLock,
      required bool isRepair,
      required String description,
      required String coverImage}) async {
    final Response response = await _dio.put('/field', data: {
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
    return response;
  }

  Future<Response> getSoccerField({String? userID, String? fieldID}) async {
    final Response response =
        await _dio.get('/field/all', queryParameters: {"userID": userID});
    return response;
  }

  Future<Response> getOneSoccerField({required String fieldID}) async {
    final Response response =
        await _dio.get('/field', queryParameters: {"fieldID": fieldID});
    return response;
  }
}

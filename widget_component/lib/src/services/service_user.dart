import 'package:dio/dio.dart';

class UserService {
  final Dio _dio;
  factory UserService(Dio dio) {
    final instance = UserService._internal(dio);
    return instance;
  }
  UserService._internal(this._dio);

  Future<Response> updateUser(
      {required String name,
      required String userID,
      required String phone,
      required String? avatar}) async {
    final response = await _dio.put('/user',
        data: {
          "userID": userID,
          "name": name,
          "phone": phone,
          'avatar': avatar
        },
        options: Options(headers: {
          'Accept': 'application/json',
        }));
    return response;
  }

  Future<Response> getOneUser({String? userID}) async {
    Response response = await _dio.get('/user', queryParameters: {
      "userID": userID,
    });
    return response;
  }

  Future<Response> getUsers(
      {String? userID, String? select, required String role}) async {
    Response response = await _dio.get('/user/all',
        queryParameters: {"userID": userID, "select": select, 'role': role});
    return response;
  }

  Future<Response> updatePassword(
      {required String oldPass, required String newPass}) async {
    Response response = await _dio
        .post('/user/password', data: {'oldPass': oldPass, 'newPass': newPass});
    return response;
  }
}

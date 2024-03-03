import 'package:widget_component/config/api_config.dart';
import 'package:widget_component/models/user_model.dart';
import 'package:dio/dio.dart';

class UserService {
  final Dio _dio = Dio(ApiConfig.options);

  Future<Map<String, dynamic>> updateUser(
      {required String name,
      required String userID,
      required String phone,
      required String? avatar}) async {
    try {
      final response = await _dio.put(ApiConfig.userApiUrl,
          data: {
            "userID": userID,
            "name": name,
            "phone": phone,
            'avatar': avatar
          },
          options: Options(headers: {
            'Accept': 'application/json',
          }));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        UserModel user = UserModel.fromJson(data);
        return user.toJson();
      }
      return {};
    } on DioException catch (e) {
      if (e.response != null) {
        print('ERROR: ${e.response!.data}');
        print('ERROR: ${e.response!.headers}');
        print('ERROR: ${e.response!.requestOptions}');
      } else {
        print('ERROR: ${e.requestOptions}');
        print('ERROR: ${e.message}');
      }
      return {'Error': e.message ?? ''};
    }
  }

  Future<Response?> getOneUser({String? userID}) async {
    try {
      Response response =
          await _dio.get(ApiConfig.userApiUrl, queryParameters: {
        "userID": userID,
      });
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        print('ERROR: ${e.response!.data}');
        print('ERROR: ${e.response!.headers}');
        print('ERROR: ${e.response!.requestOptions}');
      } else {
        print('ERROR: ${e.requestOptions}');
        print('ERROR: ${e.message}');
      }
      return null;
    }
  }

  Future<Response?> getUsers(
      {String? userID, String? select, required String role}) async {
    try {
      Response response = await _dio.get('${ApiConfig.userApiUrl}/all',
          queryParameters: {"userID": userID, "select": select, 'role': role});
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        print('ERROR: ${e.response!.data}');
        print('ERROR: ${e.response!.headers}');
        print('ERROR: ${e.response!.requestOptions}');
      } else {
        print('ERROR: ${e.requestOptions}');
        print('ERROR: ${e.message}');
      }
      return null;
    }
  }
}

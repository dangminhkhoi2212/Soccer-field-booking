import 'package:client_app/config/api_config.dart';
import 'package:client_app/models/model_user.dart';
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
        UserJson user = UserJson.fromJson(data);
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
}

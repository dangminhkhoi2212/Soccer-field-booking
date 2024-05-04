import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

class ApiConfig {
  static final String baseUrl = dotenv.get('URL_SERVER');
  static const int receiveTimeout = 60 * 1000;
  static const int connectionTimeout = 60 * 1000;

  static const String authApiUrl = '/auth/';
  static const String userApiUrl = '/user';
  static const String addressApiUrl = '/address';
  static const String fieldUrl = '/field';
  static const String sellerUrl = '/seller';
  static const String orderUrl = '/order';
  static const String feedbackUrl = '/feedback';
  static const String statisticUrl = '/statistic';

  final _box = GetStorage();
  final _logger = Logger();
  final dio = Dio(BaseOptions(
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      baseUrl: baseUrl,
      maxRedirects: 10,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: connectionTimeout),
      receiveTimeout: const Duration(seconds: receiveTimeout),
      responseType: ResponseType.json,
      contentType: 'application/json'));
  ApiConfig() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        String? accessToken = _box.read('accessToken');
        options.headers['authorization'] = 'Bear $accessToken';
        return handler.next(options);
      },
      // onResponse: (response, handler) {
      //   _logger.e(error: 'onResponse', response);
      //   return handler.next(response);
      // },
      onError: (error, handler) async {
        final String? errMessage = error.response!.data['err_mes'];

        if (error.response?.statusCode == 403 &&
            errMessage == 'token expired') {
          final String? newAccessToken = await refreshToken();
          if (newAccessToken != null) {
            dio.options.headers['authorization'] = 'Bear $newAccessToken';
            return handler.resolve(await dio.fetch(error.requestOptions));
          }
        }
        return handler.next(error);
      },
    ));
  }
  Future<String?> refreshToken() async {
    try {
      final refreshToken = _box.read('refreshToken');
      if (refreshToken == null) throw 'refreshToken not found';
      final Response response = await dio
          .post('/token/refreshToken', data: {'refreshToken': refreshToken});
      if (response.statusCode == 200) {
        final String newAccessToken = response.data['accessToken'];
        _box.write('accessToken', newAccessToken);
        return newAccessToken;
      }
    } catch (e) {
      _logger.e(e, error: 'refreshToken');
      _box.erase();
      Get.offAllNamed('/sign-in');
    }
    return null;
  }
}

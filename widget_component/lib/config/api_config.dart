import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static final String baseUrl = dotenv.get('URL_SERVER');
  // receiveTimeout
  static const int receiveTimeout = 60 * 1000;

  // connectTimeout
  static const int connectionTimeout = 60 * 1000;

  static final String authApiUrl = '$baseUrl/auth/';
  static final String userApiUrl = '$baseUrl/user';
  static final String addressApiUrl = '$baseUrl/address';
  static final String fieldUrl = '$baseUrl/field';
  static final String sellerUrl = '$baseUrl/seller';
  static final String orderUrl = '$baseUrl/order';

  static final options = BaseOptions(
    headers: {
      'Content-Type': 'application/json',
    },
    baseUrl: baseUrl,
    // receiveDataWhenStatusError: true,
    connectTimeout: const Duration(seconds: connectionTimeout),
    receiveTimeout: const Duration(seconds: receiveTimeout),
    responseType: ResponseType.json,
    validateStatus: (_) => true,
  );
}

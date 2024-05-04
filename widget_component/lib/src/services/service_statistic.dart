import 'package:dio/dio.dart';

class StatisticService {
  StatisticService._internal(this._dio);
  factory StatisticService(Dio dio) {
    final instance = StatisticService._internal(dio);
    return instance;
  }
  final Dio _dio;

  Future<Response?> getStatisticRevenue(
      {required String sellerID,
      String? date,
      String? month,
      String? year}) async {
    final Response response = await _dio.get('/statistic', queryParameters: {
      'sellerID': sellerID,
      'date': date,
      'month': month,
      'year': year
    });
    return response;
  }
}

import 'package:dio/dio.dart';

class FeedbackService {
  final Dio _dio;
  factory FeedbackService(Dio dio) {
    final instance = FeedbackService._internal(dio);
    return instance;
  }
  FeedbackService._internal(this._dio);
  Future<Response> createFeedback(
      {required String orderID,
      required String userID,
      required int star,
      required List<String?> images,
      required String content}) async {
    final Response response = await _dio.post('/feedback', data: {
      'orderID': orderID,
      'userID': userID,
      'star': star,
      'images': images,
      'content': content,
    });
    return response;
  }

  Future<Response> getFeedbacks(
      {required String fieldID,
      int? star,
      String? sortBy,
      int page = 1,
      int limit = 30}) async {
    Response response = await _dio.get('/feedback', queryParameters: {
      'sortBy': sortBy,
      'fieldID': fieldID,
      'star': star,
      'page': page,
      'limit': limit,
    });
    return response;
  }

  Future<Response> getStatisticFeedback(
      {String? fieldID, String? userID}) async {
    Response response = await _dio.get('${'/feedback'}/statistic',
        queryParameters: {'fieldID': fieldID, 'userID': userID});
    return response;
  }
}

import 'package:dio/dio.dart';
import 'package:widget_component/my_library.dart';

class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  final Dio _dio = Dio(ApiConfig.options);
  factory FeedbackService() {
    return _instance;
  }
  FeedbackService._internal();
  Future<Response?> createFeedback(
      {required String orderID,
      required String fieldID,
      required String sellerID,
      required String userID,
      required int star,
      required List<String?> images,
      required String content}) async {
    try {
      final Response response = await _dio.post(ApiConfig.feedbackUrl, data: {
        'orderID': orderID,
        'fieldID': fieldID,
        'sellerID': sellerID,
        'userID': userID,
        'star': star,
        'images': images,
        'content': content,
      });
      return response;
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print('ERROR: ${e.response!.data}');
        print('ERROR: ${e.response!.headers}');
        print('ERROR: ${e.response!.requestOptions}');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print('ERROR: ${e.requestOptions}');
        print('ERROR: ${e.message}');
      }
    }
    return null;
  }

  Future<Response?> getFeedbacks(
      {required String fieldID,
      int? star,
      String? sortBy,
      int page = 1,
      int limit = 30}) async {
    try {
      Response? response =
          await _dio.get(ApiConfig.feedbackUrl, queryParameters: {
        'sortBy': sortBy,
        'fieldID': fieldID,
        'star': star,
        'page': page,
        'limit': limit,
      });
      return response;
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print('ERROR: ${e.response!.data}');
        print('ERROR: ${e.response!.headers}');
        print('ERROR: ${e.response!.requestOptions}');
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print('ERROR: ${e.requestOptions}');
        print('ERROR: ${e.message}');
      }
    }
    return null;
  }
}

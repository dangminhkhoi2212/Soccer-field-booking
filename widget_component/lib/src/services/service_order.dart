import 'package:dio/dio.dart';

class OrderService {
  final Dio _dio;
  factory OrderService(Dio dio) {
    final instance = OrderService._internal(dio);
    return instance;
  }
  OrderService._internal(this._dio);

  Future<Response> createOrder(
      {required String userID,
      required String fieldID,
      required String startTime,
      required String endTime,
      required String date,
      required double total}) async {
    Response response = await _dio.post('/order', data: {
      'userID': userID,
      'fieldID': fieldID,
      'startTime': startTime,
      'endTime': endTime,
      'date': date,
      'total': total
    });
    return response;
  }

  Future<Response> updateOrder(
      {required String orderID, required String status}) async {
    Response response =
        await _dio.put('/order', data: {'orderID': orderID, 'status': status});
    return response;
  }

  Future<Response> getAllOrder({
    String? userID,
    String? sellerID,
    String? status,
    String? date,
    String? sortBy,
  }) async {
    Response response = await _dio.get('/order/all', queryParameters: {
      'sellerID': sellerID,
      'userID': userID,
      'status': status,
      'date': date,
      'sortBy': sortBy,
    });
    return response;
  }

  Future<Response> getOneOrder(
      {required String orderID, required String userID}) async {
    Response response = await _dio.get('/order', queryParameters: {
      'orderID': orderID,
      'userID': userID,
    });
    return response;
  }

  Future<Response> getOrderedTime(
      {required String fieldID, required String date}) async {
    Response response = await _dio.get('/order/time',
        queryParameters: {'fieldID': fieldID, 'date': date});
    return response;
  }
}

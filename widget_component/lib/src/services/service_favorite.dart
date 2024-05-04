import 'dart:ffi';

import 'package:dio/dio.dart';

class FavoriteService {
  final Dio dio;
  factory FavoriteService(Dio dio) {
    final instance = FavoriteService._internal(dio);
    return instance;
  }
  FavoriteService._internal(this.dio);

  Future<Response> handelFavorite(
      {required String userID, required String sellerID}) async {
    final Response response = await dio
        .post('/favorite', data: {"userID": userID, "sellerID": sellerID});
    return response;
  }

  Future<Response> checkFavorite(
      {required String userID, required String sellerID}) async {
    final Response response = await dio.get('/favorite',
        queryParameters: {"userID": userID, "sellerID": sellerID});
    return response;
  }

  Future<Response> getFavorites(
      {required String userID, int? page, int? limit, String? sortBy}) async {
    final Response response = await dio.get('/favorite/all', queryParameters: {
      "userID": userID,
      'page': page,
      'limit': limit,
      'sortBy': sortBy
    });
    return response;
  }
}

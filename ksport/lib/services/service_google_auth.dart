import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:client_app/config/api_config.dart';
import 'package:client_app/models/model_user.dart';
import 'package:client_app/services/service_login.dart';
import 'package:client_app/storage/storage_user.dart';
import 'package:client_app/store/store_user.dart';
import 'package:widget_component/my_library.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final StoreUser storeUser = Get.put(StoreUser());
  final box = GetStorage();
  final StorageUser _storageUser = StorageUser();
  final Dio _dio;
  factory AuthService(Dio dio) {
    final instance = AuthService._internal(dio);
    return instance;
  }
  AuthService._internal(this._dio);

  Future signInWithEmailAndPassword(
      {required String email, required String password}) async {
    final response = await _dio
        .post('/auth/sign-in', data: {"email": email, "password": password});
    return response;
  }

  Future signUp(
      {required String name,
      required String email,
      required String phone,
      required String password}) async {
    final response = await _dio.post('/auth', data: {
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "role": 'user'
    });
    return response;
  }

  void setUserLocal(data) {
    final UserJson user = UserJson.fromJson(data);

    _storageUser.setTokenLocal(
        accessToken: user.accessToken ?? '',
        refreshToken: user.refreshToken ?? '');

    _storageUser.setUser(user: user.toJson());
  }

  logOut() async {
    try {
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      Get.deleteAll();
      box.erase();
      await Get.offAllNamed(RoutePaths.signIn);
    } catch (e) {
      print('ERROR LOGOUT: $e');
    }
  }

  Future<String?> getIdToken() async {
    final User user = FirebaseAuth.instance.currentUser!;
    Future<String?> idToken = user.getIdToken(true);
    return idToken;
  }

  String? getName() {
    final String? name = FirebaseAuth.instance.currentUser?.displayName;

    return name ?? 'no name';
  }

  String? getAvatar() {
    final String? imageURL = FirebaseAuth.instance.currentUser?.photoURL;

    return imageURL;
  }
}

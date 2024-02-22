import 'package:get_storage/get_storage.dart';
import 'package:ksport_seller/models/model_user.dart';

class StorageUser {
  final _box = GetStorage();
  final List<String> _propsUser = [
    'name',
    'email',
    'avatar',
    'isPublic',
    'phone',
    'lock',
    'address',
    'accessToken',
    'refreshToken',
  ];
  void setUser({required Map<String, dynamic> user}) {
    _box.write('id', user['_id']);
    _box.write('name', user['name']);
    _box.write('email', user['email']);
    _box.write('avatar', user['avatar']);
    _box.write('phone', user['phone']);
    _box.write('isPublic', user['isPublic']);
    _box.write('lock', user['lock']);
    _box.write('accessToken', user['accessToken']);
    _box.write('refreshToken', user['refreshToken']);
    _box.write('createdAt', user['createdAt']);
    _box.write('updatedAt', user['updatedAt']);
    _box.write('role', user['role']);
  }

  void setUserLocal({required Map<String, dynamic> user}) {
    user.remove('accessToken');
    user.remove('refreshToken');
    _box.write('user', user);
  }

  void setTokenLocal(
      {required String accessToken, required String refreshToken}) {
    _box.write('accessToken', accessToken);
    _box.write('refreshToken', refreshToken);
  }

  UserJson getUserLocal() {
    final Map<String, dynamic> user = _box.read('user') ?? {};
    return UserJson.fromJson(user);
  }

  String getAccessTokenLocal() {
    return _box.read('accessToken');
  }

  String getRefreshTokenLocal() {
    return _box.read('refreshToken');
  }
}

import 'package:client_app/config/api_config.dart';
import 'package:client_app/services/service_google_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:line_icons/line_icon.dart';
import 'package:widget_component/my_library.dart';

class DrawerProfile extends StatefulWidget {
  const DrawerProfile({super.key});

  @override
  State<DrawerProfile> createState() => _DrawerProfileState();
}

class _DrawerProfileState extends State<DrawerProfile> {
  final _box = GetStorage();
  String name = '';
  String email = '';
  String avatar = '';
  Function? _listenChangeStorage;
  final List<Map<String, dynamic>> listMenu = [
    {
      'icon': const LineIcon.userEdit(
        size: 35,
      ),
      'title': 'Edit profile',
      'onPress': () => Get.toNamed(RoutePaths.editProfile),
    },
    {
      'icon': const LineIcon.mapMarked(
        size: 35,
      ),
      'title': 'Address',
      'onPress': () => Get.toNamed(RoutePaths.editAddress),
    },
    {
      'icon': const LineIcon.alternateSignOut(
        size: 35,
      ),
      'title': 'Sign out',
      'onPress': () => AuthService(ApiConfig().dio).logOut(),
    }
  ];
  @override
  void initState() {
    super.initState();
    initValue();
  }

  void listenChangeName() {
    _listenChangeStorage = _box.listen(() {
      initValue();
    });
  }

  @override
  void dispose() {
    _listenChangeStorage?.call();
    super.dispose();
  }

  void initValue() {
    name = _box.read('name');
    email = _box.read('email');
    avatar = _box.read('avatar');
  }

  List<ListTile> _buildListMenu() {
    return listMenu.map((item) {
      return ListTile(
        leading: item['icon'],
        title: Text(
          item['title'],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        onTap: item['onPress'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        UserAccountsDrawerHeader(
          accountName: Text(
            name,
            style: const TextStyle(color: Colors.black54),
          ),
          accountEmail: Text(
            email,
            style: const TextStyle(color: Colors.black54),
          ),
          currentAccountPicture: MyImage(
            height: 20,
            width: 20,
            src: avatar,
            isAvatar: true,
          ),
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/splash_color.jpg'),
            fit: BoxFit.cover,
          )),
        ),
        ..._buildListMenu(),
      ]),
    );
  }
}

import 'dart:math';

import 'package:ksport_seller/config/api_config.dart';
import 'package:ksport_seller/models/model_user.dart';
import 'package:ksport_seller/services/service_google_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:line_icons/line_icon.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class DrawerProfile extends StatefulWidget {
  const DrawerProfile({super.key});

  @override
  State<DrawerProfile> createState() => _DrawerProfileState();
}

class _DrawerProfileState extends State<DrawerProfile> {
  final _box = GetStorage();
  UserJson? user;
  String name = '';
  String email = '';
  String avatar = '';
  Function? _listenChangeStorage;
  final ApiConfig _apiConfig = ApiConfig();
  late AuthService _authService;
  List<Map<String, dynamic>> listMenu = [];
  final _logger = Logger();
  @override
  initState() {
    super.initState();
    _authService = AuthService(_apiConfig.dio);
    listMenu = [
      {
        'icon': const LineIcon.userEdit(
          size: 35,
        ),
        'title': 'Profile',
        'onPress': () => Get.toNamed(RoutePaths.editProfile),
      },
      {
        'icon': const LineIcon.lock(
          size: 35,
        ),
        'title': 'Password',
        'onPress': () => Get.toNamed(RoutePaths.password),
      },
      {
        'icon': const LineIcon.mapMarked(
          size: 35,
        ),
        'title': 'Address',
        'onPress': () => Get.toNamed(RoutePaths.editAddress),
      },
      {
        'icon': const LineIcon.calendar(
          size: 35,
        ),
        'title': 'Operating time',
        'onPress': () => Get.toNamed(RoutePaths.editOperatingTime),
      },
      {
        'icon': const LineIcon.alternateSignOut(
          size: 35,
        ),
        'title': 'Sign out',
        'onPress': () => _authService.logOut(),
      },
    ];
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
    _logger.d(avatar, error: 'avatar');
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
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(children: [
          // UserAccountsDrawerHeader(
          //   accountName: Text(
          //     name,
          //     style: const TextStyle(color: Colors.black54),
          //   ),
          //   accountEmail: Text(
          //     email,
          //     style: const TextStyle(color: Colors.black54),
          //   ),
          // ),
          ..._buildListMenu(),
        ]),
      ),
    );
  }
}

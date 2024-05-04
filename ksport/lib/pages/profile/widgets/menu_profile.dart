import 'package:client_app/config/api_config.dart';
import 'package:client_app/services/service_google_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class MenuModel {
  String? title;
  Widget? icon;
  Color? color;
  Function? onTap;
  String? path;
  Map<String, dynamic>? params;
  MenuModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    icon = json['icon'];
    color = json['color'];
    path = json['path'];
    params = json['params'];
    onTap = json['onTap'];
  }
}

class MenuUser extends StatefulWidget {
  const MenuUser({super.key});

  @override
  State<MenuUser> createState() => _MenuUserState();
}

class _MenuUserState extends State<MenuUser> {
  final _logger = Logger();
  late List<MenuModel> menus;
  @override
  void initState() {
    super.initState();
    initValue();
  }

  void initValue() {
    menus = [
      MenuModel.fromJson({
        'title': 'Profile',
        'icon': const LineIcon.user(
          size: 50,
          color: MyColor.primary,
        ),
        'onTap': () => Get.toNamed(RoutePaths.editProfile),
        'color': Colors.white,
        'path': RoutePaths.editProfile,
      }),
      MenuModel.fromJson({
        'title': 'Password',
        'icon': const LineIcon.lock(
          size: 50,
          color: MyColor.primary,
        ),
        'onTap': () => Get.toNamed(RoutePaths.password),
        'color': Colors.white,
        'path': RoutePaths.editProfile,
      }),
      MenuModel.fromJson({
        'title': 'My booking',
        'icon': const LineIcon.clipboardList(
          size: 50,
          color: Colors.red,
        ),
        'color': Colors.white,
        'path': RoutePaths.mainScreen,
        'onTap': () =>
            Get.offAndToNamed(RoutePaths.mainScreen, arguments: {'index': 2})
      }),
      MenuModel.fromJson({
        'title': 'Favorites',
        'icon': const LineIcon.heart(
          size: 50,
          color: Colors.red,
        ),
        'color': Colors.white,
        'onTap': () => Get.toNamed(RoutePaths.favorite),
      }),
      MenuModel.fromJson({
        'title': 'Sign out',
        'icon': const LineIcon.alternateSignOut(
          size: 50,
          color: Colors.blue,
        ),
        'color': Colors.white,
        'onTap': () {
          AuthService(ApiConfig().dio).logOut();
        }
      }),
    ];
  }

  Widget _buildCardMenu(MenuModel menu) {
    return GestureDetector(
      onTap: () async {
        await menu.onTap!();
      },
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            menu.icon!,
            Text(
              menu.title!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: menus.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          mainAxisExtent: 150),
      itemBuilder: (context, index) {
        MenuModel menu = menus[index];
        return _buildCardMenu(menu);
      },
    );
  }
}

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:client_app/pages/seller_list/seller_list_page.dart';
import 'package:get/get.dart';

import 'package:client_app/pages/home/home_page.dart';
import 'package:client_app/pages/order_list/order_list_page.dart';
import 'package:client_app/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List pages = [
    const HomePage(),
    const SellerListPage(),
    const OrderListPage(),
    const UserPage()
  ];
  final _iconList = [
    LineIcons.home,
    LineIcons.futbol,
    LineIcons.history,
    LineIcons.user
  ];
  final List<String> routes = [
    RoutePaths.home,
    RoutePaths.seller,
    RoutePaths.order,
    RoutePaths.user,
  ];
  final _logger = Logger();
  // final _pageController = PageController(
  //   initialPage: 0,
  // );
  // final _controller = NotchBottomBarController(index: 0);
  late PageController _pageController = PageController(
    initialPage: 0,
  );
  late NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);

  int maxCount = 4;
  @override
  void initState() {
    super.initState();
    handleRedirect();
  }

  void handleRedirect() {
    final arg = Get.arguments;
    if (arg != null) {
      final int? index = arg['index'];
      if (index != null && index < pages.length) {
        _pageController = PageController(initialPage: index);
        _controller = NotchBottomBarController(index: index);
      }
    } else {
      _pageController = PageController(initialPage: 0);
      _controller = NotchBottomBarController(index: 0);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _controller.dispose();
  }

  List<BottomBarItem> _bottomBarItems() {
    return _iconList
        .map(
          (icon) => BottomBarItem(
            inActiveItem: Icon(
              icon,
              color: Colors.blueGrey,
            ),
            activeItem: Icon(
              icon,
              color: Colors.black.withOpacity(.8),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(pages.length, (index) => pages[index]),
      ),
      bottomNavigationBar: (pages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              notchBottomBarController: _controller,
              color: Colors.white,
              showLabel: false,
              shadowElevation: 5,
              kBottomRadius: 28.0,
              notchColor: MyColor.secondary,
              removeMargins: false,
              bottomBarWidth: 500,
              durationInMilliSeconds: 300,
              bottomBarItems: _bottomBarItems(),
              onTap: (index) {
                _pageController.jumpToPage(index);
              },
              kIconSize: 24.0,
            )
          : null,
    );
  }
}

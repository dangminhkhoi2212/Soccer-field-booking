import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:get/get.dart';
import 'package:ksport_seller/pages/add_field/add_field_page.dart';
import 'package:ksport_seller/pages/add_field/widgets/form_add_field.dart';
import 'package:ksport_seller/pages/fields/fields_page.dart';
import 'package:ksport_seller/pages/home/home_page.dart';
import 'package:ksport_seller/pages/order_list/order_list_page.dart';
import 'package:ksport_seller/pages/profile/profile_page.dart';
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
    const AddFieldPage(),
    const OrderList(),
    const ProfilePage()
  ];
  int? _index;
  final _logger = Logger();
  late PageController _pageController;
  late NotchBottomBarController _controller;

  int maxCount = 4;
  late Worker worker;
  @override
  void initState() {
    super.initState();
    handleRedirect();
  }

  final _iconList = [
    LineIcons.home,
    LineIcons.futbol,
    LineIcons.history,
    LineIcons.user
  ];

  /// Controller to handle PageView and also handles initial page

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:client_app/pages/history_order/history_order_page.dart';
import 'package:client_app/pages/home/home_page.dart';
import 'package:client_app/pages/order_list/order_list_page.dart';
import 'package:client_app/pages/profile/profile_page.dart';
import 'package:client_app/pages/seller_list/seller_list_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _logger = Logger();
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

  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(
    initialPage: 0,
  );

  /// Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(
    index: 0,
  );

  int maxCount = 4;

  @override
  void initState() {
    super.initState();
    int? index = Get.parameters['index'] != null
        ? int.parse(Get.parameters['index']!)
        : null;
    _logger.d(index, error: 'main screen');
    if (index != null) {
      _buildPage(index);
    }
  }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   _controller.dispose();
  //   super.dispose();
  // }

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

  void _buildPage(int index) {
    try {
      _controller.jumpTo(0);
      // if (_pageController.hasClients) {
      // _pageController.animateToPage(
      //   1,
      //   duration: Durations.extralong1,
      //   curve: Curves.bounceIn,
      // );
      // }
      _pageController.jumpTo(0.0);

      _pageController.jumpToPage(index);
    } catch (e) {
      _logger.e(error: e, '_buildPage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(pages.length, (index) => pages[index]),
      ),
      bottomNavigationBar: (pages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              /// Provide NotchBottomBarController
              notchBottomBarController: _controller,
              color: Colors.white,
              showLabel: false,
              shadowElevation: 5,
              kBottomRadius: 28.0,

              notchColor: MyColor.secondary,

              /// restart app if you change removeMargins
              removeMargins: false,
              bottomBarWidth: 500,
              durationInMilliSeconds: 300,
              bottomBarItems: _bottomBarItems(),
              onTap: (index) {
                /// perform action on tab change and to update pages you can update pages without pages
                // log('current selected index $index');
                _pageController.jumpToPage(index);
              },
              kIconSize: 24.0,
            )
          : null,
    );
  }
}

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:get/get.dart';
import 'package:ksport_seller/pages/fields/fields_page.dart';
import 'package:ksport_seller/pages/history_order/history_order_page.dart';
import 'package:ksport_seller/pages/home.dart';
import 'package:ksport_seller/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:widget_component/my_library.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List pages = [
    const HomePage(),
    const FieldsPage(),
    const HistoryOrderPage(),
    const UserPage()
  ];
  late int _index = 0;

  @override
  void initState() {
    super.initState();
    final par = Get.parameters;
    print('params: $par');
    _index = par['index'] == '1' ? 1 : 0;
    debugPrint(_index.toString());
  }

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
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
    return SafeArea(
      child: Scaffold(
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
      ),
    );
  }
}

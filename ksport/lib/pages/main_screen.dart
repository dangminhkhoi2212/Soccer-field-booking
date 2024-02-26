import 'package:client_app/pages/field.dart';
import 'package:client_app/pages/history_order/history_order_page.dart';
import 'package:client_app/pages/home/home_page.dart';
import 'package:client_app/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:widget_component/const/colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List screens = [
    const HomePage(),
    const FieldPage(),
    const HistoryOrderPage(),
    const UserPage()
  ];
  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 60,
        width: double.infinity,
        child: GNav(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          curve: Curves.easeInQuad,
          color: Colors.black45,
          iconSize: 30,
          activeColor: MyColor.primary,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          selectedIndex: _index,
          onTabChange: (index) {
            setState(() {
              _index = index;
            });
          },
          // gap: 2,
          tabs: const [
            GButton(
              icon: LineIcons.home,
            ),
            GButton(
              icon: LineIcons.futbol,
            ),
            GButton(
              icon: LineIcons.fileInvoiceWithUsDollar,
            ),
            GButton(
              icon: LineIcons.user,
            ),
          ],
        ),
      ),
      body: screens[_index],
    );
  }
}

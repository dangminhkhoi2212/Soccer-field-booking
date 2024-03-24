import 'package:client_app/pages/profile/widgets/info_user.dart';
import 'package:client_app/pages/profile/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widget_component/my_library.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  UserState createState() => UserState();
}

class UserState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.background,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const InfoUser(),
            const SizedBox(height: 10),
            Flexible(child: MenuUser())
          ],
        ),
      ),
    );
  }
}

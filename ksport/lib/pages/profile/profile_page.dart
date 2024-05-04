import 'package:client_app/pages/profile/widgets/info_user.dart';
import 'package:client_app/pages/profile/widgets/menu_profile.dart';
import 'package:flutter/material.dart';
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
        child: const Column(
          children: [
            InfoUser(),
            SizedBox(height: 10),
            Flexible(child: MenuUser())
          ],
        ),
      ),
    );
  }
}

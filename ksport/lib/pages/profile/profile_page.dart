import 'package:client_app/pages/profile/widgets/appbar_profile.dart';
import 'package:client_app/pages/profile/widgets/avatar_user.dart';
import 'package:client_app/pages/profile/widgets/drawer_profile.dart';
import 'package:client_app/pages/profile/widgets/info_user.dart';
import 'package:client_app/routes/route_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  UserState createState() => UserState();
}

class UserState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const DrawerProfile(),
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100.0), child: AppBarProfile()),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const AvatarUser(),
          const SizedBox(height: 10),
          const InfoUser(),
          const SizedBox(height: 10),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Get.toNamed(RoutePaths.editProfile);
            },
            child: Ink(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),

                // color: Colors.white,
              ),
              child: const Text('Edit profile'),
            ),
          )
        ],
      ),
    );
  }
}

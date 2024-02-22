import 'package:ksport_seller/pages/edit_profile/widgets/form_edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final _box = GetStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        // margin: const EdgeInsets.all(10),
        child: const SingleChildScrollView(
          reverse: true,
          child: FromEditProfile(),
        ),
      ),
    );
  }
}

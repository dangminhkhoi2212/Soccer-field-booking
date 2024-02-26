import 'package:ksport_seller/models/model_user.dart';
import 'package:ksport_seller/storage/storage_user.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AppBarProfile extends StatefulWidget {
  const AppBarProfile({super.key});

  @override
  State<AppBarProfile> createState() => _AppBarProfileState();
}

class _AppBarProfileState extends State<AppBarProfile> {
  final _box = GetStorage();
  String? name;
  @override
  void initState() {
    super.initState();
    listenChangeName();
  }

  Function? disposeListen;
  void listenChangeName() {
    if (!mounted) return;
    disposeListen = _box.listenKey('name', (value) {
      setState(() {
        name = value;
      });
    });
  }

  @override
  void dispose() {
    disposeListen?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(_box.read('name').toString()),
      centerTitle: true,
    );
  }
}

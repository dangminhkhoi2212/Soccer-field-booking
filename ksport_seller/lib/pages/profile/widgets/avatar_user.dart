import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:widget_component/my_library.dart';

class AvatarUser extends StatefulWidget {
  const AvatarUser({super.key});

  @override
  State<AvatarUser> createState() => _AvatarUserState();
}

class _AvatarUserState extends State<AvatarUser> {
  final _box = GetStorage();

  Function? _listenAvatar;
  String? avatar;

  @override
  void initState() {
    super.initState();
    initValue();
    listenValue();
  }

  void initValue() async {
    avatar = _box.read('avatar');
  }

  void listenValue() {
    _listenAvatar = _box.listenKey('avatar', (value) {
      if (!mounted) return;
      setState(() {
        avatar = value;
      });
    });
  }

  @override
  void dispose() {
    _listenAvatar?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyImage(
      height: 150,
      width: 150,
      src: avatar.toString(),
      isAvatar: true,
    );
  }
}

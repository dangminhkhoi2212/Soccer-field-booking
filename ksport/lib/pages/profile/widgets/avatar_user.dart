import 'package:client_app/models/model_user.dart';
import 'package:client_app/storage/storage_user.dart';
import 'package:client_app/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

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
    initValue();
    listenValue();
    super.initState();
  }

  void initValue() async {
    avatar = _box.read('avatar');
  }

  void listenValue() {
    _listenAvatar = _box.listenKey('avatar', (value) {
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
    return Column(
      children: [
        AvatarCustom(
          size: 80,
          child: Image.network(
            avatar ?? '',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:widget_component/my_library.dart';

class InfoUser extends StatefulWidget {
  const InfoUser({super.key});

  @override
  State<InfoUser> createState() => _InfoUserState();
}

class _InfoUserState extends State<InfoUser> {
  final _box = GetStorage();

  Function? _listenAvatar;
  Function? _listenName;
  Function? _listenEmail;
  Function? _listenPhone;

  String? avatar;
  String? name;
  String? email;
  String? phone;

  @override
  void initState() {
    initValue();
    listenAvatar();
    listenEmail();
    listenName();
    listenPhone();
    super.initState();
  }

  void initValue() async {
    avatar = _box.read('avatar');
    name = _box.read('name');
    phone = _box.read('phone');
    email = _box.read('email');
  }

  void listenAvatar() {
    _listenAvatar = _box.listenKey('avatar', (value) {
      setState(() {
        avatar = value;
      });
    });
  }

  void listenName() {
    _listenName = _box.listenKey('name', (value) {
      setState(() {
        name = value;
      });
    });
  }

  void listenEmail() {
    _listenEmail = _box.listenKey('email', (value) {
      setState(() {
        email = value;
      });
    });
  }

  void listenPhone() {
    _listenPhone = _box.listenKey('phone', (value) {
      setState(() {
        phone = value;
      });
    });
  }

  @override
  void dispose() {
    _listenAvatar?.call();
    _listenName?.call();
    _listenEmail?.call();
    _listenPhone?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MyImage(
            width: 80,
            height: 80,
            src: avatar ?? '',
            isAvatar: true,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Text(
                name ?? '',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Text(
                email ?? '',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
            ],
          )
        ],
      ),
    );
  }
}

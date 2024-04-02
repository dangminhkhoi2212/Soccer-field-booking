import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class HeaderHome extends StatefulWidget {
  const HeaderHome({super.key});

  @override
  State<HeaderHome> createState() => _HeaderHomeState();
}

class _HeaderHomeState extends State<HeaderHome> {
  final _box = GetStorage();
  String? _name;
  @override
  void initState() {
    super.initState();
    _name = _box.read('name');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Welcome'),
          Text(
            _name ?? '',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          const Text(
            'Stay on top of your platform anytime, anywhere. Simplify management, seize insights, drive growth.',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
class MyBadge extends StatelessWidget {
  late String color;
  final String text;

  @override
  MyBadge({super.key, this.color = 'green', required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(text),
    );
  }
}

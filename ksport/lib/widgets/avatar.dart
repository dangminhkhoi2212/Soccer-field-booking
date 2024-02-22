import 'package:client_app/const/colors.dart';
import 'package:flutter/material.dart';

enum AvatarSize {
  sm,
  md,
  lg,
  xl,
  xxl,
}

class AvatarCustom extends StatelessWidget {
  final double size;
  final Widget child;

  const AvatarCustom({super.key, required this.size, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: MyColor.primary, // Set your desired border color here
          width: 1.8, // Set your desired border width here
        ),
      ),
      child: CircleAvatar(
        radius: size,
        backgroundColor: Colors.white,
        child: ClipOval(child: child),
      ),
    );
  }
}

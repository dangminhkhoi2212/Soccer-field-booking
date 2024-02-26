library widget_component;

import 'package:flutter/material.dart';
import 'package:widget_component/const/colors.dart';

class MyImage extends StatelessWidget {
  final double width;
  final double height;
  final String src;
  final double circular;
  final bool isAvatar;
  final double radius;

  const MyImage(
      {Key? key,
      required this.width,
      required this.height,
      required this.src,
      this.circular = 100,
      this.isAvatar = false,
      this.radius = 0})
      : super(key: key);

  FadeInImage _fadeInImage(String src) {
    return FadeInImage(
      placeholder: const AssetImage(
        'assets/images/loading.gif',
      ),
      image: NetworkImage(src),
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      imageErrorBuilder: (context, error, stackTrace) =>
          Image.asset('assets/images/image_error.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
      child: Center(
        child: isAvatar
            ? Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: MyColor.primary,
                    width: 1.8, // Set your desired border width here
                  ),
                ),
                child: CircleAvatar(
                  radius: circular,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: _fadeInImage(src),
                  ),
                ),
              )
            : _fadeInImage(src),
      ),
    );
  }
}

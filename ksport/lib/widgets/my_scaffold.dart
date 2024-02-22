import 'package:flutter/material.dart';

class MyScaffold extends StatelessWidget {
  final Widget child;
  final AppBar? appBar;
  const MyScaffold({super.key, required this.child, this.appBar});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: appBar,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          )),
    );
  }
}

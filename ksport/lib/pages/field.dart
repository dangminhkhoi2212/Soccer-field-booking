import 'package:client_app/routes/route_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FieldPage extends StatefulWidget {
  const FieldPage({super.key});

  @override
  _FieldState createState() => _FieldState();
}

class _FieldState extends State<FieldPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            const Text('filed'),
            ElevatedButton(
                onPressed: () {
                  Get.toNamed(RoutePaths.fieldDetail);
                },
                child: const Text('Go to detail'))
          ],
        ),
      ),
    );
  }
}

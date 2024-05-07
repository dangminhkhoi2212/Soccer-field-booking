import 'package:flutter/material.dart';
import 'package:ksport_seller/config/api_config.dart';
import 'package:widget_component/my_library.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final ApiConfig _apiConfig = ApiConfig();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Password'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(children: [
            PasswordForm(
              dio: _apiConfig.dio,
            )
          ]),
        ),
      ),
    );
  }
}

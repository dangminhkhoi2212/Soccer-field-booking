import 'package:client_app/widgets/my_scaffold.dart';
import 'package:flutter/material.dart';

class FieldDetailPage extends StatefulWidget {
  const FieldDetailPage({super.key});

  @override
  State<FieldDetailPage> createState() => _FieldDetailPageState();
}

class _FieldDetailPageState extends State<FieldDetailPage> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(),
      child: const Center(
        child: Text('detail'),
      ),
    );
  }
}

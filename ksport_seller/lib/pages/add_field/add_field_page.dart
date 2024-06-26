import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksport_seller/pages/add_field/widgets/form_add_field.dart';

class AddFieldPage extends StatefulWidget {
  const AddFieldPage({super.key});

  @override
  State<AddFieldPage> createState() => _AddFieldPageState();
}

class _AddFieldPageState extends State<AddFieldPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text('Add soccer field'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              color: Colors.white,
            ),
            child: const Column(
              children: [
                FormAddField(),
                SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
        ));
  }
}

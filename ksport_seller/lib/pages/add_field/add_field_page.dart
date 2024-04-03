import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksport_seller/pages/add_field/widgets/form_add_field.dart';

class AddFieldPage extends StatefulWidget {
  const AddFieldPage({super.key});

  @override
  State<AddFieldPage> createState() => _AddFieldPageState();
}

class _AddFieldPageState extends State<AddFieldPage> {
  String? _fieldID;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fieldID = Get.parameters['fieldID'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
              _fieldID != null ? 'Update soccer field' : 'Add soccer field'),
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
            child: const FormAddField(),
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksport_seller/pages/add_field/widgets/form_add_field.dart';
import 'package:ksport_seller/widgets/my_scaffold.dart';

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
    return MyScaffold(
        appBar: AppBar(
          title: Text(
              _fieldID != null ? 'Update soccer field' : 'Add soccer field'),
        ),
        child: SingleChildScrollView(
          child: Container(
            child: const FormAddField(),
          ),
        ));
  }
}

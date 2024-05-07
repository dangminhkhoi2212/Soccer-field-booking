import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksport_seller/pages/update_field/widgets/form_update_field.dart';

class UpdateFieldPage extends StatefulWidget {
  const UpdateFieldPage({super.key});

  @override
  State<UpdateFieldPage> createState() => _UpdateFieldPageState();
}

class _UpdateFieldPageState extends State<UpdateFieldPage> {
  String? _fieldID;
  @override
  void initState() {
    super.initState();
    _fieldID = Get.parameters['fieldID'];
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
          automaticallyImplyLeading: _fieldID != null,
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

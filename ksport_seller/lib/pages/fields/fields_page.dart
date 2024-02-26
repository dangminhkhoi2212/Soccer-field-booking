import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksport_seller/pages/fields/widgets/field_filter.dart';
import 'package:ksport_seller/pages/fields/widgets/field_list.dart';
import 'package:ksport_seller/routes/route_path.dart';
import 'package:line_icons/line_icon.dart';
import 'package:widget_component/const/colors.dart';

class FieldsPage extends StatefulWidget {
  const FieldsPage({super.key});

  @override
  State<FieldsPage> createState() => _FieldsPageState();
}

class _FieldsPageState extends State<FieldsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            color: MyColor.secondary,
          ),
          child: const Column(
            children: [
              Expanded(flex: 1, child: FieldFilter()),
              Expanded(flex: 2, child: SoccerFieldList()),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(RoutePaths.addField);
        },
        backgroundColor: MyColor.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(50)), // Adjust the value as needed
        ),
        child: const LineIcon.plus(
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}

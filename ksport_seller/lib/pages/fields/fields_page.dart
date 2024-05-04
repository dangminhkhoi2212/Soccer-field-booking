import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ksport_seller/pages/fields/widget/field_filter.dart';
import 'package:ksport_seller/pages/profile/widgets/soccer_field_list.dart';
import 'package:line_icons/line_icon.dart';
import 'package:widget_component/my_library.dart';

class FieldsPage extends StatefulWidget {
  const FieldsPage({super.key});

  @override
  State<FieldsPage> createState() => _FieldsPageState();
}

class _FieldsPageState extends State<FieldsPage> {
  late String _userID;
  final _box = GetStorage();
  @override
  void initState() {
    super.initState();
    _userID = _box.read('id');
  }

  Container _buildButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      ),
      child: Flex(
        mainAxisAlignment: MainAxisAlignment.end,
        direction: Axis.horizontal,
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'Add new field',
            style: TextStyle(fontSize: 13),
          ),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(RoutePaths.addField);
            },
            style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: MyColor.primary,
                padding: const EdgeInsets.all(5)),
            // backgroundColor: MyColor.primary,
            // shape:
            child: const LineIcon.plus(
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: MyColor.secondary,
        ),
        child: Column(
          children: [
            const Expanded(child: FieldFilter()),
            Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                      color: MyColor.background,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Column(
                    children: [
                      _buildButton(),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: SoccerFieldList(
                            userID: _userID,
                            isSeller: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

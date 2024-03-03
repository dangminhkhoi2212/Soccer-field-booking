import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ksport_seller/routes/route_path.dart';
import 'package:line_icons/line_icon.dart';
import 'package:widget_component/my_library.dart';

class SoccerFieldList extends StatefulWidget {
  const SoccerFieldList({Key? key}) : super(key: key);

  @override
  State<SoccerFieldList> createState() => SoccerFieldListState();
}

class SoccerFieldListState extends State<SoccerFieldList> {
  List<dynamic>? _soccerFields = [];
  final GetStorage _box = GetStorage();
  String? _id;
  late var timer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getSoccerFields();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getSoccerFields() async {
    if (!mounted) return;
    try {
      setState(() {
        _isLoading = true;
      });
      _id = _box.read('id');
      if (_id!.isEmpty) return;
      final dynamic response =
          await FieldService().getSoccerField(userID: _id!);
      if (response!.statusCode == 200) {
        final data = response.data;
        if (data!.isNotEmpty) {
          setState(() {
            _soccerFields = data;
          });
        }
      }
    } catch (e) {
      _soccerFields = [];
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        color: MyColor.background,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
      ),
      child: Column(
        children: [
          _buildButton(),
          const SizedBox(
            height: 10,
          ),
          Expanded(child: _buildListField())
        ],
      ),
    );
  }

  Widget _buildListField() {
    if (_isLoading) {
      return Center(
        child: MyLoading.spinkit(),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 20, // Two columns
        crossAxisSpacing: 20.0, childAspectRatio: 1 / 1,
        mainAxisExtent: 250,
      ),
      itemCount: _soccerFields!.length,
      itemBuilder: (context, index) {
        final FieldModel field = FieldModel.fromJson(_soccerFields![index]);
        debugPrint(field.toString());
        return FieldCard(
          field: field,
          onTap: () async {
            await Get.toNamed(RoutePaths.addField,
                parameters: {'fieldID': field.sId.toString()});
          },
        );
      },
    );
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
}

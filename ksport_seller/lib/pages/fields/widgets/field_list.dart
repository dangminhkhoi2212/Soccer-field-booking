import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ksport_seller/pages/fields/widgets/field_card.dart';
import 'package:ksport_seller/services/service_field.dart';

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
    try {
      if (!mounted) return;
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 60,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(60))),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 20, // Two columns
          crossAxisSpacing: 20.0, childAspectRatio: 1 / 1, mainAxisExtent: 250,
        ),
        itemCount: _soccerFields!.length,
        itemBuilder: (context, index) {
          final field = _soccerFields![index];
          return FieldCard(field: field);
        },
      ),
    );
  }
}

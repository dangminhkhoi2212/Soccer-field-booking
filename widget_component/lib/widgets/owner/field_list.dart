import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class SoccerFieldList extends StatefulWidget {
  final String userID;
  final bool isOnTap;
  final bool isSeller;
  const SoccerFieldList(
      {super.key,
      required this.userID,
      this.isOnTap = false,
      this.isSeller = false});

  @override
  State<SoccerFieldList> createState() => SoccerFieldListState();
}

class SoccerFieldListState extends State<SoccerFieldList> {
  List<FieldModel?> _soccerFields = [];
  final GetStorage _box = GetStorage();
  String? _userID;
  late var timer;
  bool _isLoading = false;
  final bool _isGettingOwner = false;
  final Logger _logger = Logger();
  bool _isOnTap = false;
  bool _isSeller = false;

  @override
  void initState() {
    super.initState();
    _userID = widget.userID;
    _isOnTap = widget.isOnTap;
    _isSeller = widget.isSeller;
    _getSoccerFields();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return; // TODO: implement setState
    super.setState(fn);
  }

  Future<void> _getSoccerFields() async {
    if (!mounted) return;
    try {
      setState(() {
        _isLoading = true;
      });
      if (_userID!.isEmpty) return;
      final dynamic response =
          await FieldService().getSoccerField(userID: _userID!);
      if (response!.statusCode == 200) {
        final data = response.data;
        if (data!.isNotEmpty) {
          data.forEach((field) {
            FieldModel temp = FieldModel.fromJson(field);
            _soccerFields.add(temp);
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

  Widget _buildBody() {
    if (_userID == null) {
      return const Center(
        child: Text('Don not find this user'),
      );
    }
    if (_isLoading) {
      return Center(
        child: MyLoading.spinkit(),
      );
    }
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 20, // Two columns
        crossAxisSpacing: 20.0, childAspectRatio: 1 / 1,
        mainAxisExtent: 250,
      ),
      itemCount: _soccerFields.length,
      itemBuilder: (context, index) {
        final FieldModel? field = _soccerFields[index];
        debugPrint(field.toString());
        if (field == null) return const SizedBox();
        return FieldCard(
          field: field,
          onTap: () async {
            if (_isSeller) {
              return await Get.toNamed(
                RoutePaths.addField,
                parameters: {'fieldID': field.sId ?? ''},
              );
            }
            await Get.toNamed(RoutePaths.fieldBooking, parameters: {
              'sellerID': field.userID ?? '',
              'fieldID': field.sId ?? ''
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}

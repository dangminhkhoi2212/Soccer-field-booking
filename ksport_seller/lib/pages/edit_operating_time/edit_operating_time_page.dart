import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:ksport_seller/utils/util_snackbar.dart';
import 'package:line_icons/line_icon.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/const/colors.dart';
import 'package:widget_component/services/service_seller.dart';
import 'package:widget_component/utils/loading.dart';

class EditOperatingTime extends StatefulWidget {
  const EditOperatingTime({super.key});

  @override
  State<EditOperatingTime> createState() => _EditOperatingTimeState();
}

class _EditOperatingTimeState extends State<EditOperatingTime> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _box = GetStorage();
  final logger = Logger();
  String _userID = '';
  DateFormat format = DateFormat('HH:mm');
  late final Map<String, dynamic> _initValue = {
    'isHalfHour': true,
    'startTime': DateTime(2023, 01, 01, 5, 0),
    'endTime': DateTime(2050, 01, 01, 23, 0)
  };
  bool _isLoading = false;

  @override
  void initState() {
    _userID = _box.read('id');
    _getOperatingTime();
    super.initState();
  }

  Future _getOperatingTime() async {
    try {
      final Response? response =
          await SellerService().getSeller(userID: _userID);

      if (response!.statusCode == 200) {
        final rawData = response.data;
        dynamic data;
        if (rawData is List) {
          data = rawData[0];
        } else {
          data = rawData;
        }
        logger.d(data);
        if (data != null) {
          _formKey.currentState!.fields['startTime']!
              .didChange(format.parse(data['startTime']));
          _formKey.currentState!.fields['endTime']!
              .didChange(format.parse(data['endTime']));
          _formKey.currentState!.fields['isHalfHour']!
              .didChange(data['isHalfHour']);
        }
      }
    } catch (e) {
      logger.d(e.toString());
    }
  }

  Future _handleSave() async {
    try {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      final data = _formKey.currentState!.value;
      final DateTime startTime = data['startTime']; // Retrieve DateTime objects
      final DateTime endTime = data['endTime'];
      final errors = _formKey.currentState!.errors;
      if (errors.isEmpty) {
        final valueStartTime = '${startTime.hour}:${startTime.minute}';
        final valueEndTime = '${endTime.hour}:${endTime.minute}';
        final bool isHalfHour = data['isHalfHour'];

        debugPrint('Start Time: $valueStartTime');
        debugPrint('End Time: $valueEndTime');
        debugPrint('isHalfHour: $isHalfHour');

        final Response? response = await SellerService().updateSeller(
            userID: _userID,
            startTime: valueStartTime,
            endTime: valueEndTime,
            isHalfHour: isHalfHour);

        if (response!.statusCode == 200) {
          SnackbarUtil.getSnackBar(
              title: 'Update operating time', message: "Updated successfully");
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    Future.delayed(
        const Duration(milliseconds: 2000),
        () => setState(() {
              _isLoading = false;
            }));
  }

  Widget _buildButton() {
    return GestureDetector(
      onTap: _handleSave,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          color: MyColor.primary,
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        child: Center(
            child: _isLoading
                ? MyLoading.spinkit(size: 100)
                : const Text(
                    'Save',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operating time'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: FormBuilder(
            initialValue: _initValue,
            key: _formKey,
            child: Column(
              children: [
                FormBuilderDateTimePicker(
                  decoration: const InputDecoration(
                      label: Text('Start time'),
                      prefixIcon: LineIcon.hourglassStart()),
                  inputType: InputType.time,
                  format: DateFormat('HH:mm'),
                  name: 'startTime',
                ),
                const SizedBox(
                  height: 20,
                ),
                FormBuilderDateTimePicker(
                  decoration: const InputDecoration(
                      label: Text('End time'),
                      prefixIcon: LineIcon.hourglassEnd()),
                  inputType: InputType.time,
                  format: DateFormat('HH:mm'),
                  name: 'endTime',
                ),
                const SizedBox(
                  height: 20,
                ),
                FormBuilderSwitch(
                  activeColor: MyColor.primary,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none),
                  name: 'isHalfHour',
                  title: const Text('Allow book half an hour'),
                ),
                _buildButton()
              ],
            )),
      ),
    );
  }
}

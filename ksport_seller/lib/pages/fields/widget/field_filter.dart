import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icon.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class FieldFilter extends StatefulWidget {
  const FieldFilter({Key? key}) : super(key: key);

  @override
  State<FieldFilter> createState() => _FieldFilterState();
}

class _FieldFilterState extends State<FieldFilter> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _initValue = {'date': DateTime.now()};
  final _box = GetStorage();
  final logger = Logger();
  late bool _isHalfHour = false;
  final format = DateFormat('HH:mm');
  final List<Map<String, dynamic>> _listTime = [];
  late String _userID;
  Map<String, dynamic>? _startTime;
  Map<String, dynamic>? _endTime;
  String? startTime;
  String? endTime;
  List<TimeOfDay?> _disableTimes = [];
  bool _isLoading = false;
  TimeRangePickerState timeRangePicker = TimeRangePickerState();
  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    _userID = _box.read('id');
    _getOperatingTime();
    _generateDisableTime();
  }

  void _generateDisableTime() {
    _disableTimes = DateTimeUtil.generateTime(
        startTime: const TimeOfDay(hour: 7, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 30),
        isHalfHour: true);
    setState(() {});
  }

  Future<void> _getOperatingTime() async {
    try {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      final response = await SellerService().getOneSeller(userID: _userID);

      if (response!.statusCode == 200) {
        final data = response.data;

        startTime = data['startTime'];
        endTime = data['endTime'];
        _isHalfHour = data['isHalfHour'] ?? false;
        // _disableTimes = [
        //   const TimeOfDay(hour: 11, minute: 0),
        //   const TimeOfDay(hour: 11, minute: 30),
        //   const TimeOfDay(hour: 20, minute: 30)
        // ];
      }
    } catch (e) {
      logger.e(error: e, 'Error _getOperatingTime');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: MyLoading.spinkit(),
          )
        : Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: ScreenUtil.getWidth(context) / 2,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: MyColor.primary, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                child: FormBuilder(
                  key: _formKey,
                  initialValue: _initValue,
                  child: FormBuilderDateTimePicker(
                    name: 'date',
                    showCursor: true,
                    inputType: InputType.date,
                    keyboardType: TextInputType.datetime,
                    format: DateFormat('dd/MM/yyyy'),
                    decoration: const InputDecoration(
                      prefixIcon: LineIcon.calendar(),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusColor: MyColor.third,
                      border: OutlineInputBorder(
                          // borderSide: BorderSide(strokeAlign: 2),
                          ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: TimeRangePicker(
                isHalfHour: _isHalfHour,
                onEndTimePickChange: (TimeOfDay? endTime) {
                  // print('end Time $endTime');
                },
                onStartTimePickChange: (TimeOfDay? startTime) {
                  // print('start Time $startTime');
                },
              )),
            ],
          );
  }
}

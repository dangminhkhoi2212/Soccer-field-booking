import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:ksport_seller/pages/fields/widgets/time_button.dart';
import 'package:ksport_seller/utils/screen.dart';
import 'package:line_icons/line_icon.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/const/colors.dart';
import 'package:widget_component/services/service_seller.dart';
import 'package:widget_component/utils/loading.dart';
import 'package:widget_component/widgets/time_range_picker/time_range_picker.dart';

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
  final List<TimeOfDay?> _disableTimes = [];
  bool _isLoading = false;
  TimeRangePickerState timeRangePicker = TimeRangePickerState();

  @override
  void initState() {
    super.initState();
    _userID = _box.read('id');
    _getOperatingTime();
  }

  List<Map<String, dynamic>> generateTimeIntervals({
    required int start,
    required int end,
  }) {
    List<Map<String, dynamic>> timeIntervals = [];
    int id = 0;
    for (int hour = start; hour < end; hour++) {
      if (_isHalfHour) {
        for (int minute = 0; minute < 60; minute += 30) {
          timeIntervals.add({
            'id': id,
            'active': false,
            'time': TimeOfDay(hour: hour, minute: minute),
          });
          id++;
        }
      } else {
        timeIntervals.add({
          'id': id,
          'active': false,
          'time': TimeOfDay(hour: hour, minute: 0),
        });
        id++;
      }
    }
    return timeIntervals;
  }

  Future<void> _getOperatingTime() async {
    try {
      if (!mounted) return;
      setState(() {
        _isLoading = true;
      });
      final response = await SellerService().getSeller(userID: _userID);

      if (response!.statusCode == 200) {
        final data = response.data[0];

        startTime = data['startTime'];
        endTime = data['endTime'];
        _isHalfHour = data['isHalfHour'] ?? false;
        _disableTimes.add(const TimeOfDay(hour: 11, minute: 0));
      }
    } catch (e) {
      logger.e(error: e, 'Error _getOperatingTime');
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _handleTimeButton(int index) {
    for (var item in _listTime) {
      item['active'] = false;
    }
    final Map<String, dynamic> timeItem = _listTime[index];
    debugPrint(timeItem.toString());

    if (_startTime != null && _endTime != null) {
      _startTime = timeItem;

      _endTime = null;
    } else if (_startTime == null) {
      _startTime = timeItem;
    } else {
      _endTime = timeItem;
    }
    timeItem['active'] = true;

    if (_startTime != null && _endTime != null) {
      int idStart = _startTime!['id'];
      int idEnd = _endTime!['id'];
      if (idStart > idEnd) {
        int temp = idStart;
        idStart = idEnd;
        idEnd = temp;
      }
      for (int i = idStart; i <= idEnd; i++) {
        _listTime[i]['active'] = true;
      }
    }

    setState(() {});
  }

  Widget _buildListTime() {
    List<Widget> timeButtons = [];
    for (int i = 0; i < _listTime.length; i++) {
      Map<String, dynamic> timeItem = _listTime[i];
      final timeButton = GestureDetector(
        onTap: () {
          _handleTimeButton(i);
        },
        child:
            TimeButton(timeItem: timeItem, onTap: () => _handleTimeButton(i)),
      );

      timeButtons.add(timeButton);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 5,
          runSpacing: 5,
          children: timeButtons,
        ),
      ),
    );
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: MyColor.primary, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                child: FormBuilder(
                  key: _formKey,
                  initialValue: _initValue,
                  child: Column(
                    children: [
                      FormBuilderDateTimePicker(
                        name: 'date',
                        showCursor: true,
                        inputType: InputType.date,
                        keyboardType: TextInputType.datetime,
                        format: DateFormat('dd/MM/yyyy'),
                        decoration: const InputDecoration(
                          prefixIcon: LineIcon.calendar(),
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusColor: MyColor.third,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(strokeAlign: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: TimeRangePicker(
                endTime: endTime!,
                startTime: startTime!,
                isHalfHour: _isHalfHour,
                disableTimes: _disableTimes,
                onEndTimePickChange: (String endTime) {
                  print('end Time $endTime');
                },
                onStartTimePickChange: (String startTime) {
                  print('start Time $startTime');
                },
              )),
            ],
          );
  }
}

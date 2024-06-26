import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';
import 'package:widget_component/src/widgets/time_range_picker/widget/time_button.dart';

class TimeRangePicker extends StatefulWidget {
  final String startTime;
  final String endTime;
  final bool isHalfHour;
  final Function(TimeOfDay?) onStartTimePickChange;
  final Function(TimeOfDay?) onEndTimePickChange;
  late List<TimeOfDay?>? disableTimes;
  TimeRangePicker({
    Key? key,
    this.startTime = '5:0',
    this.endTime = '23:0',
    this.isHalfHour = false,
    this.disableTimes,
    required this.onStartTimePickChange,
    required this.onEndTimePickChange,
  }) : super(key: key);

  @override
  State<TimeRangePicker> createState() => TimeRangePickerState();
}

class TimeRangePickerState extends State<TimeRangePicker> {
  late DateTime startTimeInput;
  late DateTime endTimeInput;
  final logger = Logger();
  final _formKey = GlobalKey<FormBuilderState>();
  final _initValue = {'date': DateTime.now()};
  final _box = GetStorage();
  late bool _isHalfHour;
  final format = DateFormat('HH:mm');
  List<Map<String, dynamic>?> _listTime = [];
  late String _userID;
  Map<String, dynamic>? _startTime;
  Map<String, dynamic>? _endTime;
  List<TimeOfDay?> _disableTimes = [];

  @override
  void initState() {
    super.initState();
    _defineValue();
  }

  @override
  void didUpdateWidget(TimeRangePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startTime != widget.startTime ||
        oldWidget.endTime != widget.endTime ||
        oldWidget.isHalfHour != widget.isHalfHour ||
        !listEquals(oldWidget.disableTimes, widget.disableTimes)) {
      _defineValue();
    }
  }

  void _defineValue() {
    startTimeInput = format.parse(widget.startTime);
    endTimeInput = format.parse(widget.endTime);
    _isHalfHour = widget.isHalfHour;
    _disableTimes = List.from(widget.disableTimes ?? []);
    _listTime = generateTimeIntervals(
        start: startTimeInput.hour, end: endTimeInput.hour);
    setState(() {});
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
            'enable': true,
            'time': TimeOfDay(hour: hour, minute: minute),
          });
          id++;
        }
      } else {
        timeIntervals.add({
          'id': id,
          'active': false,
          'enable': true,
          'time': TimeOfDay(hour: hour, minute: 0),
        });
        id++;
      }
    }
    if (_disableTimes.isNotEmpty) {
      for (int i = 0; i < timeIntervals.length; i++) {
        TimeOfDay time = timeIntervals[i]['time'];
        bool check = _disableTimes.contains(time);
        if (check) {
          timeIntervals[i]['enable'] = false;
        }
      }
    }
    return timeIntervals;
  }

  bool _checkValidTime({
    required int idStartTime,
    required int idEndTime,
  }) {
    for (int i = idStartTime; i <= idEndTime; i++) {
      Map<String, dynamic>? time = _listTime[i];

      if (time!['enable'] == false) {
        return false;
      }
    }
    return true;
  }

  void _handleTimeButton(int index) {
    for (var item in _listTime) {
      item!['active'] = false;
    }
    final Map<String, dynamic>? timeItem = _listTime[index];

    if (_startTime != null && _endTime != null) {
      _startTime = timeItem;
      _endTime = null;
    } else if (_startTime == null) {
      _startTime = timeItem;
      _endTime = null;
    } else {
      _endTime = timeItem;
    }

    timeItem!['active'] = true;

    if (_startTime != null && _endTime != null) {
      int idStart = _startTime!['id'];
      int idEnd = _endTime!['id'];

      if (idStart > idEnd) {
        int temp = idStart;
        idStart = idEnd;
        idEnd = temp;

        Map<String, dynamic>? tempTime = _startTime;
        _startTime = _endTime;
        _endTime = tempTime;
      }

      if (_checkValidTime(idStartTime: idStart, idEndTime: idEnd) == false) {
        SnackbarUtil.getSnackBar(
            title: 'Select time', message: "Can't select this time");
        return;
      }

      for (int i = idStart; i <= idEnd; i++) {
        _listTime[i]!['active'] = true;
      }
    }
    widget.onStartTimePickChange(_startTime?['time']); // Call callback
    widget.onEndTimePickChange(_endTime?['time']); // Call callback
    setState(() {});
  }

  Widget _buildListTime() {
    List<Widget> timeButtons = [];
    for (int i = 0; i < _listTime.length; i++) {
      Map<String, dynamic>? timeItem = _listTime[i];
      final timeButton = TimeButton(
        timeItem: timeItem ?? {},
        onTap: () => _handleTimeButton(i),
        enable: timeItem!['enable'],
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
    return _buildListTime();
  }
}

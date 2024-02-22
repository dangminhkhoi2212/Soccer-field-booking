import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:ksport_seller/const/colors.dart';
import 'package:ksport_seller/services/service_seller.dart';
import 'package:ksport_seller/utils/screen.dart';
import 'package:line_icons/line_icon.dart';

class FieldFilter extends StatefulWidget {
  const FieldFilter({super.key});

  @override
  State<FieldFilter> createState() => _FieldFilterState();
}

class _FieldFilterState extends State<FieldFilter> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _initValue = {'date': DateTime.now()};
  final _box = GetStorage();
  final format = DateFormat('HH:mm');
  List<TimeOfDay> _listTime = [];
  late String _userID;
  @override
  void initState() {
    super.initState();
    _userID = _box.read('id');
    _getOperatingTime();
  }

  List<TimeOfDay> generateTimeIntervals(
      {required int start, required int end}) {
    List<TimeOfDay> timeIntervals = [];
    for (int hour = start; hour < end; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        timeIntervals.add(TimeOfDay(hour: hour, minute: minute));
      }
    }
    return timeIntervals;
  }

  Future _getOperatingTime() async {
    try {
      if (!mounted) return;
      final response = await SellerService().getSeller(userID: _userID);
      if (response!.statusCode == 200) {
        final data = response.data;
        final startTime = format.parse(data['startTime']);
        final endTime = format.parse(data['endTime']);
        setState(() {
          _listTime =
              generateTimeIntervals(start: startTime.hour, end: endTime.hour);
        });
        debugPrint(_listTime.toString());
      }
    } catch (e) {}
  }

  Widget _buildListTime() {
    final times = _listTime.map((TimeOfDay time) {
      return GestureDetector(
        onTap: () {
          debugPrint(time.toString());
        },
        child: Container(
          width: 55,
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
              color: MyColor.fourth,
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Center(
            child: Text(
              '${time.hour}:${time.minute}',
              style: const TextStyle(),
            ),
          ),
        ),
      );
    }).toList();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 5,
          runSpacing: 5,
          children: times,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: ScreenUtil.getWidth(context) / 2,
          decoration: const BoxDecoration(
              color: MyColor.fourth,
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: FormBuilder(
            key: _formKey,
            initialValue: _initValue,
            child: Column(
              children: [
                FormBuilderDateTimePicker(
                  name: 'date',
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
                          borderSide: BorderSide(strokeAlign: 2))),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: _buildListTime()),
      ],
    );
  }
}

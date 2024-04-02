import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:widget_component/my_library.dart';

class FilterChart extends StatefulWidget {
  const FilterChart({super.key});

  @override
  State<FilterChart> createState() => _FilterChartState();
}

class _FilterChartState extends State<FilterChart> {
  final _box = GetStorage();
  final _logger = Logger();
  String date = '';
  String month = '';
  String year = '';

  Widget _buildSelectDateTime() {
    return Container(
      alignment: FractionalOffset.topLeft,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Wrap(
        spacing: 10,
        children: [
          OutlinedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return DatePickerDialog(
                    keyboardType: TextInputType.datetime,
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2030),
                  );
                },
              ).then((value) {
                if (value != null) {
                  date = FormatUtil.formatDate(value);
                  month = '';
                  year = '';
                  _box.write('date', date);
                  setState(() {});
                }
              });
            },
            child: Text(date.isEmpty ? 'Date' : date),
          ),
          OutlinedButton(
            onPressed: () async {
              await showMonthYearPicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2023),
                lastDate: DateTime(2030),
                initialMonthYearPickerMode: MonthYearPickerMode.month,
                builder: (BuildContext context, Widget? child) => Theme(
                    data: Theme.of(context).copyWith(
                        cardColor: MyColor.litePrimary,
                        primaryColor: MyColor.primary,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap),
                    child: child!),
              ).then((value) {
                if (value != null) {
                  final String monthValue = value.month.toString();
                  _logger.f(error: value, 'month');
                  month = monthValue;
                  year = '';
                  date = '';
                  _box.write('month', month);
                  setState(() {});
                }
              });
            },
            child: Text(month.isEmpty ? 'Month' : month),
          ),
          OutlinedButton(
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Select a year'),
                        content: SizedBox(
                          height: 300,
                          width: 300,
                          child: YearPicker(
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2030),
                            onChanged: (value) {
                              final String yearValue = value.year.toString();
                              _logger.f(error: value, 'yearValue');
                              year = yearValue;
                              date = '';
                              month = '';
                              _box.write('year', yearValue);
                              setState(() {});

                              Navigator.pop(context);
                            },
                            selectedDate: DateTime(2023),
                          ),
                        ),
                      ));
            },
            child: Text(year.isEmpty ? 'Year' : year),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSelectDateTime();
  }
}

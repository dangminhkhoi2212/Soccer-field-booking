import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ksport_seller/pages/home/widget/home_page_state.dart';
import 'package:logger/logger.dart';
import 'package:month_year_picker/month_year_picker.dart';

import 'package:widget_component/my_library.dart';

class FilterChart extends StatefulWidget {
  const FilterChart({super.key});

  @override
  State<FilterChart> createState() => _FilterChartState();
}

class _FilterChartState extends State<FilterChart> {
  final _homeController = Get.put(HomeController());
  final _box = GetStorage();
  final _logger = Logger();
  DateTime? selectedYear = DateTime.now();
  DateTime? selectedMonth = DateTime.now();
  DateTime? selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
  }

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
                      initialDate: selectedDate,
                      keyboardType: TextInputType.datetime,
                      initialCalendarMode: DatePickerMode.day,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2030),
                    );
                  },
                ).then((value) {
                  _logger.d(value);
                  if (value != null) {
                    final date = FormatUtil.formatDate(value);
                    _homeController.changeDate(date);
                    setState(() {
                      selectedDate = value;
                    });
                  }
                });
              },
              child: Obx(() => Text(_homeController.date.value != ''
                  ? _homeController.date.value
                  : 'Date'))),
          OutlinedButton(
            onPressed: () async {
              await showMonthYearPicker(
                context: context,
                initialDate: selectedMonth!,
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
                  final String monthValue = DateFormat('MM-yyyy').format(value);
                  _homeController.changeMonth(monthValue);
                  setState(() {
                    selectedMonth = value;
                  });
                }
              });
            },
            child: Obx(() => Text(_homeController.month.value != ''
                ? _homeController.month.value
                : 'Month')),
          ),
          OutlinedButton(
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: const Text('Select year'),
                        content: SizedBox(
                          height: 300,
                          width: 300,
                          child: YearPicker(
                            selectedDate: selectedYear,
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2030),
                            onChanged: (value) {
                              final String yearValue = value.year.toString();

                              _homeController.changeYear(yearValue);
                              setState(() {
                                selectedYear = value;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ));
            },
            child: Obx(() => Text(_homeController.year.value != ''
                ? _homeController.year.value
                : 'Year')),
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

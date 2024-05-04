import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:line_icons/line_icon.dart';
import 'package:intl/intl.dart';
import 'package:widget_component/my_library.dart';

class FilterOrder extends StatefulWidget {
  final Function({
    String? date,
    String? status,
    String? sortBy,
  }) onFilterChange;
  const FilterOrder({Key? key, required this.onFilterChange}) : super(key: key);

  @override
  State<FilterOrder> createState() => _FilterOrderState();
}

class _FilterOrderState extends State<FilterOrder> {
  final _formKey = GlobalKey<FormBuilderState>();
  final List<Map<String, dynamic>> _options = [
    {'value': 'all', 'label': 'All'},
    {'value': 'pending', 'label': 'Pending'},
    {'value': 'ordered', 'label': 'Ordered'},
    {'value': 'cancel', 'label': 'Cancel'},
  ];

  void _handleOnChange({String? sortBy}) {
    _formKey.currentState!.save();
    final DateTime selectedDate = _formKey.currentState?.fields['date']?.value;
    final String selectedOption =
        _formKey.currentState?.fields['option']?.value as String;
    String? status = selectedOption != 'all' ? selectedOption : null;
    String date = FormatUtil.formatDate(selectedDate);
    widget.onFilterChange(date: date, status: status, sortBy: sortBy);
  }

  Widget _buildOptions() {
    return FormBuilderRadioGroup(
      name: 'option',
      activeColor: MyColor.primary,
      orientation: OptionsOrientation.horizontal,
      wrapAlignment: WrapAlignment.spaceAround,
      initialValue: 'all',
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.zero, enabledBorder: InputBorder.none),
      options: _options
          .map(
            (op) => FormBuilderFieldOption(
              value: op['value'],
              child: Text(op['label']),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      onChanged: () {
        _handleOnChange();
      },
      child: Container(
        height: 120,
        constraints: BoxConstraints(maxWidth: ScreenUtil.getWidth(context)),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FormBuilderDateTimePicker(
                      name: 'date',
                      decoration: const InputDecoration(
                        prefixIcon: LineIcon.calendar(),
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      initialValue: DateTime.now(),
                      keyboardType: TextInputType.datetime,
                      inputType: InputType.date,
                      format: DateFormat('dd-MM-yyyy'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    // child: ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     shape: const RoundedRectangleBorder(
                    //       borderRadius: BorderRadiusDirectional.all(
                    //         Radius.circular(12),
                    //       ),
                    //     ),
                    //     backgroundColor: MyColor.secondary,
                    //   ),
                    //   onPressed: () {},
                    //   child: const LineIcon.list(
                    //     size: 25,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    child: OrderFilterSort(onFilterChange: _handleOnChange),
                  ),
                ],
              ),
              Expanded(
                child: _buildOptions(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icon.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class FormBooking extends StatefulWidget {
  final FieldModel field;
  final SellerModel seller;
  const FormBooking({super.key, required this.field, required this.seller});

  @override
  State<FormBooking> createState() => _FormBookingState();
}

class _FormBookingState extends State<FormBooking> {
  final _formKey = GlobalKey<FormBuilderState>();
  late FieldModel _field;
  late SellerModel _seller;
  final Logger _logger = Logger();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    _field = widget.field;
    _seller = widget.seller;
  }

  Widget _buildSelectDateTime() {
    return FormBuilder(
      key: _formKey,
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
              hintText: 'Select a date',
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
          const Divider(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: MyColor.background,
            ),
            padding: const EdgeInsets.all(8.0),
            child: TimeRangePicker(
              onStartTimePickChange: (TimeOfDay startTime) {
                setState(() {
                  _startTime = startTime;
                });
              },
              onEndTimePickChange: (endTime) {
                setState(() {
                  _endTime = endTime;
                });
              },
              isHalfHour: _seller.isHalfHour ?? false,
            ),
          )
        ],
      ),
    );
  }

  // Widget _buildPrice() {
  //   if (_startTime == null) return const SizedBox();
  //   return Center(child: ElevatedButton(onPressed: (){}, ),)
  // }
  void _showDialog() {
    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          child: GiffyBottomSheet.image(
            Image.network(
              _field.coverImage ?? '',
              height: 150,
              fit: BoxFit.cover,
            ),
            title: Text(
              _field.name ?? '',
              textAlign: TextAlign.start,
            ),
            content: const SizedBox(
              height: 100,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: ',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text('Time: '),
                    Text('Price: '),
                  ]),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'CANCEL'),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () {
            _showDialog();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColor.primary,
          ),
          child: const Column(
            children: [
              Text(
                'Book',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a time to book a field',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            _buildSelectDateTime(),
            const SizedBox(
              height: 10,
            ),
            _buildButton(),
          ],
        ),
      ),
    );
  }
}

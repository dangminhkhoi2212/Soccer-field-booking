import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
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
  final _orderService = OrderService();
  final _box = GetStorage();
  late FieldModel _field;
  late String? _userID;
  late SellerModel _seller;
  final _format = DateFormat('dd/MM/yyyy');
  final Logger _logger = Logger();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  late double _priceOrder = 0;
  bool _isLoading = false;
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
    _userID = _box.read('id');
  }

  void _calculatePrice() {
    if (_startTime == null || _endTime == null) return;
    int minutes1 = _startTime!.hour * 60 + _startTime!.minute;
    int minutes2 = _endTime!.hour * 60 + _endTime!.minute;

    int minutes = (minutes2 - minutes1).abs();
    double pricePerMinute = _field.price! / 60;
    _priceOrder = pricePerMinute * minutes;
  }

  Widget _buildSelectDateTime() {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          FormBuilderDateTimePicker(
            name: 'date',
            showCursor: true,
            initialValue: DateTime.now(),
            firstDate: DateTime.now(),
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
              onStartTimePickChange: (TimeOfDay? startTime) {
                _logger.d(error: startTime, 'startime');
                setState(() {
                  _startTime = startTime;
                });
              },
              onEndTimePickChange: (TimeOfDay? endTime) {
                _logger.d(error: endTime, 'endTime');

                setState(() {
                  _endTime = endTime;
                  _calculatePrice();
                });
              },
              isHalfHour: _seller.isHalfHour ?? false,
            ),
          )
        ],
      ),
    );
  }

  Future _handlePlace(String date) async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (_userID == null) return;
      Response? response = await _orderService.createOrder(
          userID: _userID!,
          sellerID: _field.userID!,
          date: date,
          fieldID: _field.sId!,
          startTime: '${_startTime!.hour}:${_startTime!.minute}',
          endTime: '${_endTime!.hour}:${_endTime!.minute}',
          total: _priceOrder);
      if (response!.statusCode == 200) {
        Navigator.pop(context, 'CANCEL');
        SnackbarUtil.getSnackBar(
            title: 'Book a field', message: 'Booked successfully');
      }
    } catch (e) {
      _logger.e(error: e, '_handlePlace');
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showDialog() async {
    _formKey.currentState!.save();
    final data = _formKey.currentState!.value;
    if (data['date'] == null) {
      SnackbarUtil.getSnackBar(
          title: 'Booking a field', message: 'Please select a date');
      return;
    }
    final date = _format.format(data['date']);
    if (_startTime == null || _endTime == null) {
      SnackbarUtil.getSnackBar(
          title: 'Booking a field',
          message: 'Please select start time and end time');
      return;
    }

    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(40),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(color: MyColor.primary),
          width: double.infinity,
          child: GiffyBottomSheet(
            contentPadding: EdgeInsets.zero,
            giffyPadding: EdgeInsets.zero,
            giffy:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                clipBehavior: Clip.hardEdge,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        MyImage(
                            width: double.infinity,
                            height: 150,
                            radius: 24,
                            src: _field.coverImage!),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(15),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                              child: Container(
                                decoration: const BoxDecoration(
                                    // color: Colors.white,
                                    ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                child: Text(
                                  _field.name!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Date:  ${date.toString()}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Time:  ${_startTime!.hour}:${_startTime!.minute} - ${_endTime!.hour}:${_endTime!.minute}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Price:  ${FormatUtil.formatNumber(_priceOrder)} VND',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, 'CANCEL'),
                          style: ElevatedButton.styleFrom(
                              elevation: 0, backgroundColor: Colors.white),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black),
                          )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              _handlePlace(date);
                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: MyColor.secondary),
                            child: const Text(
                              'Place',
                              style: TextStyle(color: Colors.black),
                            )))
                  ],
                ),
              ),
            ]),
            scrollable: true,
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

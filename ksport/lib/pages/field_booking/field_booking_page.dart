import 'package:client_app/pages/field_booking/widget/feedback_info.dart';
import 'package:client_app/pages/field_booking/widget/field_info.dart';
import 'package:client_app/pages/field_booking/widget/form_booking.dart';
import 'package:client_app/pages/field_booking/widget/seller_info_booking.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class FieldBooking extends StatefulWidget {
  const FieldBooking({
    super.key,
  });

  @override
  State<FieldBooking> createState() => _FieldBookingState();
}

class _FieldBookingState extends State<FieldBooking> {
  final UserService _userService = UserService();
  final SellerService _sellerService = SellerService();
  final AddressService _addressService = AddressService();
  final FeedbackService _feedbackService = FeedbackService();
  FieldModel? _field;
  UserModel? _user;
  SellerModel? _seller;
  AddressModel? _address;
  StatisticFeedbackModel? _statistic = StatisticFeedbackModel();
  late String? _sellerID;
  late String? _fieldID;
  final _logger = Logger();
  bool _isLoading = false;
  String? _title;
  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    _sellerID = Get.parameters['sellerID'];
    _fieldID = Get.parameters['fieldID'];
    _initValue();
  }

  Future _getUser() async {
    try {
      Response? response = await _userService.getOneUser(userID: _sellerID);
      if (response!.statusCode == 200) {
        final data = response.data;
        _user = UserModel.fromJson(data);
      }
    } catch (e) {
      _logger.e(error: e, '_getUser');
    }
  }

  Future _getSeller() async {
    try {
      Response? response = await _sellerService.getOneSeller(userID: _sellerID);
      if (response!.statusCode == 200) {
        final data = response.data;
        _seller = SellerModel.fromJson(data);
      }
    } catch (e) {
      _logger.e(error: e, '_getSeller');
    }
  }

  Future _getAddress() async {
    try {
      Response? response = await _addressService.getAddress(userID: _sellerID);
      if (response!.statusCode == 200) {
        final data = response.data;

        _address = AddressModel.fromJson(data);
      }
    } catch (e) {
      _logger.e(error: e, '_getAddress');
    }
  }

  Future _getStatisticFeedback() async {
    try {
      Response? response =
          await _feedbackService.getStatisticFeedback(fieldID: _fieldID);
      if (response!.statusCode == 200) {
        final data = response.data;
        _statistic = StatisticFeedbackModel.fromJson(data);
      }
    } catch (e) {
      _logger.e(e, error: '_getStatisticFeedback');
    }
  }

  Future _getField() async {
    try {
      final Response? response =
          await FieldService().getOneSoccerField(fieldID: _fieldID!);
      if (response!.statusCode == 200) {
        final data = response.data;
        _field = FieldModel.fromJson(data);
        _title = _field!.name!;
      }
    } catch (e) {
      _logger.e(error: e, '_getFieldData');
    }
  }

  Future _initValue() async {
    setState(() {
      _isLoading = true;
    });
    await Future.wait([
      _getField(),
      _getAddress(),
      _getUser(),
      _getSeller(),
      _getStatisticFeedback()
    ]);
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: MyLoading.spinkit(),
      );
    }
    if (_sellerID == null || _fieldID == null || _field == null) {
      return const Center(
        child: Text("Can not find this field"),
      );
    }

    return SingleChildScrollView(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        FieldInfo(field: _field!),
        SellerInfoBooking(
          user: _user!,
          address: _address!,
        ),
        FormBooking(
          field: _field!,
          seller: _seller!,
        ),
        FeedbackField(
          fieldID: _fieldID!,
          statistic: _statistic!,
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColor.background,
        appBar: AppBar(title: Text(_title ?? '')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildBody(),
        ));
  }
}

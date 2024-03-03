import 'package:client_app/pages/field_booking/widget/feedback.dart';
import 'package:client_app/pages/field_booking/widget/field_info.dart';
import 'package:client_app/pages/field_booking/widget/form_booking.dart';
import 'package:client_app/pages/field_booking/widget/seller_info_booking.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
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
  FieldModel? _field;
  UserModel? _user;
  SellerModel? _seller;
  AddressModel? _address;
  late String? _userID;
  late String? _fieldID;
  final _logger = Logger();
  bool _isLoading = false;
  String _title = 'Loading...';
  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    _userID = Get.parameters['userID'];
    _fieldID = Get.parameters['fieldID'];
    _logger.d(_userID);
    _initValue();
  }

  Future _getUser() async {
    try {
      Response? response = await _userService.getOneUser(userID: _userID);
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
      Response? response = await _sellerService.getOneSeller(userID: _userID);
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
      Response? response = await _addressService.getAddress(userID: _userID);
      if (response!.statusCode == 200) {
        final data = response.data;

        _address = AddressModel.fromJson(data);
      }
    } catch (e) {
      _logger.e(error: e, '_getAddress');
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
    await Future.wait([_getField(), _getAddress(), _getUser(), _getSeller()]);
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildBody() {
    if (_userID == null || _fieldID == null || _field == null) {
      return const Center(
        child: Text("Can not find this field"),
      );
    }

    if (_isLoading) {
      return Center(
        child: MyLoading.spinkit(),
      );
    }
    return SingleChildScrollView(
      child: Column(children: [
        Container(
            padding: const EdgeInsets.all(8), child: FieldInfo(field: _field!)),
        Container(
            padding: const EdgeInsets.all(8),
            child: SellerInfoBooking(
              user: _user!,
              address: _address!,
            )),
        Container(
          padding: const EdgeInsets.all(8),
          child: FormBooking(
            field: _field!,
            seller: _seller!,
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: const FeedbackField(),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: MyColor.background,
          appBar: AppBar(title: Text(_title)),
          body: _buildBody()),
    );
  }
}

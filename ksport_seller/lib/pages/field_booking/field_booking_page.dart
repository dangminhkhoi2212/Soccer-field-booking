import 'package:ksport_seller/config/api_config.dart';
import 'package:ksport_seller/pages/field_booking/widget/feedback_info.dart';
import 'package:ksport_seller/pages/field_booking/widget/field_info.dart';
import 'package:ksport_seller/pages/field_booking/widget/form_booking.dart';

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
  final UserService _userService = UserService(ApiConfig().dio);
  final SellerService _sellerService = SellerService(ApiConfig().dio);
  final AddressService _addressService = AddressService(ApiConfig().dio);
  final FeedbackService _feedbackService = FeedbackService(ApiConfig().dio);
  final FieldService _fieldService = FieldService(ApiConfig().dio);
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
      Response response = await _userService.getOneUser(userID: _sellerID);
      if (response.statusCode == 200) {
        final data = response.data;
        _user = UserModel.fromJson(data);
      }
    } on DioException catch (e) {
      HandleError(titleDebug: '_getUser', messageDebug: e.response!.data ?? e);
    } catch (e) {
      _logger.e(e, error: _getUser);
    }
  }

  Future _getSeller() async {
    try {
      Response response = await _sellerService.getOneSeller(userID: _sellerID);
      if (response.statusCode == 200) {
        final data = response.data;
        _seller = SellerModel.fromJson(data);
      }
    } on DioException catch (e) {
      HandleError(
          titleDebug: '_getSeller', messageDebug: e.response!.data ?? e);
    } catch (e) {
      _logger.e(e, error: '_getSeller');
    }
  }

  Future _getAddress() async {
    try {
      Response response =
          await _addressService.getOneAddress(userID: _sellerID!);
      if (response.statusCode == 200) {
        final data = response.data;

        _address = AddressModel.fromJson(data);
      }
    } on DioException catch (e) {
      HandleError(
          titleDebug: '_getAddress', messageDebug: e.response!.data ?? e);
    } catch (e) {
      _logger.e(e, error: '_getAddress');
    }
  }

  Future _getStatisticFeedback() async {
    try {
      Response response =
          await _feedbackService.getStatisticFeedback(fieldID: _fieldID);
      if (response.statusCode == 200) {
        final data = response.data;
        _statistic = StatisticFeedbackModel.fromJson(data);
      }
    } on DioException catch (e) {
      HandleError(
          titleDebug: '_getStatisticFeedback',
          messageDebug: e.response!.data ?? e);
    } catch (e) {
      _logger.e(e, error: '_getStatisticFeedback');
    }
  }

  Future _getField() async {
    try {
      final Response response =
          await _fieldService.getOneSoccerField(fieldID: _fieldID!);
      if (response.statusCode == 200) {
        final data = response.data;
        _field = FieldModel.fromJson(data);
        _title = _field!.name!;
      }
    } on DioException catch (e) {
      HandleError(titleDebug: '_getField', messageDebug: e.response!.data ?? e);
    } catch (e) {
      _logger.e(e, error: '_getField');
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

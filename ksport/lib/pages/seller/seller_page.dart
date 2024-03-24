// import 'package:client_app/pages/seller/widget/field_list.dart';
// import 'package:client_app/pages/seller/widget/owner_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({super.key});

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  String? _userID;
  String _titleBar = '';
  final Logger _logger = Logger();
  bool _isLoading = false;
  final UserService _userService = UserService();
  final SellerService _sellerService = SellerService();
  final AddressService _addressService = AddressService();
  UserModel? _user;
  SellerModel? _seller;
  AddressModel? _address;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userID = Get.parameters['userID'];
    _initValue();
  }

  Future _getUser() async {
    try {
      Response? response = await _userService.getOneUser(userID: _userID);
      if (response!.statusCode == 200) {
        final data = response.data;
        _user = UserModel.fromJson(data);
        _titleBar = _user?.name ?? '';
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

  Future _initValue() async {
    setState(() {
      _isLoading = true;
    });
    await Future.wait([_getAddress(), _getUser(), _getSeller()]);
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
    if (_user == null) {
      return const Center(
        child: Text('Don not find this owner'),
      );
    }
    return Column(
      children: [
        InfoOwner(
          user: _user!,
          seller: _seller!,
          address: _address!,
        ), // Removed Expanded wrapper
        const SizedBox(height: 20), // Added spacing between widgets
        SoccerFieldList(
            userID: _user!.sId ?? '',
            isOnTap: true), // Removed Expanded wrapper
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(240, 255, 255, 255),
        appBar: AppBar(
          title: Text(_titleBar),
        ),
        body: Container(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
                clipBehavior: Clip.hardEdge,
                primary: true,
                child: _buildBody())));
  }
}

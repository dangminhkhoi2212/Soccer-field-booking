import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:ksport_seller/config/api_config.dart';
import 'package:ksport_seller/pages/profile/widgets/appbar_profile.dart';
import 'package:ksport_seller/pages/profile/widgets/drawer_profile.dart';
import 'package:ksport_seller/pages/profile/widgets/soccer_field_list.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _userID;
  String _titleBar = '';
  final ApiConfig apiConfig = ApiConfig();
  final _box = GetStorage();
  final Logger _logger = Logger();
  bool _isLoading = false;
  late UserService _userService;
  late SellerService _sellerService;
  late AddressService _addressService;
  UserModel? _user;
  SellerModel? _seller;
  AddressModel? _address;
  @override
  void initState() {
    super.initState();
    _userService = UserService(apiConfig.dio);
    _sellerService = SellerService(apiConfig.dio);
    _addressService = AddressService(apiConfig.dio);
    _userID = _box.read('id');
    _initValue();
    test();
  }

  Future test() async {
    try {
      final Position? position = await GoogleMapService().determinePosition();

      double lat = position!.latitude;
      double long = position.longitude;

      _logger.i(lat.toString());
      _logger.i(long.toString());
      final String? address = await GoogleMapService()
          .getAddressFromLatLng(latitude: lat, longitude: long);

      _logger.i(address.toString());
    } catch (e) {
      _logger.e(e);
    }
  }

  Future _getUser() async {
    try {
      Response? response = await _userService.getOneUser(userID: _userID);
      if (response.statusCode == 200) {
        final data = response.data;
        _user = UserModel.fromJson(data);
        _titleBar = _user?.name ?? '';
      }
    } on DioException catch (e) {
      if (mounted) {
        HandleError(
            titleDebug: '_getUser',
            messageDebug: e.response!.data ?? e.message);
      }
    } catch (e) {
      _logger.e(error: e, '_getUser');
    }
  }

  Future _getSeller() async {
    try {
      Response? response = await _sellerService.getOneSeller(userID: _userID);
      if (response.statusCode == 200) {
        final data = response.data;
        _seller = SellerModel.fromJson(data);
      }
    } on DioException catch (e) {
      if (mounted) {
        HandleError(
            titleDebug: '_getSeller',
            messageDebug: e.response!.data ?? e.message);
      }
    } catch (e) {
      _logger.e(error: e, '_getSeller');
    }
  }

  Future _getAddress() async {
    try {
      Response response = await _addressService.getOneAddress(userID: _userID!);
      if (response.statusCode == 200) {
        final data = response.data;

        _address = AddressModel.fromJson(data);
      }
    } on DioException catch (e) {
      if (mounted) {
        HandleError(
            titleDebug: '_getAddress',
            messageDebug: e.response!.data ?? e.message);
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
        ), // Removed Expanded wrapper
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: const DrawerProfile(),
        backgroundColor: MyColor.background,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60.0), child: AppBarProfile()),
        body: Container(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(child: _buildBody())));
  }
}

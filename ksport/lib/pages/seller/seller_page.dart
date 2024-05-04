// import 'package:client_app/pages/seller/widget/field_list.dart';
// import 'package:client_app/pages/seller/widget/owner_info.dart';
import 'package:client_app/config/api_config.dart';
import 'package:client_app/pages/seller/widget/soccer_field_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({super.key});

  @override
  State<SellerPage> createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  String? _userIDSeller;
  late String _userID;
  String _titleBar = '';
  final Logger _logger = Logger();
  bool _isLoading = false;
  final ApiConfig apiConfig = ApiConfig();
  late UserService _userService;
  late SellerService _sellerService;
  late AddressService _addressService;
  late FavoriteService _favoriteService;
  UserModel? _userSeller;
  SellerModel? _seller;
  AddressModel? _address;
  bool? _isFavorite;
  final _box = GetStorage();
  @override
  void initState() {
    super.initState();
    _userService = UserService(apiConfig.dio);
    _sellerService = SellerService(apiConfig.dio);
    _addressService = AddressService(apiConfig.dio);
    _favoriteService = FavoriteService(apiConfig.dio);
    _userIDSeller = Get.parameters['userIDSeller'];
    _userID = _box.read('id');
    _initValue();
  }

  Future _checkFavorite() async {
    try {
      final Response response = await _favoriteService.checkFavorite(
          userID: _userID, sellerID: _userIDSeller!);
      if (response.statusCode == 200) {
        _logger.d(response.data);
        final data = CheckFavoriteModel.fromJson(response.data);
        _isFavorite = data.isFavorite;
      }
    } on DioException catch (e) {
      if (mounted) {
        HandleError(
            titleDebug: '_checkFavorite',
            messageDebug: e.response!.data ?? e.message);
      }
    } catch (e) {
      _logger.e(e, error: '_checkFavorite');
    }
  }

  Future _handleFavorite() async {
    try {
      final Response response = await _favoriteService.handelFavorite(
          userID: _userID, sellerID: _userIDSeller!);
      if (response.statusCode == 200) {
        final data = FavoriteStatusModel.fromJson(response.data);
        setState(() {
          _isFavorite = data.isFavorite;
        });
      }
    } on DioException catch (e) {
      if (mounted) {
        HandleError(
            titleDebug: '_checkFavorite',
            messageDebug: e.response!.data ?? e.message);
      }
    } catch (e) {
      _logger.e(e, error: '_checkFavorite');
    }
  }

  Future _getUser() async {
    try {
      Response? response = await _userService.getOneUser(userID: _userIDSeller);
      if (response.statusCode == 200) {
        final data = response.data;
        _userSeller = UserModel.fromJson(data);
        _titleBar = _userSeller?.name ?? '';
      }
    } on DioException catch (e) {
      if (mounted) {
        HandleError(
            titleDebug: '_getUser',
            messageDebug: e.response!.data ?? e.message);
      }
    } catch (e) {
      _logger.e(e, error: '_getUser');
    }
  }

  Future _getSeller() async {
    try {
      Response? response =
          await _sellerService.getOneSeller(userID: _userIDSeller);
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
      _logger.e(e, error: '_getSeller');
    }
  }

  Future _getAddress() async {
    try {
      Response? response =
          await _addressService.getOneAddress(userID: _userIDSeller!);
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
      _logger.e(e, error: '_getAddress');
    }
  }

  Future _initValue() async {
    setState(() {
      _isLoading = true;
    });
    await Future.wait(
        [_getAddress(), _getUser(), _getSeller(), _checkFavorite()]);
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
    if (_userSeller == null) {
      return const Center(
        child: Text('Don not find this owner'),
      );
    }
    return Column(
      children: [
        InfoOwner(
          user: _userSeller!,
          seller: _seller!,
          address: _address!,
          isFavorite: _isFavorite,
          opTap: _handleFavorite,
        ), // Removed Expanded wrapper
        const SizedBox(height: 20), // Added spacing between widgets
        SoccerFieldList(
            userID: _userSeller!.sId ?? '',
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

class CheckFavoriteModel {
  bool? isFavorite;

  CheckFavoriteModel({this.isFavorite});

  CheckFavoriteModel.fromJson(Map<String, dynamic> json) {
    isFavorite = json['isFavorite']!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isFavorite'] = isFavorite;
    return data;
  }
}

class FavoriteStatusModel {
  String? status;
  bool? isFavorite;

  FavoriteStatusModel({this.status, this.isFavorite});

  FavoriteStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['isFavorite'] = isFavorite;
    return data;
  }
}

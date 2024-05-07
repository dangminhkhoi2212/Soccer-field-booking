import 'package:client_app/config/api_config.dart';
import 'package:client_app/pages/seller_list/state/seller_list_state.dart';
import 'package:client_app/pages/seller_list/widget/seller_card.dart';
import 'package:dio/dio.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class SellerList extends StatefulWidget {
  const SellerList({super.key});

  @override
  State<SellerList> createState() => _SellerListState();
}

class _SellerListState extends State<SellerList> {
  List<UserModel?> _sellerList = [];
  final UserService _userService = UserService(ApiConfig().dio);
  final Logger _logger = Logger();
  final SellerListState sellerListState = Get.put(SellerListState());

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    sellerListState.textSearch.listen((value) {
      _logger.d(value);
      if (value.isNotEmpty) {
        _getSellers(value);
      }
    });
    _getSellers(null);
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<SellerListState>();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  Future _getSellers(String? textSearch) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final Response response =
          await _userService.getUsers(role: 'seller', textSearch: textSearch);
      if (response.statusCode == 200) {
        final List data = response.data;

        _sellerList = data.map((seller) {
          final temp = UserModel.fromJson(seller!);
          return temp;
        }).toList();
      }
    } on DioException catch (e) {
      _logger.e(e.response!.data, error: 'Error _getSellers');

      SnackbarUtil.getSnackBar(title: 'Error', message: "Can't get users");
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      Center(
        child: MyLoading.spinkit(),
      );
    }
    if (_sellerList.isEmpty) {
      return EmptyWidget(
        packageImage: PackageImage.Image_2,
        hideBackgroundAnimation: true,
        subTitle: 'Not found',
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      itemCount: _sellerList.length,
      itemBuilder: (context, index) {
        return SellerCard(seller: _sellerList[index]!);
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 2,
      ),
    );
  }
}

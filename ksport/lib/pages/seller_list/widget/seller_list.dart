import 'package:client_app/config/api_config.dart';
import 'package:client_app/pages/seller_list/widget/seller_card.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _getSellers();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  Future _getSellers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final Response response = await _userService.getUsers(
        select: '_id name avatar',
        role: 'seller',
      );
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

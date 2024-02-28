import 'package:dio/src/response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:logger/logger.dart';
import 'package:widget_component/const/colors.dart';
import 'package:widget_component/services/service_user.dart';
import 'package:widget_component/utils/loading.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userID = Get.parameters['userID'];
    _logger.i(_userID);
    _getSeller();
  }

  Future _getSeller() async {
    try {
      if (!mounted && _userID == null) return;
      setState(() {
        _isLoading = true;
      });
      Response? response = await UserService().getUser(userID: _userID);
      if (response!.statusCode == 200) {}
      final dynamic data = response.data;
      _titleBar = data['name'];
      setState(() {});
    } catch (e) {}
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleBar),
      ),
      body: _isLoading
          ? Center(
              child: MyLoading.spinkit(),
            )
          : Container(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: MyColor.third,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

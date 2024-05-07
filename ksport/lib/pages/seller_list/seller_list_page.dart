import 'package:client_app/pages/seller_list/state/seller_list_state.dart';
import 'package:client_app/pages/seller_list/widget/filter_seller_list.dart';
import 'package:client_app/pages/seller_list/widget/seller_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class SellerListPage extends StatefulWidget {
  const SellerListPage({super.key});

  @override
  State<SellerListPage> createState() => _SellerListPageState();
}

class _SellerListPageState extends State<SellerListPage> {
  final _logger = Logger();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.background,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: const Column(
          children: [
            FilterSellerList(),
            SizedBox(
              height: 10,
            ),
            Expanded(child: SellerList()),
          ],
        ),
      ),
    );
  }
}

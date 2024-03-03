import 'package:client_app/pages/seller_list/widget/filter_seller_list.dart';
import 'package:client_app/pages/seller_list/widget/seller_list.dart';
import 'package:flutter/material.dart';
import 'package:widget_component/const/colors.dart';

class SellerListPage extends StatefulWidget {
  const SellerListPage({super.key});

  @override
  State<SellerListPage> createState() => _SellerListPageState();
}

class _SellerListPageState extends State<SellerListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: MyColor.background,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: const Column(
          children: [
            FilterSellerList(),
            SizedBox(
              height: 10,
            ),
            Flexible(child: SellerList()),
          ],
        ),
      ),
    );
  }
}

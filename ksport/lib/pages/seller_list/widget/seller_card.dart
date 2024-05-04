import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:widget_component/my_library.dart';

class SellerCard extends StatelessWidget {
  final UserModel seller;
  const SellerCard({super.key, required this.seller});

  Widget _buildInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            seller.name ?? '',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Text(
            'Fields: ${seller.fieldCount.toString()}',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.toNamed(RoutePaths.seller,
              parameters: {'userIDSeller': seller.sId!});
        },
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              MyImage(
                width: 60,
                height: 60,
                src: seller.avatar ?? '',
                isAvatar: true,
              ),
              const SizedBox(
                width: 20,
              ),
              _buildInfo(),
            ],
          ),
        ),
      ),
    );
  }
}

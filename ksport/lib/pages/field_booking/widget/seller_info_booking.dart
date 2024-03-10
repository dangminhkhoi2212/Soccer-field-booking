import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:widget_component/my_library.dart';

class SellerInfoBooking extends StatelessWidget {
  final UserModel user;
  final AddressModel address;
  const SellerInfoBooking(
      {super.key, required this.user, required this.address});
  Widget _buildTextField() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.name!,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(
            address.address!,
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyImage(
              width: 60,
              height: 60,
              src: user.avatar ?? "",
              radius: 12,
              isAvatar: true,
            ),
            const SizedBox(
              width: 10,
            ),
            _buildTextField(),
            ElevatedButton(
              onPressed: () {
                Get.offNamed(RoutePaths.seller,
                    parameters: {'userID': user.sId!});
              },
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                  backgroundColor: MyColor.primary),
              child: const LineIcon.store(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

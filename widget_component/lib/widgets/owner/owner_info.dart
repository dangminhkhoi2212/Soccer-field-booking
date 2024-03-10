import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:widget_component/my_library.dart';

class InfoOwner extends StatelessWidget {
  final UserModel user;
  final SellerModel seller;
  final AddressModel address;
  const InfoOwner(
      {super.key,
      required this.user,
      required this.seller,
      required this.address});

  Widget _buildTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.name ?? '',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const LineIcon.envelope(),
            const SizedBox(
              width: 10,
            ),
            Text(
              user.email ?? '',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          children: [
            const LineIcon.mobilePhone(),
            const SizedBox(
              width: 10,
            ),
            Text(
              user.phone ?? '',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const LineIcon.mapMarker(),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                address.address ?? '',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const LineIcon.clock(),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                '${seller.startTime} - ${seller.endTime}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyImage(
                  width: double.infinity,
                  height: 150,
                  src: user.avatar ?? "",
                  radius: 12,
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildTextField(),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.zero,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                  ),
                  child: const LineIcon.heart(
                    color: Colors.black,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

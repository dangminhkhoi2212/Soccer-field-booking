import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:widget_component/my_library.dart';
import 'package:intl/intl.dart';

class OrderInfo extends StatelessWidget {
  final OrderModel order;
  const OrderInfo({super.key, required this.order});

  Color _colorStatus(status) {
    switch (status) {
      case 'ordered':
        return MyColor.primary.withOpacity(0.8);
      case 'cancel':
        return Colors.red.shade200;
      default:
        return MyColor.fourth;
    }
  }

  Widget _buildStatus() {
    String status = order.status![0].toUpperCase() + order.status!.substring(1);
    return Card(
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
            color: _colorStatus(
              order.status!,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text('This order status: $status',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _buildTextField(String name, String email, String phone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name ?? '',
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
              email ?? '',
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
              phone ?? '',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    DateTime dateTime = DateTime.parse(order.createdAt!);

    String formattedDate = DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                MyImage(
                  width: 60,
                  height: 60,
                  src: order.userID!.avatar! ?? '',
                  isAvatar: true,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1), // Adjust column widths as needed
                1: FlexColumnWidth(2),
              },
              children: [
                _buildTableRow('Name:', order.userID!.name ?? ''),
                _buildTableRow('Email:', order.userID!.email ?? ''),
                _buildTableRow('Phone:', order.userID!.phone ?? ''),
                _buildTableRow('Date order:', formattedDate),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldInfo() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: MyImage(
                    width: double.infinity,
                    height: 150,
                    radius: 12,
                    src: order.fieldID!.coverImage! ?? '',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1), // Adjust column widths as needed
                1: FlexColumnWidth(2),
              },
              children: [
                _buildTableRow('Field name:', order.fieldID!.name! ?? ''),
                _buildTableRow('Date:', order.date! ?? ''),
                _buildTableRow(
                    'Time:', '${order.startTime} - ${order.endTime}'),
                _buildTableRow(
                    'Total:', '${FormatUtil.formatNumber(order.total!)} VND'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatus(),
        _buildUserInfo(),
        _buildFieldInfo(),
      ],
    );
  }
}

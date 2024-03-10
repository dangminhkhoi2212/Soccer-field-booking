import 'package:flutter/material.dart';
import 'package:widget_component/my_library.dart';

class OrderCard extends StatelessWidget {
  final String fieldName;
  final String startTime;
  final String endTime;
  final String date;
  final double total;
  final String status;
  final VoidCallback onTap;

  const OrderCard(
      {super.key,
      required this.fieldName,
      required this.startTime,
      required this.endTime,
      required this.date,
      required this.total,
      required this.status,
      required this.onTap});
  Color _colorStatus() {
    switch (status) {
      case 'ordered':
        return MyColor.primary.withOpacity(0.8);
      case 'cancel':
        return Colors.red.shade400;
      default:
        return MyColor.fourth;
    }
  }

  Widget _buildText({
    required String title,
    required String text,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 10),
        Text(text)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(
                  fieldName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                )),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  decoration: BoxDecoration(
                      color: _colorStatus(),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Text(status),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(3),
                },
                children: [
                  buildTableRow('Date ', date),
                  buildTableRow('Time ', '$startTime - $endTime'),
                  buildTableRow(
                      'Total', '${FormatUtil.formatNumber(total)} VND'),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _buildButton(),
          ],
        ));
  }

  TableRow buildTableRow(String label, String value) {
    return TableRow(children: [
      Text(
        label,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
      ),
      Text(
        value,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    ]);
  }

  Widget _buildButton() {
    return ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: MyColor.primary.withOpacity(.2),
          alignment: Alignment.centerRight),
      child: const Text(
        'View detail',
        style: TextStyle(
            color: MyColor.primary, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}

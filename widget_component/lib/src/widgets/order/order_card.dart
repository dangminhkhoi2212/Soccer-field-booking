import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:widget_component/my_library.dart';

class OrderCard extends StatelessWidget {
  final String fieldName;
  final String startTime;
  final String endTime;
  final String date;
  final double total;
  final String status;
  final String coverImage;
  final VoidCallback onTap;

  const OrderCard(
      {super.key,
      required this.fieldName,
      required this.startTime,
      required this.endTime,
      required this.date,
      required this.total,
      required this.status,
      required this.onTap,
      required this.coverImage});
  Color _colorStatus() {
    switch (status) {
      case 'ordered':
        return MyColor.primary.withOpacity(0.4);
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
                    child: Row(
                  children: [
                    MyImage(
                      width: 80,
                      height: 50,
                      src: coverImage,
                      radius: 6,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      fieldName,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                )),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  decoration: BoxDecoration(
                      color: _colorStatus(),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    status,
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
              },
              children: [
                buildTableRow('Date ', FormatUtil.formatISOtoDate(date)),
                buildTableRow('Time ',
                    '${FormatUtil.formatISOtoTime(startTime)} - ${FormatUtil.formatISOtoTime(endTime)} '),
                buildTableRow('Total', '${FormatUtil.formatNumber(total)} VND'),
              ],
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
            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
      ),
      Text(
        value,
        style: const TextStyle(
          fontSize: 14,
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
          // backgroundColor: MyColor.primary.withOpacity(.2),
          alignment: Alignment.centerRight),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'View detail',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          LineIcon.arrowRight()
        ],
      ),
    );
  }
}

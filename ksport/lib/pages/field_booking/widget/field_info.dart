import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:widget_component/my_library.dart';

class FieldInfo extends StatelessWidget {
  final FieldModel field;
  const FieldInfo({super.key, required this.field});
  Widget _buildWidthLength() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              const LineIcon.alternateArrowsHorizontal(),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Width: ${FormatUtil.formatNumber(field.width!.toInt())} m',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: Row(
            children: [
              const LineIcon.alternateArrowsVertical(),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Length: ${FormatUtil.formatNumber(field.length!.toInt())} m',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.name ?? '',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        _buildWidthLength(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const LineIcon.tag(),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                'Type: ${field.type} people',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const LineIcon.moneyBill(),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                'Price: ${FormatUtil.formatNumber(field.price!.toInt())} VND/hour',
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
                  src: field.coverImage ?? "",
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

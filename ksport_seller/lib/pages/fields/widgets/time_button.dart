import 'package:flutter/material.dart';
import 'package:widget_component/const/colors.dart';

class TimeButton extends StatelessWidget {
  final Map<String, dynamic> timeItem;
  final VoidCallback onTap;

  const TimeButton({
    required this.timeItem,
    required this.onTap,
    Key? key,
  }) : super(key: key);
  Color _buildColor() {
    if (timeItem['active']) return MyColor.fourth;
    if (timeItem['disable']) return Colors.grey;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: timeItem['disable'] ? null : onTap,
      child: Container(
        width: 55,
        height: 40,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: _buildColor(),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        child: Center(
          child: Text(
            '${timeItem['time'].hour}:${timeItem['time'].minute}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

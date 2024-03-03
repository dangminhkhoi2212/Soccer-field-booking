import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:widget_component/my_library.dart';

class FeedbackField extends StatefulWidget {
  const FeedbackField({super.key});

  @override
  State<FeedbackField> createState() => _FieldInfoState();
}

class _FieldInfoState extends State<FeedbackField> {
  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Feedback',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

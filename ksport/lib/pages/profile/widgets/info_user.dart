import 'package:flutter/material.dart';

class InfoUser extends StatelessWidget {
  const InfoUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildText(number: '4242', title: 'Favorites'),
        ),
        Expanded(
          child: _buildText(number: '3113', title: 'Fields'),
        ),
        Expanded(
          child: _buildText(number: '1', title: 'Ratings'),
        )
      ],
    );
  }

  Column _buildText({required String number, required String title}) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(title),
      ],
    );
  }
}

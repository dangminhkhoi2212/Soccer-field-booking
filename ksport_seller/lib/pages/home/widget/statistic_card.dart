import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:ksport_seller/pages/home/home_page.dart';
import 'package:widget_component/my_library.dart';

class StatisticCard extends StatelessWidget {
  final TotalFieldsModel? totalFields;
  const StatisticCard({super.key, required this.totalFields});

  @override
  Widget build(BuildContext context) {
    if (totalFields == null) {
      return Container();
    }
    return Column(
      children: [
        Row(
          children: [
            _buildCard(
                title: 'Total revenue',
                value:
                    FormatUtil.formatNumber(totalFields!.totalRevenue! ?? 0) +
                        ' VND'),
            _buildCard(
                title: 'Fields',
                value: FormatUtil.formatNumber(totalFields!.totalField!)),
          ],
        ),
        Row(
          children: [
            _buildCard(
                title: 'Followers',
                value: FormatUtil.formatNumber(totalFields!.totalFollow!)),
            _buildCard(
                title: 'Order',
                value: FormatUtil.formatNumber(totalFields!.totalOrder!)),
          ],
        )
      ],
    );
  }

  Expanded _buildCard({required String title, required String value}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          )
        ]),
      ),
    );
  }
}

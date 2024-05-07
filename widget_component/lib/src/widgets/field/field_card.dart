import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:widget_component/my_library.dart';

class FieldCard extends StatelessWidget {
  final FieldModel field;
  final Function onTap;
  final bool isSeller;

  const FieldCard(
      {Key? key,
      required this.field,
      required this.onTap,
      this.isSeller = false})
      : super(key: key);

  TableRow _buildTableRow(String label, String value) {
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

  Widget _buildStar() {
    return Row(
      children: [
        RatingBar.builder(
          initialRating: field.avgStar ?? 5,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          ignoreGestures: true,
          itemCount: 5,
          itemPadding: EdgeInsets.zero,
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemSize: 20,
          onRatingUpdate: (rating) {},
        ),
        const SizedBox(
          width: 5,
        ),
        Text('${field.avgStar ?? 5}')
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
          Radius.circular(12),
        )
            // border: Border.all(
            //     color: Colors.green,
            //     ),
            ),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: MyImage(
                          width: double.infinity,
                          height: double.infinity,
                          src: field.coverImage ?? '')),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Table(columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(2)
                        }, children: [
                          _buildTableRow('Price',
                              '${FormatUtil.formatNumber(field.price!).toString()} vnd'),
                          _buildTableRow('Width',
                              '${FormatUtil.formatNumber(field.width!).toString()} m'),
                          _buildTableRow('Length',
                              '${FormatUtil.formatNumber(field.length!).toString()} m'),
                        ]),
                        _buildStar()
                      ],
                    ),
                  ),
                ],
              ),
            ),
            isSeller
                ? Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: IconButton(
                          onPressed: () {
                            Get.toNamed(RoutePaths.updateField,
                                parameters: {'fieldID': field.sId!});
                          },
                          icon: const LineIcon.pen()),
                    ))
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}

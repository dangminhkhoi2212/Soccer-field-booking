import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widget_component/const/colors.dart';
import 'package:widget_component/utils/format.dart';
import 'package:widget_component/widgets/my_image/my_image.dart';

class FieldCard extends StatelessWidget {
  final Map<String, dynamic> field;
  final Function onTap;

  const FieldCard({Key? key, required this.field, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: MyColor.secondary,
                blurRadius: 8,
                offset: Offset(1, 1),
              ),
            ],
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            )
            // border: Border.all(
            //     color: Colors.green,
            //     ),
            ),
        child: Container(
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
                      src: field['coverImage'] ?? '')),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      field['name'] ?? '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                        'Price: ${FormatUtil.formatNumber(field['price']).toString()} vnd'),
                    Text(
                        'Width: ${FormatUtil.formatNumber(field['width']).toString()} m'),
                    Text(
                        'Length: ${FormatUtil.formatNumber(field['length']).toString()} m'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

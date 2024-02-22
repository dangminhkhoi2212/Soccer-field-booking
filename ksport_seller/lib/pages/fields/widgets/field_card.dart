import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ksport_seller/const/colors.dart';
import 'package:ksport_seller/routes/route_path.dart';
import 'package:ksport_seller/utils/format.dart';

class FieldCard extends StatelessWidget {
  final Map<String, dynamic> field;

  const FieldCard({Key? key, required this.field}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RoutePaths.addField,
            parameters: {'fieldID': field['_id'].toString()});
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
                child: SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Center(
                      child: FadeInImage(
                        placeholder: const AssetImage(
                          'assets/images/loading.gif',
                        ),
                        image: NetworkImage(field['coverImage']),
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/images/image_error.png'),
                      ),
                    ),
                  ),
                ),
              ),
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

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:line_icons/line_icon.dart';

class FilterSellerList extends StatefulWidget {
  const FilterSellerList({super.key});

  @override
  State<FilterSellerList> createState() => _FilterSellerListState();
}

class _FilterSellerListState extends State<FilterSellerList> {
  final _formKey = GlobalKey<FormBuilderState>();
  final SearchController controller = SearchController();
  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (context, controller) {
        return ElevatedButton(
            onPressed: () {
              controller.openView();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, elevation: 0),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Search'), Icon(Icons.search)],
            ));
      },
      isFullScreen: false,
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return List<ListTile>.generate(5, (int index) {
          final String item = 'item $index';
          return ListTile(
            title: Text(item),
            onTap: () {
              setState(() {
                controller.closeView(item);
              });
            },
          );
        });
      },
    );
    return Card(
      elevation: 0,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FormBuilder(
              key: _formKey,
              child: FormBuilderTextField(
                name: 'search',
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  prefixIcon: const LineIcon.search(),
                  hintText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            const Divider(
              height: 20,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     Expanded(
            //       child: InkWell(
            //         borderRadius: BorderRadius.circular(10),
            //         onTap: () {
            //           // Xử lý khi nhấp vào
            //         },
            //         child: Ink(
            //           decoration: BoxDecoration(
            //             color: Colors.grey[200],
            //             borderRadius: BorderRadius.circular(10),
            //           ),
            //           child: Container(
            //               padding: const EdgeInsets.symmetric(
            //                   vertical: 8, horizontal: 15),
            //               child: const Row(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     LineIcon.alternateArrowsVertical(size: 18),
            //                     SizedBox(width: 10),
            //                     Text('Name')
            //                   ])),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 10),
            //     Expanded(
            //       child: Container(
            //         padding: const EdgeInsets.symmetric(vertical: 8),
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10),
            //           color: Colors.grey[200],
            //         ),
            //         child: InkWell(
            //           onTap: () {
            //             // Xử lý khi nhấp vào
            //           },
            //           child: const Center(child: Text('Name')),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

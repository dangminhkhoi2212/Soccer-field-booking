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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Search'),
                Row(
                  children: [
                    IconButton(onPressed: () {}, icon: const LineIcon.search())
                  ],
                )
              ],
            ));
      },
      isFullScreen: false,
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return List<ListTile>.generate(0, (int index) {
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
  }
}

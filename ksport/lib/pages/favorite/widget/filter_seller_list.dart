import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FilterFavorite extends StatefulWidget {
  const FilterFavorite({super.key});

  @override
  State<FilterFavorite> createState() => _FilterSellerListState();
}

class _FilterSellerListState extends State<FilterFavorite> {
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
  }
}

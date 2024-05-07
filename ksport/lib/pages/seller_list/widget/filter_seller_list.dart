import 'package:client_app/config/api_config.dart';
import 'package:client_app/pages/seller_list/state/seller_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class FilterSellerList extends StatefulWidget {
  const FilterSellerList({super.key});

  @override
  State<FilterSellerList> createState() => _FilterSellerListState();
}

class _FilterSellerListState extends State<FilterSellerList> {
  final _formKey = GlobalKey<FormBuilderState>();
  final SearchController controller = SearchController();
  final ApiConfig _apiConfig = ApiConfig();
  late UserService _userService;
  final SellerListState sellerListState = Get.put(SellerListState());
  final _logger = Logger();
  String? text;
  @override
  void initState() {
    super.initState();
    _userService = UserService(_apiConfig.dio);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: Colors.white),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            onChanged: (value) {
              setState(() {
                text = value;
              });
            },
            decoration: const InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 20)),
          )),
          const SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () {
                sellerListState.changeText(text!);
              },
              icon: const LineIcon.search())
        ],
      ),
    );
  }
}

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart'; // Changed from LineIcon to LineIcons

class OrderFilterSort extends StatefulWidget {
  final void Function({
    String? sortBy,
  }) onFilterChange;
  const OrderFilterSort({Key? key, required this.onFilterChange})
      : super(key: key); // Fix super key parameter

  @override
  State<OrderFilterSort> createState() => _OrderFilterSortState();
}

class _OrderFilterSortState extends State<OrderFilterSort> {
  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'Start time',
      'value': 'time_asc', // Corrected value
      'icon': const Icon(LineIcons.arrowUp, size: 14), // Corrected LineIcon
    },
    {
      'title': 'Start time',
      'value': 'time_desc', // Corrected value
      'icon': const Icon(LineIcons.arrowDown, size: 14), // Corrected LineIcon
    },
    {
      'title': 'Price',
      'value': 'total_asc', // Corrected value (lowercase 'p')
      'icon': const Icon(LineIcons.arrowUp, size: 14), // Corrected LineIcon
    },
    {
      'title': 'Price',
      'value': 'total_desc', // Corrected value (lowercase 'p')
      'icon': const Icon(LineIcons.arrowDown, size: 14), // Corrected LineIcon
    },
  ];

  String? _value;
  @override
  void initState() {
    super.initState();
  }

  _handleOnChange(String? value) {
    setState(() {
      _value = value;
    });

    widget.onFilterChange(sortBy: value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          borderRadius: BorderRadius.circular(12),
          alignment: Alignment.center,
          isExpanded: true,
          hint: const Text(
            'Sort by',
            style: TextStyle(color: Colors.grey),
          ),
          value: _value,
          style: const TextStyle(fontSize: 14, color: Colors.black),
          onChanged: (value) {
            _handleOnChange(value);
          },
          padding: EdgeInsets.zero,
          enableFeedback: true,
          items: _menuItems
              .map((item) => DropdownMenuItem<String>(
                    value: item['value'],
                    child: Row(
                      children: [
                        Text(item['title'] as String),
                        const SizedBox(width: 8),
                        item['icon'],
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

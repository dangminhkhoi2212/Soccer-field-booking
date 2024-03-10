import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderListPage> {
  final _orderService = OrderService();
  final _box = GetStorage();
  final _logger = Logger();
  final List<OrderModel?> _orders = [];
  String? _userID;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _userID = _box.read('id');
    print(_userID);
    _getOrders();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  Future _getOrders() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Response? response = await _orderService.getAllOrder(userID: _userID!);
      if (response!.statusCode == 200) {
        final data = response.data;
        for (int i = 0; i < data.length; i++) {
          _orders.add(OrderModel.fromJson(data[i]));
        }
        _logger.d(error: data, '_getOrders');
      }
    } catch (e) {
      _logger.e(error: e, '_getOrders');
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  final OrderModel? order = _orders[index];
                  return OrderCard(
                    date: order!.date ?? '',
                    startTime: order.startTime ?? '',
                    endTime: order.endTime ?? '',
                    fieldName: order.fieldID!.name ?? "",
                    total: order.total!.toDouble() ?? 0.0,
                    status: order.status ?? '',
                    onTap: () {
                      Get.toNamed(RoutePaths.orderDetail,
                          parameters: {'orderID': order.sId!});
                    },
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                itemCount: _orders.length),
          )
        ],
      ),
    );
  }
}

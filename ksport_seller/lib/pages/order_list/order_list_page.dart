import 'package:dio/dio.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderList> {
  final _orderService = OrderService();
  final _box = GetStorage();
  final _logger = Logger();
  final List<OrderModel?> _orders = [];
  String? _sellerID;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _sellerID = _box.read('id');
    print(_sellerID);
    _getOrders(
      date: FormatUtil.formatDate(DateTime.now()),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  Future _getOrders({String? date, String? status, String? sortBy}) async {
    setState(() {
      _isLoading = true;
    });
    try {
      _orders.clear();
      Response? response = await _orderService.getAllOrder(
        sellerID: _sellerID!,
        date: date,
        status: status,
        sortBy: sortBy,
      );
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

  Widget _buildShowOrder() {
    if (_orders.isEmpty) {
      return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: EmptyWidget(
            hideBackgroundAnimation: true,
            packageImage: PackageImage.Image_3,
            title: 'Order is empty',
          ),
        ),
      );
    }
    return ListView.separated(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
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
        itemCount: _orders.length);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          FilterOrder(onFilterChange: _getOrders),
          const SizedBox(
            height: 10,
          ),
          Expanded(child: _buildShowOrder())
        ],
      ),
    );
  }
}

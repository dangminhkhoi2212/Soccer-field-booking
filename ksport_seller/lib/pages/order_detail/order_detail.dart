import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  String? _orderID;
  OrderModel? _order;
  final _logger = Logger();
  final OrderService _orderService = OrderService();
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _orderID = Get.parameters['orderID'];
    print(_orderID);
    _getOrder();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  Future _getOrder() async {
    if (_orderID == null) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final Response? response =
          await _orderService.getOneOrder(orderID: _orderID!);
      if (response!.statusCode == 200) {
        _order = OrderModel.fromJson(response.data);
      }
    } catch (e) {
      _logger.e(error: e, '_getOrder');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: MyLoading.spinkit(),
      );
    }
    if (_order == null) {
      return const Center(
        child: Text('Order not found'),
      );
    }
    return OrderInfo(order: _order!);
  }

  Widget _buildButton() {
    if (_order == null) return const SizedBox();
    if (_order!.status != 'pending') return const SizedBox();
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text('Do you want to accept this order?'),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade100,
                    ),
                    onPressed: () {
                      _handleCancel();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColor.litePrimary,
                    ),
                    onPressed: () {
                      _handleAccept();
                    },
                    child: const Text(
                      'Accept',
                      style: TextStyle(
                          color: MyColor.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future _handleCancel() async {
    try {
      final Response? response = await _orderService.updateOrder(
          orderID: _order!.sId!, status: 'cancel');
      if (response!.statusCode == 200) {
        SnackbarUtil.getSnackBar(
            title: 'Update order', message: 'Canceled this order');
        _getOrder();
      } else {
        SnackbarUtil.getSnackBar(
            title: 'Update order', message: 'Have an error. Please try again');
      }
    } catch (e) {
      _logger.e(error: e, '_handleCancel');
      SnackbarUtil.getSnackBar(
          title: 'Update order', message: 'Have an error. Please try again');
    }
  }

  Future _handleAccept() async {
    try {
      final Response? response = await _orderService.updateOrder(
          orderID: _order!.sId!, status: 'ordered');
      if (response!.statusCode == 200) {
        SnackbarUtil.getSnackBar(
            title: 'Update order', message: 'Canceled this order');
        _getOrder();
      } else {
        SnackbarUtil.getSnackBar(
            title: 'Update order', message: 'Have an error. Please try again');
      }
    } catch (e) {
      _logger.e(error: e, '_handleCancel');
      SnackbarUtil.getSnackBar(
          title: 'Update order', message: 'Have an error. Please try again');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.background,
      appBar: AppBar(),
      body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [_buildBody(), _buildButton()],
          )),
    );
  }
}

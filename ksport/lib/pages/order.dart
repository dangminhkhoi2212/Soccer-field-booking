import 'package:client_app/widgets/my_scaffold.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  OrderState createState() => OrderState();
}

class OrderState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: const Text('Order page'),
      ),
      child: const Text('order page'),
    );
  }
}

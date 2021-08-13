import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = "/orders";

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  void initState() {
    //Future.delayed(Duration.zero).then((_) {
    Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    //});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (context, index) => OrderItem(orders.orders[index]),
        itemCount: orders.orders.length,
      ),
    );
  }
}

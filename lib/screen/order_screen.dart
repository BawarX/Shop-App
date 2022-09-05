
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/orders.dart';
import 'package:shopapp/widget/app_drawer.dart';
import 'package:shopapp/widget/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_){
      Provider.of<Orders>(context,listen: false).fetchAndSetOrders();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, i) => orderItem(
           orderData.orders[i],
            ),
        itemCount: orderData.orders.length,
        ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:shopapp/provider/cart.dart';
import 'package:shopapp/widget/cartItem.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dataTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.dataTime,
    required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProduct, double total) {
    _orders.insert(
        0,
        OrderItem(
          id: DateTime.now().toString(),
          amount: total,
          dataTime: DateTime.now(),
          products: cartProduct,
        ));
        notifyListeners();
  }

}

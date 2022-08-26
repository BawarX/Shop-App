import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shopapp/provider/cart.dart';

import 'package:http/http.dart' as http;

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

  Future<void> fetchAndSetOrders() async {
    final url = Uri.https(
        'app-shop-3f804-default-rtdb.firebaseio.com', '/orders.json'
        );
        final response = await http.get(url);
        print(json.decode(response.body));
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url = Uri.https(
        'app-shop-3f804-default-rtdb.firebaseio.com', '/orders.json'
        );
        final timeStamp = DateTime.now();
      final response = await  http.post(url,body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products' : cartProduct.map((cp) => {
            'id': cp.id,
            'title': cp.title,
            'quantity': cp.quantity,
            'price': cp.price
          }).toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dataTime: timeStamp, 
          products: cartProduct,
        ));
        notifyListeners();
  }

}

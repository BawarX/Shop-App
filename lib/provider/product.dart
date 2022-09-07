import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    this.isFavorite = false,
  });
  Future<void> toggleFavoriteStaute(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners(); // wak set state
    final url = Uri.https(
        'app-shop-3f804-default-rtdb.firebaseio.com', '/userFavorite/$userId/$id.json?auth=$token' 
        );
    try {
      await http.patch(url,
          body: json.encode(
            isFavorite,
          ));
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}

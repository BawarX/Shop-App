// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/cart.dart';
import 'package:shopapp/provider/orders.dart';
import 'package:shopapp/provider/product_provider.dart';
import 'package:shopapp/screen/Product_screen_Detail.dart';
import 'package:shopapp/screen/cart_screen.dart';
import 'package:shopapp/screen/edit_product_screen.dart';
import 'package:shopapp/screen/order_screen.dart';
import 'package:shopapp/screen/product_screen_view.dart';
import 'package:shopapp/screen/user_product.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         ChangeNotifierProvider.value(
            value: Products(),
             ),
              ChangeNotifierProvider.value(
                value: Cart(),
             ),
              ChangeNotifierProvider.value(
                value: Orders(),
              )
      ],
         child: MaterialApp(
         debugShowCheckedModeBanner: false,
          title: 'my dukan',
          theme: ThemeData(primarySwatch: Colors.blue,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato'
          ),
          home: ProductOverViewScreen(),
          
          routes: {
            ProductScreenDetail.routeName :(context) => ProductScreenDetail(),
            CartScreen.routeName :(context) => CartScreen(),
            OrderScreen.routeName :(context) => OrderScreen(),
            UserProductScreen.routeName :(context) => UserProductScreen(),
            EditProductScreen.routeName :(context) => EditProductScreen(),
          },
        ),
      );
  }
}
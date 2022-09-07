// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/auth.dart';
import 'package:shopapp/provider/cart.dart';
import 'package:shopapp/provider/orders.dart';
import 'package:shopapp/provider/product_provider.dart';
import 'package:shopapp/screen/Product_screen_Detail.dart';
import 'package:shopapp/screen/auth_screen.dart';
import 'package:shopapp/screen/cart_screen.dart';
import 'package:shopapp/screen/edit_product_screen.dart';
import 'package:shopapp/screen/order_screen.dart';
import 'package:shopapp/screen/product_screen_view.dart';
import 'package:shopapp/screen/user_product.dart';
import 'package:shopapp/widget/products_grid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
               create: (_) => Products('', []),
            update: (ctx, auth, previousProducts) {
              return Products(
                auth.token!,
                previousProducts!.items,
              );
            }
          ),
          ChangeNotifierProxyProvider<Auth,Orders>(
               create: (_) => Orders('', []),
            update: (ctx, auth, previousProducts) {
              return Orders(
                auth.token!,
                previousProducts == null ? [] : previousProducts.orders,
              );
            }
            )
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'my dukan',
            theme: ThemeData(
                primarySwatch: Colors.blue,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato'),
            home: auth.isAuth ? ProductOverViewScreen() : AuthScreen(),
            routes: {
              ProductScreenDetail.routeName: (context) => ProductScreenDetail(),
              CartScreen.routeName: (context) => CartScreen(),
              OrderScreen.routeName: (context) => OrderScreen(),
              UserProductScreen.routeName: (context) => UserProductScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen(),
            },
          ),
        ));
  }
}

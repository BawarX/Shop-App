import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/cart.dart';
import 'package:shopapp/screen/cart_screen.dart';
import 'package:shopapp/widget/app_drawer.dart';
import 'package:shopapp/widget/badge.dart';
import 'package:shopapp/widget/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverViewScreen extends StatefulWidget {
  @override
  State<ProductOverViewScreen> createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  bool _showFavoriateOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dukan"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showFavoriateOnly = true;
                } else {
                  _showFavoriateOnly = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only Favorite"),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOptions.All,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                  ),
                ),
                value: cart.itemCount.toString(),
                color: Colors.orange
                ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: productGrid(_showFavoriateOnly),
    );
  }
}



            // IconButton(
            // onPressed: (){
            //   Navigator.of(context).pushNamed(CartScreen.routeName);
            // }, 
            // icon: Icon(Icons.shopping_cart),
            // ),
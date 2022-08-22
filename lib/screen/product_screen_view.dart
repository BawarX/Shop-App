import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/cart.dart';
import 'package:shopapp/provider/product_provider.dart';
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
  var _isInit = true;
  var _isLoading = false;

  // @override
  // void initState() {
  //   Provider.of<Products>(context,listen: false).fetchAndSetProducts();
  //   // Future.delayed(Duration.zero).then((_){
  //   //   Provider.of<Products>(context,listen: false).fetchAndSetProducts().then((_){
       
  //   //   });
  //   // });
    
  //   super.initState();
  // }


  @override
  void didChangeDependencies() {
    if(_isInit){
      setState(() {
         _isLoading = true;// xoy abe true be
      });
     
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
                  _showFavoriateOnly = true; // xoy abe true be
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
      body: _isLoading ?
       Center(child: CircularProgressIndicator(),) 
       : productGrid(_showFavoriateOnly),
    );
  }
}



            // IconButton(
            // onPressed: (){
            //   Navigator.of(context).pushNamed(CartScreen.routeName);
            // }, 
            // icon: Icon(Icons.shopping_cart),
            // ),
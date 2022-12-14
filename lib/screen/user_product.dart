import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/provider/product_provider.dart';
import 'package:shopapp/screen/edit_product_screen.dart';
import 'package:shopapp/widget/app_drawer.dart';
import 'package:shopapp/widget/user_product.dart';

class UserProductScreen extends StatelessWidget {
  
  static const String routeName = "/userProductScreen";

  Future<void> _refreshProducts(BuildContext context) async{
  await  Provider.of<Products>(context,listen: false).fetchAndSetProducts();
  }
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Product"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),// aw harakay akay labar contexteka
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (_, i) => Column(
              children: [
                UserProductItem(
                  productsData.items[i].id,
                  productsData.items[i].title,
                  productsData.items[i].imageUrl,
                ),
                  Divider(),
              ],
            ),
            itemCount: productsData.items.length,
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopapp/provider/product_provider.dart';
import 'package:shopapp/widget/product_item.dart';

class productGrid extends StatelessWidget {

  bool showFavs;
  productGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    
    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        //create: (c) => products[index],
        value: products[index] ,
       child: ProductItem(
        // products[index].id,
        // products[index].title,
        //  products[index].imageUrl
         ),
        ), 
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}

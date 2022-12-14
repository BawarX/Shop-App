import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopapp/provider/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

   String authToken;
   
  Products(this.authToken,this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly(){
  //   _showFavoritesOnly = true;
  //    notifyListeners();
  // }
  // void showAll(){
  //   _showFavoritesOnly = false;
  //    notifyListeners();
  // }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.https(
      'app-shop-3f804-default-rtdb.firebaseio.com', '/product.json?auth=$authToken'
    );
   // final url = "app-shop-3f804-default-rtdb.firebaseio.com";
    try{
      final response = await http.get(url);  
    //  final response = await http.get(Uri.parse(url));
      final extraxtedData = jsonDecode(response.body) as Map<String,dynamic>;
      if(extraxtedData == null){
        return;
      }
      // final favoriteResponse = await http.get(
      //    'app-shop-3f804-default-rtdb.firebaseio.com', '/userFavorite/$userId.json?auth=$authToken' 
      // );
      final List<Product> loadedProducts = [];  
      extraxtedData.forEach((prodId, prodData) {        
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          price: prodData['price'],
          description: prodData['description'],
           imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite'],
         
        ));
       });
       
       _items = loadedProducts;
       notifyListeners();
    }catch(error){
      print(error);
      throw(error);
    }
  }


  Future<void> addProduct(Product product) async {
    final url = Uri.https(
        'app-shop-3f804-default-rtdb.firebaseio.com', '/product.json?auth=$authToken'
        );
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'id': product.id,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
            'description': product.description,
          }));
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      //_items.insert
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.https(
        'app-shop-3f804-default-rtdb.firebaseio.com', '/product/$id.json?auth=$authToken'
        );
       await http.patch(url,body: json.encode({
          'description' : newProduct.description,
          'id' : newProduct.id,// zyada agadar ba
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
          'title': newProduct.title,
        },),);
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
   final url = Uri.https(
        'app-shop-3f804-default-rtdb.firebaseio.com', '/product/$id.json?auth=$authToken'
        );
    final exisitingProductIndex = _items.indexWhere((prod) => prod.id == id);   
    var existingProduct = _items[exisitingProductIndex];
    http.delete(url).then((response){
      if(response.statusCode >= 400){
        throw Exception();
      }
      //existingProduct = null;
    }).catchError((_){
      _items.insert(exisitingProductIndex, existingProduct);
       notifyListeners();
    });
    _items.removeAt(exisitingProductIndex);
    notifyListeners();
   
  }
}

// ignore_for_file: unnecessary_null_comparison
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';

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
    // Product(
    //   id: 'p5',
    //   title: 'It\'s Me',
    //   description: 'Khaled Hassan Ghaly.',
    //   price: 100.0,
    //   imageUrl:
    //       'https://images.unsplash.com/photo-1618588507085-c79565432917?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YmVhdXRpZnVsJTIwbmF0dXJlfGVufDB8fDB8fHww&w=1000&q=80',
    // ),
  ];
  final String authToken;
  final String userId;
  Products(this.authToken, this._items, this.userId);
  // bool _showFavoritesOnly = false;

  /// return _items;	        A reference to the _items list.
  /// return [..._items];	    A copy of the _items list.

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItem {
    return _items
        .where(
          (element) => element.isFavorite,
        )
        .toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchingData() async {
    var url = Uri.parse(
        'https://shop-app-8c9d3-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final List<Product> loadedData = [];

        if (data == null) {
          debugPrint("Data is null.");
          return; // Return early if data is null.
        }

        url = Uri.parse(
            'https://shop-app-8c9d3-default-rtdb.firebaseio.com/products/userFavorite/$userId.json?auth=$authToken');
        final favoriteResponse = await http.get(url);

        if (favoriteResponse.statusCode == 200) {
          final favoriteData = json.decode(favoriteResponse.body);

          if (favoriteData == null) {
            debugPrint("Favorite data is null.");
          }

          data.forEach((productId, productData) {
            loadedData.add(Product(
              id: productId,
              title: productData['title'] ?? 'No Title',
              description: productData['description'] ?? 'No Description',
              price: productData['price'] ?? 0.0,
              imageUrl: productData['imageUrl'] ?? '',
              isFavorite: favoriteData == null
                  ? false
                  : favoriteData[productId] ?? false,
            ));
          });
          _items = loadedData;
          notifyListeners();
        } else {
          // Handle the case where favoriteResponse is not successful.
          debugPrint("Favorite data request failed.");
        }
      } else {
        // Handle the case where the main response is not successful.
        debugPrint("Data request failed.");
      }
    } catch (error) {
      debugPrint(error.toString());
      throw error.toString();
    }
  }

  Future<void> addItem(Product product) async {
    final url = Uri.parse(
        'https://shop-app-8c9d3-default-rtdb.firebaseio.com/products.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
            // 'isFavorite': product.isFavorite, 
          }));
      final newProuct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProuct);
      notifyListeners();
      // debugPrint(product.id);
    } catch (error) {
      debugPrint(error.toString());
      throw error.toString();
    }
  }

  Future<void> removeItem(String productId) async {
    final url = Uri.parse(
        'https://shop-app-8c9d3-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken');
    final existingIndex =
        _items.indexWhere((element) => element.id == productId);
    Product? existingDataById = _items[existingIndex];
    _items.removeAt(existingIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingIndex, existingDataById);
      notifyListeners();
      throw const HttpException('Could not delete product.');
    }
    existingDataById = null;
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://shop-app-8c9d3-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'imageUrl': newProduct.imageUrl,
            'description': newProduct.description,
            'price': newProduct.price,
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      debugPrint("Product with id=$id not found.");
    }
  }
}

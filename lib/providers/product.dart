import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite = false;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    bool? isFavorite,
  });

  Future<void> toggleFavoritesStates(String token, String userId) async {
    final oldState = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://shop-app-8c9d3-default-rtdb.firebaseio.com/products/userFavorite/$userId/$id.json?auth=$token');
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavorite,
          ));
      if (response.statusCode >= 400) {
        _setFavValue(oldState);
      }
    } catch (e) {
      _setFavValue(oldState);
    }
  }

  void _setFavValue(bool newState) {
    isFavorite = newState;
    notifyListeners();
  }
}

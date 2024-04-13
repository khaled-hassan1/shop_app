import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  // final List<OrderItem> _orders;
  List<OrderItem> _orders;
  final String token;
  final String userId;

  Orders(this.token, this._orders, this.userId);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://shop-app-8c9d3-default-rtdb.firebaseio.com/orders/$userId.json?=auth=$token');
    final response = await http.get(url);
    final List<OrderItem> loadedData = [];
    final Map<String, dynamic> data = json.decode(response.body);
    if (data.isEmpty) {
      return;
    }
    data.forEach(
      (orderId, orderData) {
        double? amount = orderData['amount'];
        if (amount == null || amount is! int) {
          return;
        }
        loadedData.add(
          OrderItem(
            id: orderId,
            amount: amount,
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                      id: item['id'],
                      title: item['title'],
                      quantity: item['quantity'],
                      price: item['price']),
                )
                .toList(),
          ),
        );
      },
    );
    _orders = loadedData.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartItem, double total) async {
    final url = Uri.parse(
        'https://shop-app-8c9d3-default-rtdb.firebaseio.com/orders/$userId.json?=auth=$token');
    final timeStamp = DateTime.now();
    final response = await http.patch(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'product': cartItem
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'price': e.price,
                    'quantity': e.quantity,
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'].toString(),
        amount: total,
        dateTime: timeStamp,
        products: cartItem,
      ),
    );
    notifyListeners();
  }
}

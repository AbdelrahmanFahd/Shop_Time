import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'cart.dart';
import 'dart:convert';
import '../Models/http_exception.dart';

class OrderItem {
  final String id;
  final double amount;
  final DateTime dateTime;
  final List<CartItem> products;

  OrderItem({
    required this.id,
    required this.dateTime,
    required this.products,
    required this.amount,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String? authToken;
  final String? userId;
  Orders(this.authToken, this.userId, this._orders);

  Future<void> fetchAndSetOrders() async {
    var url = Uri.parse(
        'https://ecommerce-7933b-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$authToken');
    List<OrderItem> loadedOrders = [];
    final response = await http.get(url);
    if (json.decode(response.body) == null) return;

    final extractingData = json.decode(response.body) as Map<String, dynamic>;

    extractingData.forEach((ordId, ordData) {
      loadedOrders.add(OrderItem(
          id: ordId,
          dateTime: DateTime.parse(ordData['dateTime']),
          products: (ordData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    price: item['price'],
                    quantity: item['quantity'],
                  ))
              .toList(),
          amount: ordData['total']));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final timestamp = DateTime.now();
    var url = Uri.parse(
        'https://ecommerce-7933b-default-rtdb.firebaseio.com/Orders/$userId.json?auth=$authToken');
    final response = await http.post(url,
        body: json.encode({
          'total': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProduct
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity,
                  })
              .toList(),
        }));
    if (response.statusCode >= 400) throw HttpException('Failed');
    _orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          dateTime: timestamp,
          products: cartProduct,
          amount: total),
    );
    notifyListeners();
  }
}

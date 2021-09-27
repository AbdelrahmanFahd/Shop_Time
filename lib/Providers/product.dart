import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/http_exception.dart';

class Product with ChangeNotifier {
  final String? id;
  final String? title;
  final String? description;
  final double price;
  final String? imageURL;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageURL,
    required this.price,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String? authToken, String? userId) async {
    final oldFavorite = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    var url = Uri.parse(
        'https://ecommerce-7933b-default-rtdb.firebaseio.com/userFavorite/$userId/$id.json?auth=$authToken');
    final response = await http.put(url,
        body: json.encode(
          isFavorite,
        ));
    if (response.statusCode >= 400) {
      isFavorite = oldFavorite;
      notifyListeners();
      throw HttpException('Toggling Failed');
    }
  }
}

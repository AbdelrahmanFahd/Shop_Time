import 'package:flutter/cupertino.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   imageURL:
    //       'https://cdn.suitableshop.com/img/p181x/colorful-standard-t-shirt-scarlet-red--61310-1.jpg',
    //   price: 29.29,
    // ),
    // Product(
    //     id: 'p2',
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     imageURL:
    //         'https://www.prada.com/content/dam/pradanux_products/S/SPH/SPH109/1WQ8F0002/SPH109_1WQ8_F0002_S_211_SLF.png',
    //     price: 59.99),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   imageURL:
    //       'https://lp2.hm.com/hmgoepprod?set=quality%5B79%5D%2Csource%5B%2F46%2F65%2F4665ed3ef6fefcc6ab05808a00fe1fa05830660e.jpg%5D%2Corigin%5Bdam%5D%2Ccategory%5Bladies_accessories_hatsscarvesgloves_scarves%5D%2Ctype%5BDESCRIPTIVESTILLLIFE%5D%2Cres%5Bm%5D%2Chmver%5B1%5D&call=url[file:/product/main]',
    //   price: 19.99,
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   imageURL:
    //       'https://m.media-amazon.com/images/I/817RjT77c0L._AC_SX522_.jpg',
    //   price: 49.99,
    // ),
  ];

  // var _showFavoritesOnly = false;

  List<Product> get item {
    // if (_showFavoritesOnly) {
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItem {
    return _items.where((element) => element.isFavorite).toList();
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }
  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }
  final String? authToken;
  final String? userId;
  Products(this.authToken, this.userId, this._items);

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterSting =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    var url = Uri.parse(
        'https://ecommerce-7933b-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterSting');
    try {
      final response = await http.get(url);
      final List<Product> loadedProducts = [];

      final extractingData = json.decode(response.body) as Map<String, dynamic>;

      url = Uri.parse(
          'https://ecommerce-7933b-default-rtdb.firebaseio.com/userFavorite/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(url);

      final favoriteData = json.decode(favoriteResponse.body);
      extractingData.forEach(
        (prodId, prodData) {
          loadedProducts.add(
            Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              imageURL: prodData['imageUrl'],
              price: prodData['price'],
              isFavorite:
                  favoriteData == null ? false : favoriteData[prodId] ?? false,
            ),
          );
        },
      );
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      var url = Uri.parse(
          'https://ecommerce-7933b-default-rtdb.firebaseio.com/products.json?auth=$authToken');
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageURL,
          'price': product.price,
          'isFavorite': product.isFavorite,
          'creatorId': userId,
        }),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageURL: product.imageURL,
        price: product.price,
      );
      _items.add(newProduct);
      // _items.insert(0,  newProduct);  //at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((element) => element.id == id);

    if (productIndex >= 0) {
      var url = Uri.parse(
          'https://ecommerce-7933b-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageURL,
          'price': newProduct.price,
        }),
      );
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('....');
    }
  }

  Future<void> deleteProduct(String id) async {
    var url = Uri.parse(
        'https://ecommerce-7933b-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingProductIndex];

    _items.removeWhere((element) => element.id == id);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Cloud not delete product.');
    }
    existingProduct = null;
  }
}

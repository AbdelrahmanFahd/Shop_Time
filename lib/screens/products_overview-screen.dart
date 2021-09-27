import '../Providers/cart.dart';
import 'cart_screen.dart';
import 'package:flutter/material.dart';
import '../widget/products_Grid.dart';
import '../widget/badge.dart';
import 'package:provider/provider.dart';
import '../widget/app_drawer.dart';
import '../Providers/Products.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverViewScreen extends StatefulWidget {
  @override
  _ProductsOverViewScreenState createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoaded = false;
  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); // the context error
    // Future.delayed(Duration.zero)
    //     .then((value) => Provider.of<Products>(context).fetchAndSetProducts());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoaded = true;
      Provider.of<Products>(context)
          .fetchAndSetProducts()
          .then((value) => _isLoaded = false);
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(102, 68, 130, 1),
        title: Text(
          "MyShop",
        ),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  'Only Favorites',
                  style: TextStyle(
                    color: Color.fromRGBO(81, 50, 107, 1),
                  ),
                ),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text(
                  'All',
                  style: TextStyle(
                    color: Color.fromRGBO(81, 50, 107, 1),
                  ),
                ),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, _2) => Badge(
              color: Color.fromRGBO(67, 38, 92, 1),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: Icon(Icons.shopping_cart),
              ),
              value: cart.itemCount.toString(),
            ),
          ),
        ],
      ),
      body: _isLoaded
          ? Center(
              child: CircularProgressIndicator(
              color: Color.fromRGBO(153, 121, 216, 1),
            ))
          : ProductsGrid(_showOnlyFavorites),
      drawer: AppDrawer(
        color: Color.fromRGBO(102, 68, 130, 1),
      ),
    );
  }
}

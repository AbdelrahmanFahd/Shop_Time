import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/Products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context)!.settings.arguments as String; //is the id!
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title.toString()),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Color.fromRGBO(214, 199, 254, 1),
            foregroundColor: Color.fromRGBO(67, 38, 92, 1),
            expandedHeight: 350,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                loadedProduct.title.toString(),
                style: TextStyle(
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              background: Hero(
                tag: loadedProduct.id.toString(),
                child: Image.network(
                  loadedProduct.imageURL.toString(),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Chip(
                backgroundColor: Color.fromRGBO(153, 121, 216, 1),
                label: Text(
                  '\$ ${loadedProduct.price}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Chip(
                backgroundColor: Color.fromRGBO(127, 88, 193, 1),
                label: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    loadedProduct.description.toString(),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ),
              SizedBox(
                height: 550,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

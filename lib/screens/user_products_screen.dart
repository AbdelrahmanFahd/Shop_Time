import 'package:flutter/material.dart';
import '../Providers/Products.dart';
import 'package:provider/provider.dart';
import '../widget/user_product_item.dart';
import '../widget/app_drawer.dart';
import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routName = '/user_product';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    const Color2 = Color.fromRGBO(107, 51, 153, 1);
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color2,
        title: Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routName, arguments: '100');
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(color: Color2),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapData) => snapData.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(
                  color: Color2,
                ),
              )
            : RefreshIndicator(
                color: Colors.deepPurpleAccent,
                onRefresh: () => _refreshProducts(context),
                child: Consumer<Products>(
                  builder: (ctx, productsData, _) => Container(
                    color: Color.fromRGBO(214, 199, 254, 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 15),
                      child: ListView.builder(
                        itemCount: productsData.item.length,
                        itemBuilder: (ctx, index) => Column(
                          children: [
                            UserProductItem(
                              id: productsData.item[index].id.toString(),
                              title: productsData.item[index].title.toString(),
                              imageUrl:
                                  productsData.item[index].imageURL.toString(),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

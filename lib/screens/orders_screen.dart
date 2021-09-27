import 'package:flutter/material.dart';
import '../Providers/orders.dart' show Orders;
import 'package:provider/provider.dart';
import '../widget/order_item.dart';
import '../widget/app_drawer.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/Order';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future? _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const Color1 = Color.fromRGBO(127, 88, 193, 1);
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color1,
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color1,
              ),
            );
          } else {
            if (dataSnapShot.error != null) {
              return Text('there Error');
            } else {
              return Consumer<Orders>(builder: (ctx, orderData, child) {
                return Container(
                  color: Color.fromRGBO(214, 199, 254, 1),
                  child: ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) => OrderItem(
                      orderData.orders[i],
                    ),
                  ),
                );
              });
            }
          }
        },
      ),
      drawer: AppDrawer(
        color: Color1,
      ),
    );
  }
}

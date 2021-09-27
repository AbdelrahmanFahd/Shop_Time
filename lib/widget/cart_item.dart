import 'package:flutter/material.dart';
import '../Providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(
      {required this.title,
      required this.productId,
      required this.quantity,
      required this.price,
      required this.id});

  @override
  Widget build(BuildContext context) {
    final cartItem = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.grey,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40.0,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove item from the cart?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(color: Color.fromRGBO(81, 50, 107, 1)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text(
                  'No',
                  style: TextStyle(color: Color.fromRGBO(81, 50, 107, 1)),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        cartItem.removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Color.fromRGBO(102, 68, 130, 1),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: FittedBox(
                    child: Text(
                  '\$ $price',
                  style: TextStyle(
                    color: Theme.of(context).primaryTextTheme.headline6!.color,
                  ),
                )),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$ ${(price * quantity)}'),
            trailing: TextButton.icon(
              icon: Icon(
                Icons.delete,
                color: Colors.grey,
                size: 30,
              ),
              label: Text(
                '$quantity x',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              onPressed: () {
                cartItem.removeOneItem(productId);
              },
            ),
          ),
        ),
      ),
    );
  }
}

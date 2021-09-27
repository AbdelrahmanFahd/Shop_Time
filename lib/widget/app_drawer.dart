import 'package:flutter/material.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import '../Providers/auth.dart';

class AppDrawer extends StatelessWidget {
  final Color color;

  AppDrawer({required this.color});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: color,
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.shop,
              size: 25.0,
            ),
            title: Text(
              'Shop',
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.payment,
              size: 25.0,
            ),
            title: Text(
              'Orders',
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.edit,
              size: 25.0,
            ),
            title: Text(
              'Manage Products',
              style: TextStyle(fontSize: 18.0),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routName);
            },
          ),
          Divider(),
          ElevatedButton(
            child: Text(
              'LOGOUT',
              style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.headline6!.color),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logOut();
              Navigator.of(context).pushNamed('/');
            },
            style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(102, 68, 130, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 120.0, vertical: 8.0),
            ),
          ),
        ],
      ),
    );
  }
}

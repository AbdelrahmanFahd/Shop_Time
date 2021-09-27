import 'package:flutter/material.dart';
import '../Providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded
          ? min(widget.order.products.length * 20.0 + 115.0, 200.0)
          : 90,
      child: Card(
        margin: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text(
                  '\$ ${widget.order.amount.toStringAsFixed(2)}',
                  style: TextStyle(color: Color.fromRGBO(67, 38, 92, 1)),
                ),
                subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
                ),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 400),
                height: _expanded
                    ? min(widget.order.products.length * 20.0 + 10.0, 100.0)
                    : 0,
                child: Container(
                  height:
                      min(widget.order.products.length * 20.0 + 10.0, 100.0),
                  child: ListView(
                    children: widget.order.products
                        .map((index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    index.title,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Color.fromRGBO(67, 38, 92, 1)),
                                  ),
                                  Text(
                                    '${index.quantity}x \$${index.price}',
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

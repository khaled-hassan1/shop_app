import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  const OrderItem(this.order, {super.key});
  final ord.OrderItem order;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: ListTile(
              title: Text("\$${widget.order.amount.toStringAsFixed(2)}"),
              subtitle: Text(
                DateFormat('dd/M/yyyy   (hh:mm)').format(widget.order.dateTime),
              ),
              trailing:
                  Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          if (_isExpanded)
            SizedBox(
              height: min(widget.order.products.length * 20.0 + 100, 200),
              child: ListView(
                children: widget.order.products
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.title,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${e.quantity}x  \$${e.price}",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.grey),
                              )
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

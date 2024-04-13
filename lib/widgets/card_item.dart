import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CardItem extends StatelessWidget {
  const CardItem(
      {super.key,
      required this.productId,
      required this.id,
      required this.title,
      required this.quantity,
      required this.price});

  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              "Confirme",
              textAlign: TextAlign.center,
            ),
            content: const Text("Do you want remove the item from the cart?"),
            contentPadding: const EdgeInsets.all(15),
            actions: [
              TextButton(
                child: const Text("NO"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              ElevatedButton(
                child: const Text("YES"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      },
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.topRight,
        padding: const EdgeInsets.only(
          right: 20,
          top: 20,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: const Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      direction: DismissDirection.endToStart,
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(title),
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: FittedBox(
                  child: Text("\$$price"),
                ),
              ),
            ),
            trailing: Text(
              "\$$quantity x",
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            subtitle: Text("Total: \$${price * quantity}"),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrederScreen extends StatefulWidget {
  const OrederScreen({super.key});

  static const routeName = '/orders';

  @override
  State<OrederScreen> createState() => _OrederScreenState();
}

class _OrederScreenState extends State<OrederScreen> {
  late Future _future;
  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _future = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Order'),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // ignore: avoid_print
            print(snapshot.error);
            return const Center(child: Text('An error accourd!'));
          } else {
            return Consumer<Orders>(
              builder: (context, orderData, _) => ListView.builder(
                itemBuilder: (context, index) => OrderItem(
                  orderData.orders[index],
                ),
                itemCount: orderData.orders.length,
              ),
            );
          }
        },
      ),
      drawer: const AppDrawer(),
    );
  }
}

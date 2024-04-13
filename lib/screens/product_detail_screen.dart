import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final productsData = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId); // my method

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     productsData.title,
      //   ),
      //   backgroundColor: Theme.of(context).colorScheme.secondary,
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                productsData.title,
              ),
              centerTitle: true,
              background: Hero(
                tag: productsData.id!,
                child: Image.network(
                  productsData.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "\$${productsData.price.toString()}",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  productsData.description,
                  softWrap: true,
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 800,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// widgets

// closeButton + 
// CustomScrollView => SliverAppBar SliverList +
// ExpandIcon + 
// IndexedStack + 
// InteractiveViewer +
// LinearProgressIndicator +
// MaterialBanner +
// NavigationBar => NavigationDestination +
// PreferredSize +
// RefreshIndicator +
// OverflowBar +
// Scrollbar +
// SelectableText +
// SizedOverflowBox +
// Strpper 

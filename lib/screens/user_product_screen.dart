import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({super.key});

  static const route = '/user-products';

  Future<void> _refreshPage(BuildContext context) {
    return Provider.of<Products>(context, listen: false).fetchingData();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
      ),
      body: FutureBuilder(
        future: _refreshPage(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshPage(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                        itemBuilder: (_, index) => UserProductItem(
                          id: productData.items[index].id!,
                          title: productData.items[index].title,
                          description: productData.items[index].description,
                          imageUrl: productData.items[index].imageUrl,
                        ),
                        itemCount: productData.items.length,
                        separatorBuilder: (context, index) => const Divider(),
                      ),
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        extendedIconLabelSpacing: 20.0,
        extendedPadding: const EdgeInsets.only(right: 20, left: 20),
        label: const Text('ADD'),
        icon: const Icon(Icons.add),
        onPressed: () =>
            Navigator.of(context).pushNamed(EditProductScreen.route),
      ),
    );
  }
}

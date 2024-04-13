import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatefulWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  const ProductItem({
    super.key,
    // required this.id,
    // required this.title,
    // required this.imageUrl,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool _isShopping = false;
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Banner(
        // banner
        message: '25% off',
        location: BannerLocation.topStart,
        color: Colors.red,
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'PTSerif',
              ),
            ),
            // consumer to rebuild only widget
            leading: Consumer<Product>(
              // if i use child arg it's mean unrebuild (unupdate) this child like text or another widget
              builder: (context, product, _) => IconButton(
                onPressed: () {
                  product.toggleFavoritesStates(
                      authData.token!, authData.userId);
                },
                icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.deepOrange,
                ),
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                cart.addItem(product.id!, product.title, product.price);
                setState(() {
                  _isShopping = true;
                });
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${cart.itemCount} Added item to card'),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(product.id!);
                      },
                    ),
                  ),
                );
              },
              icon: Icon(
                _isShopping
                    ? Icons.shopping_cart
                    : Icons.add_shopping_cart_outlined,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              );
            },
            child: Hero(
              tag: product.id!,
              child: FadeInImage(
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
                placeholder:
                    const AssetImage('asset/images/product-placeholder.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

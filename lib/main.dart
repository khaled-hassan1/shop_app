// ignore_for_file: prefer_if_null_operators, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helper/custem_route.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';

import '../screens/user_product_screen.dart';
import '../providers/orders.dart';
import '../screens/order_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/product_detail_screen.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
import '../screens/edit_product_screen.dart';
import '../screens/auth_screen.dart';
import '../providers/auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, productsPrevious) => Products(
              auth.token!,
              productsPrevious! == null ? [] : productsPrevious.items,
              auth.userId),
          create: (context) => Products('', [], ''),
        ),
        ChangeNotifierProvider<Cart>(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, ordersPrevious) => Orders(auth.token!,
              ordersPrevious == null ? [] : ordersPrevious.orders, auth.userId),
          create: (context) => Orders('', [], ''),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop',
          theme: ThemeData(
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android:CustomPageTransitionBuilder(),
                TargetPlatform.iOS:CustomPageTransitionBuilder(),
              },
            ),
            appBarTheme: const AppBarTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
              color: Colors.deepPurple,
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PTSerif'),
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
            ),
            fontFamily: 'PTSerif',
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              secondary: Colors.deepPurple,
              tertiary: Colors.deepOrange,
            ),
            useMaterial3: true,
          ),
          home: auth.isAuth
              ? const ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          // const ProductsOverviewScreen(),
          routes: {
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            CartScreen.route: (context) => const CartScreen(),
            OrederScreen.routeName: (context) => const OrederScreen(),
            UserProductScreen.route: (context) => const UserProductScreen(),
            EditProductScreen.route: (context) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/user_product_screen.dart';
import '../screens/order_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("Hello Friend"),
            automaticallyImplyLeading: false,
            centerTitle: true,
            elevation: 2,
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            title: const Text("Shop"),
            leading: const Icon(Icons.shop),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Orders"),
            leading: const Icon(Icons.payment),
            onTap: () {
              Navigator.pushReplacementNamed(context, OrederScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Manage Products"),
            leading: const Icon(Icons.edit),
            onTap: () {
              Navigator.pushReplacementNamed(context, UserProductScreen.route);
              // Navigator.pushReplacement(
              //   context,
              //   CustemRoute(
              //     builder: (context) => const UserProductScreen(),
              //     settings: const RouteSettings(),
              //   ),
              // );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Log out"),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              // Navigator.pushReplacementNamed(context, UserProductScreen.route);
              Provider.of<Auth>(context, listen: false).logOut();
            },
          ),
        ],
      ),
    );
  }
}

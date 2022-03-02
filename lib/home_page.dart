// ignore_for_file: import_of_legacy_library_into_null_safe, prefer_const_constructors, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables

import 'package:bustank/provider/user_provider.dart';
import 'package:bustank/screens/add_product_screen.dart';
import 'package:bustank/screens/favourites.dart';
import 'package:bustank/screens/orders.dart';
import 'package:bustank/screens/product_search.dart';
import 'package:bustank/screens/profile.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

//my own imports
import 'package:bustank/components/home_listview.dart';
import 'package:bustank/screens/cart.dart';
import 'package:bustank/screens/login.dart';
import 'provider/product_provider.dart';
import 'screens/my_products_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final productProvider = Provider.of<ProductProvider>(context, listen: true);
    var userService = Provider.of<UserProvider>(context, listen: true);
    return userProvider.user.uid.isNotEmpty
        ? Scaffold(
            key: _key,
            appBar: AppBar(
              title: Text('Bustank'),
              centerTitle: true,
              backgroundColor: Colors.blueGrey,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.white,
                  onPressed: () async {
                    productProvider.productsSearched.clear();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductSearchScreen()));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  color: Colors.white,
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CartScreen()));
                  },
                ),
                SizedBox(
                  width: 5,
                )
              ],
            ),
            drawer: Drawer(
              child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      '${userProvider.userFetcher.getName}',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    accountEmail: Text(
                      '${userProvider.userFetcher.email}',
                      style: TextStyle(color: Colors.white),
                    ),
                    currentAccountPicture: CircleAvatar(
                      maxRadius: 150,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                        userProvider.userFetcher.picture!,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => MyHomePage()));
                    },
                    child: ListTile(
                      title: Text('Home Page'),
                      leading: Icon(
                        Icons.home,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await userProvider.reloadUserFetcher();
                      await userProvider.getOrders();
                      await productProvider.getMyProducts(userService.user.uid);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen()));
                    },
                    child: ListTile(
                      title: Text('My Account'),
                      leading: Icon(
                        Icons.person,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                     await productProvider.getMyProducts(userService.user.uid)
                     .whenComplete(() => Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) => MyProductsScreen()))
                      );
                    },
                    child: ListTile(
                      title: Text('My Products'),
                      leading: Icon(
                        Icons.category,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await userProvider.getOrders().whenComplete(() => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => OrdersScreen())));
                    },
                    child: ListTile(
                      title: Text('My Order'),
                      leading: Icon(
                        Icons.shopping_basket,
                        color: Colors.amberAccent,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartScreen()));
                    },
                    child: ListTile(
                      title: Text('Shopping Cart'),
                      leading: Icon(
                        Icons.shopping_cart,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await userProvider.getFavourites();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FavouritesScreen(),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text('Favourites'),
                      leading: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    child: ListTile(
                      title: Text(
                        'To contact us, please call the following numbers  0123456789',
                        style: TextStyle(
                            color: Colors.lightBlueAccent, fontSize: 15),
                      ),
                      leading: Icon(
                        Icons.call,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                  Divider(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        userProvider.signOut();
                      });
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: ListTile(
                      title: Text('logout'),
                      leading: Icon(
                        Icons.exit_to_app,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: HomeList(),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (_)=> AddProductScreen())),
              child: Icon(Icons.add),
              backgroundColor: Colors.blueGrey,
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

}

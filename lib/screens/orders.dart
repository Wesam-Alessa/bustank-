// ignore_for_file: use_key_in_widget_constructors, avoid_print, prefer_const_constructors

import 'package:bustank/fetcher/order.dart';
import 'package:bustank/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_page.dart';

class OrdersScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    //userProvider.orders.clear();
    print("orders ${userProvider.orders.length}");
    //userProvider.getOrders();
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>  MyHomePage()));
            },
            child: const Text("My Orders")),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView.builder(
          itemCount: userProvider.orders.length,
          itemBuilder: (_, index){
            OrderFetcher _order = userProvider.orders[index];
            return ListTile(
              leading: Text(
                "${_order.total }",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              title: Text("${_order.description}"),
              subtitle: Text("${DateTime.fromMillisecondsSinceEpoch(_order.createdAt).toString()}\nOrder Status :${_order.orderStatus}"),
              trailing: Text( "Receipt Status \n${_order.receiptStatus}",
                  style: TextStyle(color:  Color.fromRGBO(34, 139, 34, 1) )),
            );
          }),
      ),
    );
  }
}
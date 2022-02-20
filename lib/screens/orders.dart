// ignore_for_file: use_key_in_widget_constructors, avoid_print, prefer_const_constructors

import 'package:bustank/fetcher/order.dart';
import 'package:bustank/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: userProvider.orders.isNotEmpty
            ? GridView.builder(
                padding: EdgeInsets.all(10.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9),
                itemCount: userProvider.orders.length,
                itemBuilder: (_, index) {
                  OrderFetcher _order = userProvider.orders[index];
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            "Type: ${_order.description}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "Date/Time: ${DateTime.fromMillisecondsSinceEpoch(_order.createdAt).toString()}",
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "Order Status: ${_order.orderStatus}",
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "Receipt Status: ${_order.receiptStatus.isEmpty ? 'under revision' : _order.orderStatus}",
                            style: TextStyle(
                              color: Color.fromRGBO(34, 139, 34, 1),
                            ),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "Order Number: ${_order.id}",
                            //overflow: TextOverflow.clip,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            "Price: ${_order.total}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

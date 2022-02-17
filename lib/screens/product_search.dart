// ignore_for_file: prefer_const_constructors

import 'package:bustank/components/product_card.dart';
import 'package:bustank/provider/product_provider.dart';
import 'package:bustank/screens/products_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductSearchScreen extends StatelessWidget {
  const ProductSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
              productProvider.productsSearched.clear();
            }),
        title: Container(
          decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 5, left: 8, right: 8, bottom: 5),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300]!.withOpacity(1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                title: TextField(
                  textInputAction: TextInputAction.search,
                  onSubmitted: (pattern)async{
                    await productProvider.search(productName: pattern);
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => ProductSearchScreen()));
                    //pattern = null;
                  },
                  decoration: InputDecoration(
                    hintText: "search...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
        actions: const <Widget>[
          Icon(Icons.category),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: productProvider.productsSearched.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text("No products Found",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                        )),
                  ],
                )
              ],
            )
          : ListView.builder(
              itemCount: productProvider.productsSearched.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetails(
                                  product: productProvider
                                      .productsSearched[index])));
                    },
                    child: ProductCard(
                        product: productProvider.productsSearched[index]));
              }),
    );
  }
}

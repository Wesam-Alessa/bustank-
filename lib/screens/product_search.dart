// ignore_for_file: prefer_const_constructors

import 'package:bustank/components/product_gridView.dart';
import 'package:bustank/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({Key? key}) : super(key: key);

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            productProvider.productsSearched.clear();
            Navigator.pop(context);
          },
        ),
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300]!.withOpacity(1),
            borderRadius: BorderRadius.circular(10),
          ),
          child:TextField(
            textInputAction: TextInputAction.search,
            onChanged: (value) {
              value.isEmpty ? setState(() {
                productProvider.productsSearched.clear();
              }):
               productProvider.search(productName: value);
            },
            // onSubmitted: (pattern) async {
            //
            //   // Navigator.pushReplacement(
            //   //   context,
            //   //   MaterialPageRoute(
            //   //     builder: (context) => ProductSearchScreen(),
            //   //   ),
            //   // );
            // },
            decoration: InputDecoration(
                hintText: "search...",
                border: InputBorder.none,
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                )
            ),
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
        // actions: const <Widget>[
        //   Icon(Icons.category),
        //   SizedBox(
        //     width: 15,
        //   )
        // ],
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
                    Text(
                      "No products Found",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            )
          :
          ProductsGridView(products: productProvider.productsSearched),

          // : ListView.builder(
          //     itemCount: productProvider.productsSearched.length,
          //     itemBuilder: (context, index) {
          //       return GestureDetector(
          //         onTap: () async {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => ProductDetails(
          //                   product: productProvider.productsSearched[index]),
          //             ),
          //           );
          //         },
          //         child: ProductCard(
          //             product: productProvider.productsSearched[index]),
          //       );
          //     },
          //   ),
    );
  }
}

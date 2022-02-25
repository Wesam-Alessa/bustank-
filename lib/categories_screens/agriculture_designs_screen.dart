// ignore_for_file: prefer_const_constructors

 import 'package:bustank/components/product_gridView.dart';
import 'package:bustank/home_page.dart';
import 'package:bustank/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AgricultureDesignsScreen extends StatelessWidget {

  const AgricultureDesignsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            },
            child: const Text("Agriculture Designs")),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child:ProductsGridView(
          products: productProvider.agricultureDesigns,
        )
        // SingleChildScrollView(
        //   physics: const BouncingScrollPhysics(),
        //   child: Column(
        //     children: productProvider.agricultureDesigns
        //         .map((item) => GestureDetector(
        //       child: ProductCard(
        //         product: item,
        //       ),
        //     )).toList(),
        //   ),
        // ),
      ),
    );
  }
}
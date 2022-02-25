
// ignore_for_file: prefer_const_constructors

 import 'package:bustank/components/product_gridView.dart';
import 'package:bustank/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_page.dart';

class AgricultureWorkersScreen extends StatelessWidget {
  const AgricultureWorkersScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>  MyHomePage()));
            },
            child: const Text("Agriculture Workers")),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ProductsGridView(
          products: productProvider.agricultureWorkers,
        )
        // SingleChildScrollView(
        //   physics: const BouncingScrollPhysics(),
        //   child: Column(
        //     children: productProvider.agricultureWorkers
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
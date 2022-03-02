import 'package:bustank/components/product_gridView.dart';
import 'package:bustank/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyProductsScreen extends StatelessWidget {
  const MyProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context,listen: true);
     return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('My Products'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ProductsGridView(
          products: productProvider.myProducts,
        ),
      ),
    );
  }
}

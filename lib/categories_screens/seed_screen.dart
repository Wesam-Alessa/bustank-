import 'package:bustank/components/product_card.dart';
import 'package:bustank/components/product_gridView.dart';
import 'package:bustank/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home_page.dart';

class SeedsScreen extends StatelessWidget {
  const SeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title:  const Text("Seeds"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ProductsGridView(
          products: productProvider.seeds,
        )
      ),
    );
  }
}

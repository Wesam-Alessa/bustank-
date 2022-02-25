// ignore_for_file: file_names, must_be_immutable

import 'package:bustank/components/product_card.dart';
import 'package:bustank/fetcher/product.dart';
import 'package:flutter/material.dart';

class ProductsGridView extends StatefulWidget {
  List<ProductFetcher> products;
    ProductsGridView({Key? key,required this.products}) : super(key: key);

  @override
  _ProductsGridViewState createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends State<ProductsGridView> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.products.length,
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return ProductCard(product: widget.products[index]);
        },
    );
  }
}

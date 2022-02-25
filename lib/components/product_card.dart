import 'package:bustank/fetcher/product.dart';
import 'package:bustank/screens/products_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ProductCard extends StatelessWidget {
  final ProductFetcher product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.grey, offset: Offset(-1, -1), blurRadius: 5)
        ],
      ),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetails(
                  product: product,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              Image.network(
                product.pictures[0],
                fit: BoxFit.cover,
              ),
              if (product.featured)
                const Positioned(
                  top: 2,
                  left: 2,
                  child: Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 25,
                  ),
                ),
            ],
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black38,
          leading: Text(
            product.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          title: Text(
            "${product.price} JD",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

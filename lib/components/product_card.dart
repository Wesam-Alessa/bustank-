import 'package:bustank/fetcher/product.dart';
import 'package:bustank/screens/products_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'loading.dart';

class ProductCard extends StatelessWidget {
  final ProductFetcher product;

   const ProductCard({Key? key,required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (product.id.isNotEmpty  && product.featured == true) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetails(
                        product: product,
                      )),
            );
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey, offset: Offset(-1, -1), blurRadius: 5)
                ],
            ),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: <Widget>[
                        const Positioned.fill(
                            child: Align(
                          alignment: Alignment.center,
                          child: Loading(),
                        )),
                        Center(
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: product.pictures[0],
                            fit: BoxFit.fill,
                            height: 100,
                            width: 140,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${product.name} \n',
                              style: const TextStyle(fontSize: 18),
                            ),
                            TextSpan(
                              text: 'by: ${product.brand} \n\n',
                              style:
                                  const TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            TextSpan(
                              text: '${product.price}  JD\t',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 35,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else if (product != null) {
     return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetails(
                        product: product,
                      )),
            );
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey, offset: Offset(-1, -1), blurRadius: 5)
                ]),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: <Widget>[
                        const Positioned.fill(
                            child: Align(
                          alignment: Alignment.center,
                          child: Loading(),
                        )),
                        Center(
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: product.pictures[0],
                            fit: BoxFit.fill,
                            height: 100,
                            width: 140,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${product.name} \n',
                        style: const TextStyle(fontSize: 20),
                      ),
                      TextSpan(
                        text: 'by: ${product.brand} \n\n',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      TextSpan(
                        text: '${product.price}  JD\t',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const Text("Not Found");
    }
  }
}

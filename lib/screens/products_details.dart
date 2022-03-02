// ignore_for_file: import_of_legacy_library_into_null_safe, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:bustank/components/loading.dart';
import 'package:bustank/fetcher/product.dart';
import 'package:bustank/home_page.dart';
import 'package:bustank/provider/app_provider.dart';
import 'package:bustank/provider/user_provider.dart';
import 'package:bustank/screens/full_image_screen.dart';

//import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart.dart';

class ProductDetails extends StatefulWidget {
  final ProductFetcher product;

  const ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final _key = GlobalKey<ScaffoldState>();
  String _size = '';
  String quantity = "0";
  int qnt = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _size = widget.product.size[0];
    qnt = int.parse(widget.product.quantity);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyHomePage()));
          },
          child: const Text("Bustank"),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 200.0,
              child: GridTile(
                child: ListView.builder(
                  itemCount: widget.product.pictures.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => FullImageScreen(
                              images: widget.product.pictures))),
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    widget.product.pictures[index]),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Text(
                                '${index + 1}/${widget.product.pictures.length}',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                footer: GridTileBar(
                  backgroundColor: Colors.black38,
                  leading: Text(
                    widget.product.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  title: SizedBox(
                    width: double.infinity,
                  ),
                  trailing: Text(
                    "${widget.product.price} JD",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: Text(
                          "Brand ",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2),
                        child: Text(
                          "conditions ",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2),
                        child: Text(
                          "Quantity Available",
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2),
                        child: Text(
                          "Size",
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: Text(
                            widget.product.brand,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: Text(
                            "New",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: Text(widget.product.quantity,
                              style: TextStyle(color: Colors.grey)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: Text(
                            _size,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 4),
              child: Text("Details"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(
                //"W/example.bustan( 3045): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)W/example.bustan( 3045): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)Reloaded 1 of 1334 libraries in 3,083ms.I/flutter ( 3045): 13W/example.bustan( 3045): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)W/example.bustan( 3045): Accessing hidden method Lsun/misc/Unsafe;->putLong(Ljava/lang/Object;JJ)V (greylist, linking, allowed)",
                widget.product.description,
              ),
            ),
            Divider(),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Quantity",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 8),
                        child: GestureDetector(
                          onTap: int.parse(quantity) > 0
                              ? () {
                                  setState(() {
                                    quantity =
                                        (int.parse(quantity) - 1).toString();
                                  });
                                }
                              : null,
                          child: CircleAvatar(
                            maxRadius: 15,
                            backgroundColor: Colors.blueGrey,
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 8),
                        child: CircleAvatar(
                            maxRadius: 20,
                            backgroundColor: Colors.blueGrey,
                            child: Text(
                              quantity,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 8),
                        child: GestureDetector(
                          onTap: qnt > int.parse(quantity)
                              ? () {
                                  setState(() {
                                    quantity =
                                        (int.parse(quantity) + 1).toString();
                                  });
                                }
                              : null,
                          child: CircleAvatar(
                            maxRadius: 15,
                            backgroundColor: Colors.blueGrey,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(22.0),
                    color: Colors.blueGrey,
                    elevation: 0.0,
                    child: MaterialButton(
                      onPressed: () async {
                        if (quantity == "0") {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('The quantity is 0!')));
                        } else {
                          appProvider.changeIsLoading();
                          bool success = await userProvider.addToCart(
                            product: widget.product,
                            size: _size,
                            quantity: quantity.toString(),
                          );
                          if (success) {
                            print("item added to cart");
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Added to Cart!')));
                            userProvider.reloadUserFetcher();
                            appProvider.changeIsLoading();
                            return;
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Item Not Added to Cart!')));
                            appProvider.changeIsLoading();
                            return;
                          }
                        }
                      },
                      minWidth: 280,
                      child: appProvider.isLoading
                          ? Loading()
                          : Text(
                              "Add to Cart",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  color: Colors.blueGrey,
                  onPressed: () async {
                    appProvider.changeIsLoading();
                    bool success = await userProvider.addToFavourites(
                      product: widget.product,
                    );
                    if (success) {
                      print("item added to favourites");
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added to Favourites!')));
                      userProvider.reloadUserFetcher();
                      appProvider.changeIsLoading();
                      return;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Item Not Added to Favourites!')));
                      appProvider.changeIsLoading();
                      return;
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

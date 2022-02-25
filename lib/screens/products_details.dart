// ignore_for_file: import_of_legacy_library_into_null_safe, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:bustank/components/loading.dart';
import 'package:bustank/fetcher/product.dart';
import 'package:bustank/home_page.dart';
import 'package:bustank/provider/app_provider.dart';
import 'package:bustank/provider/user_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
  final List _quantity = ['0'];
  var quantity = ['0'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _size = widget.product.size[0];
    //_quantity[0] = quantity[0];

    if (widget.product.size[0] == "50 Kg" ||
        widget.product.size[0] == "25 Kg" ||
        widget.product.size[0] == "10 Kg" ||
        widget.product.size[0] == "5 Liter" ||
        widget.product.size[0] == "2.5 Liter" ||
        widget.product.size[0] == "1 Liter") {
      int sizeIndex = _size.indexOf(' ');
      String size = _size.substring(0, sizeIndex);
      double sizeNum = double.parse(size);
      int qIndex = widget.product.quantity.indexOf(' ');
      if (qIndex != -1) {
        String quantity = widget.product.quantity.substring(0, qIndex);
        int qNum = int.parse(quantity);

        for (int i = 1; i <= qNum / sizeNum; i++) {
          _quantity.add(((i)).toString());
        }
      } else {
        int qNum = int.parse(widget.product.quantity);
        for (int i = 1; i <= qNum / sizeNum; i++) {
          _quantity.add(((i)).toString());
        }
      }
    } else {
      int qNum = int.parse(widget.product.quantity);
      for (int i = 0; i < qNum; i++) {
        _quantity.add(((i + 1)).toString());
      }
    }
  }

  //   if(z != -1 ){
  //     x = int.parse(_size.substring(0, z));
  //   }
  //   for (int i = 1; i <= y / x; i++) {
  //     quantity.add((i).toString());
  //   }
  // }else{
  //   qut = widget.product.quantity;
  //   int y = int.parse(qut);
  //   int z = _size.indexOf(' ');
  //   int x;
  //   if(z != -1 ){
  //     x = int.parse(_size.substring(0, z));
  //   }
  //   for (int i = 1; i <= y; i++) {
  //     quantity.add((i).toString());
  //   }
  // }

  // if (widget.product.size[0] == 'Small' ||
  //     widget.product.size[0] == 'Medium' ||
  //     widget.product.size[0] == 'Big'||
  //     widget.product.size[0] == '1-5 Acres'||
  //     widget.product.size[0] == '6-10 Acres'||
  //     widget.product.size[0] == 'up to 10'||
  //     widget.product.size[0] == '1 Month'||
  //     widget.product.size[0] == '2 Month'||
  //     widget.product.size[0] == '3 Month'||
  //     widget.product.size[0] == '4 Month'||
  //     widget.product.size[0] == '5 Month'||
  //     widget.product.size[0] == '6 Month') {
  //   for (int i = 1; i <= y; i++) {
  //     quantity.add((i).toString());
  //   }
  // } else {
  //   for (int i = 1; i <= y / x; i++) {
  //     quantity.add((i).toString());
  //   }
  // }

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
                    return Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  NetworkImage(widget.product.pictures[index]),
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
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
            // =======the  first buttons =============
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          "size",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: DropdownButton<String>(
                            value: _size,
                            style: TextStyle(color: Colors.black54),
                            items: widget.product.size
                                .map<DropdownMenuItem<String>>(
                                  (value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _size = value!;
                                _quantity.clear();
                                quantity[0] = '0';
                                if (_size == "50 Kg" ||
                                    _size == "25 Kg" ||
                                    _size == "10 Kg" ||
                                    _size == "5 Liter" ||
                                    _size == "2.5 Liter" ||
                                    _size == "1 Liter") {
                                  int sizeIndex = _size.indexOf(' ');
                                  String size = _size.substring(0, sizeIndex);
                                  double sizeNum = double.parse(size);
                                  int qIndex =
                                      widget.product.quantity.indexOf(' ');
                                  if (qIndex != -1) {
                                    String quantity = widget.product.quantity
                                        .substring(0, qIndex);
                                    int qNum = int.parse(quantity);

                                    for (int i = 0; i <= qNum / sizeNum; i++) {
                                      _quantity.add(((i)).toString());
                                    }
                                  } else {
                                    int qNum =
                                        int.parse(widget.product.quantity);
                                    for (int i = 0; i <= qNum / sizeNum; i++) {
                                      _quantity.add(((i)).toString());
                                    }
                                  }
                                } else {
                                  int qNum = int.parse(widget.product.quantity);
                                  for (int i = 0; i <= qNum; i++) {
                                    _quantity.add(((i)).toString());
                                  }
                                }
                              });
                            }),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "quantity",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: DropdownButton<String>(
                            value: quantity[0],
                            style: TextStyle(color: Colors.black54),
                            items: _quantity
                                .map<DropdownMenuItem<String>>(
                                  (value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                quantity[0] = value!;
                              });
                            }),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                  child: Text(
                    "Brand ",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    widget.product.brand,
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                  child: Text(
                    "conditions ",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "New",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                  child: Text(
                    "Quantity Available",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                  child: Text(widget.product.quantity,
                      style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 0.0),
              child: Text("Details"),
            ),
            //======= the second buttons =============
            ListTile(
              subtitle: Text(widget.product.description),
            ),
            Divider(),
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
                        if (quantity[0] == '0') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('The quantity is 0!')));
                        } else {
                          appProvider.changeIsLoading();
                          bool success = await userProvider.addToCart(
                            product: widget.product,
                            size: _size,
                            quantity: quantity[0],
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

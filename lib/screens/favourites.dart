// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, import_of_legacy_library_into_null_safe

import 'package:bustank/components/loading.dart';
import 'package:bustank/db/products.dart';
import 'package:bustank/fetcher/product.dart';
import 'package:bustank/provider/app_provider.dart';
import 'package:bustank/provider/user_provider.dart';
import 'package:bustank/screens/products_details.dart';
//import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//my import
//import 'package:bustank/components/cart_products.dart';
import 'package:provider/provider.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final _key = GlobalKey<ScaffoldState>();
  //OrderServices _orderServices = OrderServices();
  //TextEditingController _phoneTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Favourites'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
          child: appProvider.isLoading
              ? Loading()
              : ListView.builder(
                  itemCount: userProvider.userFetcher.favourites!.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: ()async{
                          ProductsService service = ProductsService();
                          String id = userProvider.userFetcher.favourites![index].id;
                          List<ProductFetcher> product = await service.getProductsFav(pId: id) as List<ProductFetcher> ;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                  product: product[0],
                                )
                            ),
                          );

                        },
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.blueGrey,
                                    offset: Offset(3, 2),
                                    blurRadius: 30)
                              ]),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                ),
                                child: imageCarousel(userProvider
                                    .userFetcher.favourites![index].pictures),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: userProvider.userFetcher
                                                    .favourites![index].name +
                                                "\n",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text:
                                                "by ${userProvider.userFetcher.favourites![index].brand} \n",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300)),
                                        TextSpan(
                                            text:
                                                "${userProvider.userFetcher.favourites![index].price} JD\n",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300)),
                                      ]),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        appProvider.changeIsLoading();
                                        bool success = await userProvider
                                            .removeFromFavourites(
                                            favItem: userProvider.userFetcher
                                                .favourites![index]);
                                        if (success) {
                                          print("Item Removed from Favourites");
                                          userProvider.reloadUserFetcher();
                                          appProvider.changeIsLoading();
                                          return;
                                        } else {
                                          appProvider.changeIsLoading();
                                        }
                                      },
                                    ),


                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
    );
  }

  imageCarousel(List pictures) {
    return SizedBox(
      height: 120,
      width: 140,
      child:
          Image.network(
            "${pictures[0]}",
            fit: BoxFit.fill,
          ),
      // Carousel(
      //   boxFit: BoxFit.fill,
      //   images: [
      //     Image.network(
      //       "${pictures[0]}",
      //       fit: BoxFit.fill,
      //     ),
      //     Image.network(
      //       "${pictures[1]}",
      //       fit: BoxFit.fill,
      //     ),
      //     Image.network(
      //       "${pictures[2]}",
      //       fit: BoxFit.fill,
      //     ),
      //   ],
      //   autoplay: false,
      //   //animationCurve: Curves.fastOutSlowIn,
      //   //animationDuration: Duration(microseconds: 1000),
      //   dotSize: (0),
      //   indicatorBgPadding: 5.7,
      //   dotBgColor: Colors.transparent,
      // ),
    );
  }
}

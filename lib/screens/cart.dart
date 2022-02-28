// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:bustank/components/loading.dart';
import 'package:bustank/db/order.dart';
import 'package:bustank/fetcher/cart_items.dart';
import 'package:bustank/provider/app_provider.dart';
import 'package:bustank/provider/user_provider.dart';

// ignore: import_of_legacy_library_into_null_safe
//import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//my import
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _key = GlobalKey<ScaffoldState>();
  final OrderServices _orderServices = OrderServices();
  final TextEditingController _phoneTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
        child: appProvider.isLoading
            ? const Loading()
            : ListView.builder(
                itemCount: userProvider.userFetcher.cart!.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.blueGrey,
                              offset: Offset(3, 2),
                              blurRadius: 30)
                        ],
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius:BorderRadius.all(Radius.circular(10)) ,
                                  child: buildImage(userProvider
                                      .userFetcher.cart![index].pictures[0]),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      userProvider.userFetcher.cart![index].name,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "qnt ${userProvider.userFetcher.cart![index].quantity}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      "size ${userProvider.userFetcher.cart![index].size}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      "${userProvider.userFetcher.cart![index].price} JD",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      "total ${(userProvider.userFetcher.cart![index].price * double.parse(userProvider.userFetcher.cart![index].quantity) * totalPrice(userProvider.userFetcher.cart![index])).truncate()} JD",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 1,
                            top: 1,
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.grey,
                              ),
                              onPressed: () async {
                                appProvider.changeIsLoading();
                                bool success =
                                    await userProvider.removeFromCart(
                                        cartItem: userProvider
                                            .userFetcher.cart![index]);
                                if (success) {
                                  print("Item Removed from Cart");
                                  userProvider.reloadUserFetcher();
                                  appProvider.changeIsLoading();
                                  return;
                                } else {
                                  appProvider.changeIsLoading();
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Total :",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 22,
                          fontWeight: FontWeight.w400),
                    ),
                    TextSpan(
                      text: " \$${userProvider.userFetcher.totalCartPrice!.truncate()}",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                onPressed: () {
                  if (userProvider.userFetcher.totalCartPrice == 0) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: SizedBox(
                            height: 200,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const <Widget>[
                                  Text(
                                    "Your cart is empty",
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                    return;
                  }
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        child: SizedBox(
                          height: 250,
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "You will be charged ${userProvider.userFetcher.totalCartPrice} upon delivery !",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                    width: 320.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0.0),
                                      child: ListTile(
                                        title: TextFormField(
                                          controller: _phoneTextController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Phone Number",
                                            icon: Icon(Icons.phone_in_talk),
                                          ),
                                          validator: (value) {
                                            return null;
                                          },
                                        ),
                                      ),
                                    )),
                                SizedBox(
                                  child: Text(
                                    "If the phone number is wrong, the request will be canceled",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                SizedBox(
                                  width: 320.0,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      var value = _phoneTextController.text;
                                      if (value.isEmpty || value.length != 10) {
                                        print("Enter correct Phone Number");
                                      } else {
                                        List names = [];
                                        var uuid = Uuid();
                                        String id = uuid.v4();
                                        for (CartItemFetcher cartItem
                                            in userProvider.userFetcher.cart!) {
                                          names.add(cartItem.name);
                                        }
                                        _orderServices.createOrder(
                                            userId: userProvider.user.uid,
                                            id: id,
                                            description: names,
                                            orderStatus: "Complete",
                                            receiptStatus: '',
                                            totalPrice: userProvider
                                                .userFetcher.totalCartPrice!,
                                            cart:
                                                userProvider.userFetcher.cart!,
                                            phoneNumber:
                                                _phoneTextController.text);
                                        for (CartItemFetcher cartItem
                                            in userProvider.userFetcher.cart!) {
                                          names.add(cartItem.name);
                                          bool value =
                                              await userProvider.removeFromCart(
                                                  cartItem: cartItem);
                                          if (value) {
                                            userProvider.reloadUserFetcher();
                                            print("Item Added to cart");
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Removed from Cart!")));
                                          } else {
                                            print("ITEM WAS NOT REMOVED");
                                          }
                                        }
                                        //_key.currentState!.
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text("Order created!")));

                                        Navigator.pop(context);
                                        _phoneTextController.text = "";
                                      }
                                    },
                                    child: Text(
                                      "Accept",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    //color: Colors.blueGrey,
                                  ),
                                ),
                                SizedBox(
                                  width: 320.0,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red[300]!.withOpacity(1),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Reject",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  "Check out",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildImage(String pictures) {
    return SizedBox(
      height: 120,
      width: 140,
      child: Image.network(
        pictures,
        fit: BoxFit.fill,
      ),
    );
  }

  num totalPrice(CartItemFetcher cart) {
    int indexNum = cart.size.indexOf(' ');
    double num;
    if (indexNum != -1) {
      num = double.parse(cart.size.substring(0, indexNum));
    } else {
      num = 1;
    }
    return num;
  }
}

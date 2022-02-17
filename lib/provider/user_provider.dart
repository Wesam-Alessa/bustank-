// ignore_for_file: avoid_print, constant_identifier_names

import 'package:bustank/db/favourites.dart';
import 'package:bustank/db/order.dart';
import 'package:bustank/db/users.dart';
import 'package:bustank/fetcher/cart_items.dart';
import 'package:bustank/fetcher/fav_items.dart';
import 'package:bustank/fetcher/order.dart';
import 'package:bustank/fetcher/product.dart';
import 'package:bustank/fetcher/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth;
  late User _user;
  Status _status = Status.Uninitialized;
  final UserServices _userServices = UserServices();
   late UserFetcher _userFetcher;
  final OrderServices _orderServices = OrderServices();
  final FavouritesServices _favouritesServices = FavouritesServices();

  //public variables
  List<OrderFetcher> orders = [];
  List<FavItemFetcher> favourites = [];

//    getter
  Status get status => _status;

  User get user => _user;

  UserFetcher get userFetcher => _userFetcher;

  UserProvider.initialized() : _auth = FirebaseAuth.instance {
    _userFetcher = UserFetcher(
      cart: [],
      email: '',
      favourites: [],
      id: '',
      name: '',
      picture: '',
      priceSum: 0,
      stripeId: '',
      totalCartPrice: 0
    );
    _auth.authStateChanges().listen((event) {
      event != null ?
          _onStateChanged(event) :
          _onStateChanged(null);
    });
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) {
        _userServices.createUser({
          "name": name,
          "email": email,
          "password" : password.hashCode,
          "userId": user.user!.uid,
          "picture": "https://firebasestorage.googleapis.com/v0/b/bustank-36ea0.appspot.com/o/1607444060982.jpg?alt=media&token=c035d686-ca3f-43d3-baa3-06afa94f50bf",
          "cart": [],
          "favourites": []
        });
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return;
  }

  void _onStateChanged(User? user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = user;
      _userFetcher = await _userServices.getUserById(user.uid);
      print("CART ITEMS: ${_userFetcher.cart!.length}");
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

  Future<bool> addToCart({
    ProductFetcher? product,
    String? size,
    String? quantity,
  }) async {
    try {
      var uuid = const Uuid();
      String cartItemId = uuid.v4();
      List<CartItemFetcher> cart = _userFetcher.cart!;

      Map<String,dynamic> cartItem = {
        "id": cartItemId,
        "name": product!.name,
        "pictures": product.pictures,
        "productId": product.id,
        "price": product.price,
        "size": size,
        "quantity": quantity,
        "brand": product.brand,
        'category': product.category,
        "description": product.description,
        "featured": product.featured
      };

      CartItemFetcher item = CartItemFetcher.fromMap(cartItem);
      print("CART ITEMS ARE: ${cart.toString()}");
      _userServices.addToCart(userId: _user.uid, cartItemFetcher: item);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> addToFavourites({required ProductFetcher product}) async {
    try {
      List<FavItemFetcher> favourites = _userFetcher.favourites!;
      Map<String,dynamic> favouritesItem = {
        "id": product.id,
        "name": product.name,
        "pictures": product.pictures,
        "quantity": product.quantity,
        "price": product.price,
        "brand": product.brand,
        'category': product.category,
        "description": product.description,
        "featured": product.featured,
        'size': product.size
      };
      FavItemFetcher item = FavItemFetcher.fromMap(favouritesItem);
      print("FAVOURITE ITEMS ARE: ${favourites.toString()}");
      _userServices.addToFavourites(userId: _user.uid, favItemFetcher: item);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> removeFromCart({required CartItemFetcher cartItem}) async {
    print("THE PRODUCTS IS : ${cartItem.toString()}");
    try {
      _userServices.removeFromCart(
          userId: _user.uid, cartItemFetcher: cartItem);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<bool> removeFromFavourites({required FavItemFetcher favItem}) async {
    print("THE PRODUCTS IS : ${favItem.toString()}");
    try {
      _userServices.removeFromFavourites(
          userId: _user.uid, favItemFetcher: favItem);
      return true;
    } catch (e) {
      print("THE ERROR ${e.toString()}");
      return false;
    }
  }

  Future<void> reloadUserFetcher() async {
    _userFetcher = await _userServices.getUserById(user.uid);
    notifyListeners();
  }

  Future<void> getOrders() async {
    orders = await _orderServices.getUserOrders(userId: _user.uid);
    notifyListeners();
  }

  Future<void> getFavourites() async {
    favourites = await _favouritesServices.getUserFavourites(userId: _user.uid);
    notifyListeners();
  }
}

// ignore_for_file: avoid_print, constant_identifier_names

import 'package:bustank/fetcher/cart_items.dart';
import 'fav_items.dart';

class UserFetcher {
  static const String NAME = 'name';
  static const String ID = 'id';
  static const String EMAIL = 'email';
  static const String STRIPE_ID = 'stripeId';
  static const String CART = 'cart';
  static const String FAVOURITES = 'favourites';
  static const String PICTURE = 'picture';

  String? name;
  String? id;
  String? email;
  String? stripeId;
  double priceSum = 0;
  String? picture;


  //public varibles
  List<CartItemFetcher>? cart;
  List<FavItemFetcher>? favourites;
  double? totalCartPrice;

  //getter
  String get getName => name!;

  String get getId => id!;

  String get getEmail => email!;

  String get getStripeId => stripeId!;

  String get getPicture => picture!;


  UserFetcher(
      {
       required this.id,
        required this.email,
        required this.name,
        required this.picture,
        required this.stripeId,
        required this.priceSum,
        required  this.cart,
        required this.favourites,
        required this.totalCartPrice});

  UserFetcher.fromSnapshot(Map<String,dynamic> snapshot) {
    name = snapshot[NAME];
    id = snapshot[ID];
    email = snapshot[EMAIL];
    stripeId = snapshot[STRIPE_ID] ?? "";
    picture = snapshot[PICTURE];
    cart = _convertCartItems(snapshot[CART] ?? []);
    favourites = _convertFavItems(snapshot[FAVOURITES] ?? []);
    totalCartPrice = snapshot[CART] == null ? 0 :getTotalPrice(cart: snapshot[CART]);
  }

  List<CartItemFetcher> _convertCartItems(List cart) {
    List<CartItemFetcher> convertedCart = [];
    for (Map<String,dynamic> cartItem in cart) {
      convertedCart.add(CartItemFetcher.fromMap(cartItem));
    }
    return convertedCart;
  }

  List<FavItemFetcher> _convertFavItems(List favourites) {
    List<FavItemFetcher> convertedFav = [];
    for (Map<String,dynamic> favItem in favourites) {
      convertedFav.add(FavItemFetcher.fromMap(favItem));
    }
    return convertedFav;
  }

  double getTotalPrice({List? cart}){
    if(cart == null){
      return 0;
    }
    for(Map<String,dynamic> cartItem in cart){
      int x = int.parse(cartItem['quantity']);
      int z =(cartItem['size'].indexOf(' '));
      String y;
      print('index $z');
      if(z != -1){
         y = (cartItem['size'].substring(0,z));
        priceSum += (cartItem["price"] * x * double.parse(y)) ;
      }else{
        priceSum += (cartItem["price"] * x * 1) ;
      }
    }
    double total = priceSum;
    print(priceSum);
    return total;
  }
}
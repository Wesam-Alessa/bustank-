// ignore_for_file: avoid_print


import 'package:bustank/fetcher/cart_items.dart';
import 'package:bustank/fetcher/fav_items.dart';
import 'package:bustank/fetcher/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String ref = "users";



  void createUser(Map value) {
    _database
        .ref()
        .child("$ref/${value['userId']}")
        .set(value)
        .catchError((e)=> print(e));
    _fireStore.collection(ref).doc(value['userId']).set({
      'userId': value['userId'],
      'name': value['name'],
      "password" : value['password'],
      'email': value['email'],
      "cart" : value['cart'],
      "picture" : value['picture'],
      "favourites" : value['favourites'],
      'address':value['address'],
    });
  }

  Future<UserFetcher> getUserById(String id) =>
      _fireStore.collection(ref).doc(id).get().then((doc) {
        return UserFetcher.fromSnapshot(doc.data()!);
      });


  void addToCart({required String userId,required CartItemFetcher cartItemFetcher}){
    _fireStore.collection(ref).doc(userId).update({
      "cart" :FieldValue.arrayUnion([cartItemFetcher.toMap()])
    });
  }

  void addToFavourites({required String userId,required FavItemFetcher favItemFetcher}){
    _fireStore.collection(ref).doc(userId).update({
      "favourites":FieldValue.arrayUnion([favItemFetcher.toMap()])
    });
  }

  void removeFromCart({required String userId,required CartItemFetcher cartItemFetcher}){
    _fireStore.collection(ref).doc(userId).update({
      "cart":FieldValue.arrayRemove([cartItemFetcher.toMap()])
    });
  }

  void removeFromFavourites({required String userId,required FavItemFetcher favItemFetcher}){
    _fireStore.collection(ref).doc(userId).update({
      "favourites":FieldValue.arrayRemove([favItemFetcher.toMap()])
    });
  }
}

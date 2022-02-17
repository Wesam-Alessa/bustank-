import 'package:bustank/fetcher/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class ProductsService{
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String collection = 'products';

  Future<List<ProductFetcher>> getProducts() async =>
      _fireStore.collection(collection).get().then((result){
        List<ProductFetcher> products = [];
        for(var product in result.docs){
          products.add(ProductFetcher.fromSnapshot(product.data()));
        }
        return products;
      });

  Future<List<ProductFetcher>> getProductsFav({required String pId}) async =>
      _fireStore.collection(collection).
      where('id', isEqualTo: pId).
      get().
      then((result){
        List<ProductFetcher> products = [];
        for(var product in result.docs){
          products.add(ProductFetcher.fromSnapshot(product.data() ));
        }
        return products;
      });



  Future<List<ProductFetcher>> searchProducts({required String productName}) {
    // code to convert the first character to uppercase
    String searchKey = productName[0].toUpperCase() + productName.substring(1);
    return _fireStore
        .collection(collection)
        .orderBy("name")
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .get()
        .then((result) {
      List<ProductFetcher> products = [];
      for (var product in result.docs) {
        products.add(ProductFetcher.fromSnapshot(product.data() ));
      }
      return products;
    });
  }
}
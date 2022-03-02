
import 'package:bustank/fetcher/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';



class ProductsService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  String collection = 'products';
  List<ProductFetcher> allProducts = [];

  Future<List<ProductFetcher>> getProducts() async =>
      _fireStore.collection(collection).get().then((result) {
        List<ProductFetcher> products = [];
        for (var product in result.docs) {
          products.add(ProductFetcher.fromSnapshot(product.data(), product.id));
        }
        allProducts = products;
        return products;
      });

  Future<List<ProductFetcher>> getProductsFav({required String pId}) async =>
      _fireStore
          .collection(collection)
          .where('id', isEqualTo: pId)
          .get()
          .then((result) {
        List<ProductFetcher> products = [];
        for (var product in result.docs) {
          products.add(ProductFetcher.fromSnapshot(product.data(), product.id));
        }
        return products;
      });

  List<ProductFetcher> searchProducts({required String productName}) {
    // code to convert the first character to lowercase
    String searchKey = productName[0].toLowerCase() + productName.substring(1);
    List<ProductFetcher> products = [];
    for (var element in allProducts) {
      if (element.name.toLowerCase().startsWith(searchKey)) {
        products.add(element);
      }
    }
    return products;
  }
}

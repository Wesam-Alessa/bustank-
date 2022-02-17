// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:bustank/db/products.dart';
import 'package:bustank/fetcher/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider with ChangeNotifier {

  final ProductsService _productServices = ProductsService();
  List<ProductFetcher> products = [];
  List<ProductFetcher> productsFeatured = [];
  List<ProductFetcher> seeds = [];
  List<ProductFetcher> trees = [];
  List<ProductFetcher> farmTools = [];
  List<ProductFetcher> gardenTools = [];
  List<ProductFetcher> landForRent = [];
  List<ProductFetcher> insecticide = [];
  List<ProductFetcher> agricultureDesigns = [];
  List<ProductFetcher> agricultureWorkers = [];
  List<ProductFetcher> productsSearched = [];

  ProductProvider.initialize() {
    FirebaseAuth.instance.currentUser != null?
    loadProducts()
    :null;
  }

 Future<void> loadProducts() async {
    products = await _productServices.getProducts();
    print(products.length);
    for (int i = 0; i < products.length; i++) {
      if (products[i].featured == true) {
        productsFeatured.add(products[i]);
      }
      switch(products[i].category){
        case 'Seeds':
          seeds.add(products[i]);
              break;
        case 'Trees':
          trees.add(products[i]);
          break;
        case 'Farm Tools':
          farmTools.add(products[i]);
          break;
        case 'Garden Tools':
          gardenTools.add(products[i]);
          break;
        case 'Land For Rent':
          landForRent.add(products[i]);
          break;
        case 'insecticide':
          insecticide.add(products[i]);
          break;
        case 'Agriculture Designs':
          agricultureDesigns.add(products[i]);
          break;
        case 'Agriculture Workers':
          agricultureWorkers.add(products[i]);
          break;
      }
    }
    notifyListeners();
  }

  List<ProductFetcher> getSimilarProducts(String ProductCategory){
    List<ProductFetcher> p = [];
    switch(ProductCategory){
      case 'Seeds':
       return p = seeds;
      case 'Trees':
        return p = trees;
      case 'Farm Tools':
        return p =farmTools;
      case 'Garden Tools':
        return p =gardenTools;
      case 'Land For Rent':
        return p =landForRent;
      case 'insecticide':
        return p =insecticide;
      case 'Agriculture Design':
        return p =agricultureDesigns;
      case 'Agriculture Workers':
        return p =agricultureWorkers;
    }
    return p;
  }

  Future search({required String productName}) async {
    productsSearched =
        await _productServices.searchProducts(productName: productName);
    notifyListeners();
  }
}

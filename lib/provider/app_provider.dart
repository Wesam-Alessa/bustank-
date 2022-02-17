import 'package:bustank/db/products.dart';
import 'package:bustank/fetcher/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AppProvider with ChangeNotifier{
  List<ProductFetcher> _featureProducts = [];
  final ProductsService _productsService = ProductsService();
  bool isLoading = false;

  void changeIsLoading(){
    isLoading =!isLoading;
    notifyListeners();
  }

  AppProvider() {
  _getFeaturedProducts();
  }

//  getter
  List<ProductFetcher> get featureProducts => _featureProducts;

//  methods
  Future<void> _getFeaturedProducts() async {
  _featureProducts = await _productsService.getProducts();
    notifyListeners();
  }
  }

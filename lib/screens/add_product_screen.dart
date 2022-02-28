// ignore_for_file: avoid_print

import 'dart:io';

import 'package:bustank/db/products.dart';
import 'package:bustank/fetcher/product.dart';
import 'package:bustank/provider/product_provider.dart';
import 'package:bustank/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _key = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController brand = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController size = TextEditingController();
  TextEditingController featured = TextEditingController();
  TextEditingController description = TextEditingController();
  List<File> images = [];
  ImagePicker picker = ImagePicker();
  String nameSelected = '';
  String sizesSelected = '';
  bool loading = false;
  bool uploading = false;
  double val = 0;
  List<String> urls = [];


  @override
  void dispose() {
    // TODO: implement dispose
    name.dispose();
    category.dispose();
    brand.dispose();
    quantity.dispose();
    price.dispose();
    size.dispose();
    featured.dispose();
    description.dispose();
    images.clear();
    super.dispose();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        images.add(File(response.file!.path));
      });
    } else {
      print(response.file);
    }
  }


  Future uploadFile(String id) async {
    int i = 1;
    for (var img in images) {
      setState(() {
        val = i / images.length;
      });
     var ref = FirebaseStorage.instance
          .ref()
          .child('images/$id/${path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          urls.add(value);
          i++;
        });
      });
    }
  }

  Future uploadProduct({required ProductFetcher product}) async {
    if(urls != [] ){
      product.setPictures(urls);
      await FirebaseFirestore.instance
          .collection('products')
          .add(product.toMap())
          .then((value) {
      }).catchError((onError) {
        throw onError;
      });
    }
    else {
      product.setPictures(urls);
      await FirebaseFirestore.instance
          .collection('products')
          .add(product.toMap())
          .then((value) {
      }).catchError((onError) {
        throw onError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var userService = Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Add Product'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () {
              if (_key.currentState!.validate()) {
                setState(() {
                  uploading = true;
                });
                uploadFile(userService.user.uid).whenComplete((){
                  ProductFetcher product = ProductFetcher(
                    name.text,
                    '',
                    userService.user.uid,
                    nameSelected,
                    brand.text,
                    quantity.text,
                    double.parse(price.text),
                    [sizesSelected],
                    images,
                    false,
                    description.text,);
                  uploadProduct(product: product).whenComplete(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.blue,
                        content: Text('added product'),
                      ),
                    );
                    setState(() {
                      uploading = false;
                    });
                    Navigator.of(context).pop();
                  }).catchError((onError) {
                    print(onError.toString());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(onError.toString()),
                      ),
                    );
                    setState(() {
                      uploading = false;
                    });
                  });
                });
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _key,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      if(loading) const LinearProgressIndicator(),
                      const Text('Add Photos'),
                      GestureDetector(
                        onTap: () async {
                          images.clear();
                          List<XFile>? _images = await picker.pickMultiImage();
                          if(_images != null){
                            for (var element in _images) {
                              images.add(File(element.path));
                            }
                            setState(() {});
                          }
                          retrieveLostData();
                          setState(() {});

                        },
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: images.isNotEmpty
                              ? ListView.builder(
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: images.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: images.length > 1
                                          ? MediaQuery.of(context).size.width * 0.3
                                          : MediaQuery.of(context).size.width * 0.95,
                                      margin:images.length > 1 ?
                                      const EdgeInsets.symmetric(horizontal: 2):null,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: FileImage(images[index]),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : const Icon(Icons.add),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //********** static const String NAME = 'name';
                      //********** static const String BRAND = 'brand';
                      //********** static const String QUANTITY = 'quantity';
                      //********** static const String PRICE = 'price';
                      //********** static const String DESCRIPTION = "description";
                      //********** static const String CATEGORY = 'category';

                      // static const String SIZE = 'size';
                      // static const String FEATURED = "featured";

                      TextFormField(
                        controller: name,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueGrey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey),
                            ),
                            hintText: "name",
                            labelText: 'Product Name',
                            labelStyle: TextStyle(color: Colors.blue),
                            icon: Icon(
                              Icons.label_important_outline,
                              color: Colors.blueGrey,
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'The name field cannot be left blank';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: brand,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueGrey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueGrey),
                          ),
                          hintText: "brand",
                          labelText: 'Brand Name',
                          labelStyle: TextStyle(color: Colors.blue),
                          icon: Icon(
                            Icons.brightness_auto_outlined,
                            color: Colors.blueGrey,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'The brand field cannot be left blank';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: quantity,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueGrey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey),
                            ),
                            hintText: "Enter the quantity in kilograms (Kg)",
                            labelText: 'Quantity',
                            labelStyle: TextStyle(color: Colors.blue),
                            icon: Icon(
                              Icons.sanitizer_outlined,
                              color: Colors.blueGrey,
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'The quantity field cannot be left blank';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: price,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueGrey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey),
                            ),
                            hintText: "price",
                            labelText: 'Price',
                            labelStyle: TextStyle(color: Colors.blue),
                            icon: Icon(
                              Icons.money,
                              color: Colors.blueGrey,
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'The price field cannot be left blank';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: description,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueGrey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey),
                            ),
                            hintText: "write product description",
                            labelText: 'Description',
                            labelStyle: TextStyle(color: Colors.blue),
                            icon: Icon(
                              Icons.description_outlined,
                              color: Colors.blueGrey,
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'The description field cannot be left blank';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('Select Category'),
                      const SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                nameSelected = 'Seeds';
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: nameSelected == 'Seeds'
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Text(
                                  'Seeds',
                                  style: TextStyle(
                                      color: nameSelected == 'Seeds'
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                nameSelected = 'Trees';
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: nameSelected == 'Trees'
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Text(
                                  'Trees',
                                  style: TextStyle(
                                      color: nameSelected == 'Trees'
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                nameSelected = 'Farm Tools';
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: nameSelected == 'Farm Tools'
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Text(
                                  'Farm Tools',
                                  style: TextStyle(
                                      color: nameSelected == 'Farm Tools'
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                nameSelected = 'Garden Tools';
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: nameSelected == 'Garden Tools'
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Text(
                                  'Garden Tools',
                                  style: TextStyle(
                                      color: nameSelected == 'Garden Tools'
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                nameSelected = 'Land for Rent';
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: nameSelected == 'Land for Rent'
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Text(
                                  'Land for Rent',
                                  style: TextStyle(
                                      color: nameSelected == 'Land for Rent'
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                nameSelected = 'Insecticide';
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: nameSelected == 'Insecticide'
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Text(
                                  'Insecticide',
                                  style: TextStyle(
                                      color: nameSelected == 'Insecticide'
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                nameSelected = 'Workers';
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: nameSelected == 'Workers'
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Text(
                                  'Workers',
                                  style: TextStyle(
                                      color: nameSelected == 'Workers'
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                nameSelected = 'Designs';
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: nameSelected == 'Designs'
                                      ? Colors.blue
                                      : Colors.grey[300],
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Text(
                                  'Designs',
                                  style: TextStyle(
                                      color: nameSelected == 'Designs'
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      if (nameSelected == 'Seeds') const Text('Select Size'),
                      if (nameSelected == 'Seeds')
                        Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                onTap: () {
                                  sizesSelected = '1 kg';
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: sizesSelected == '1 kg'
                                        ? Colors.blue
                                        : Colors.grey[300],
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Text(
                                    '1 kg',
                                    style: TextStyle(
                                        color: sizesSelected == '1 kg'
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                onTap: () {
                                  sizesSelected = '5 kg';
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: sizesSelected == '5 kg'
                                        ? Colors.blue
                                        : Colors.grey[300],
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Text(
                                    '5 kg',
                                    style: TextStyle(
                                        color: sizesSelected == '5 kg'
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                onTap: () {
                                  sizesSelected = '10 kg';
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: sizesSelected == '10 kg'
                                        ? Colors.blue
                                        : Colors.grey[300],
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Text(
                                    '10 kg',
                                    style: TextStyle(
                                        color: sizesSelected == '10 kg'
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                onTap: () {
                                  sizesSelected = '25 kg';
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: sizesSelected == '25 kg'
                                        ? Colors.blue
                                        : Colors.grey[300],
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Text(
                                    '25 kg',
                                    style: TextStyle(
                                        color: sizesSelected == '25 kg'
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                onTap: () {
                                  sizesSelected = '50 kg';
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: sizesSelected == '50 kg'
                                        ? Colors.blue
                                        : Colors.grey[300],
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Text(
                                    '50 kg',
                                    style: TextStyle(
                                        color: sizesSelected == '50 kg'
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                      if (nameSelected == 'Trees' || nameSelected == 'Insecticide')
                        const Text('Select Size'),
                      if (nameSelected == 'Trees' || nameSelected == 'Insecticide')
                        Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                onTap: () {
                                  sizesSelected = 'Small';
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: sizesSelected == 'Small'
                                        ? Colors.blue
                                        : Colors.grey[300],
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Text(
                                    'Small',
                                    style: TextStyle(
                                        color: sizesSelected == 'Small'
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                onTap: () {
                                  sizesSelected = 'Big';
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: sizesSelected == 'Big'
                                        ? Colors.blue
                                        : Colors.grey[300],
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Text(
                                    'Big',
                                    style: TextStyle(
                                        color: sizesSelected == 'Big'
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          uploading
              ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'uploading...',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CircularProgressIndicator(
                    value: val,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  )
                ],
              ))
              : Container(),
        ],
      ),
    );
  }
}


// ignore_for_file: constant_identifier_names

class ProductFetcher{

 //constant
  static const String NAME = 'name';
  static const String ID = 'id';
  static const String USERID = 'userId';
  static const String CATEGORY = 'category';
  static const String BRAND = 'brand';
  static const String QUANTITY = 'quantity';
  static const String PRICE = 'price';
  static const String SIZE = 'size';
  static const String PICTURES = 'pictures';
  static const String FEATURED = "featured";
  static const String DESCRIPTION = "description";

 //private variables
   String? _name;
   String? _id;
   String? _userId;
   String? _category;
   String? _brand;
   String?_quantity;
   double? _price;
   List<dynamic>? _size;
   List<dynamic>? _pictures;
   bool? _featured ;
   String? _description ;

 //getters

  String get name => _name!;
  String get id => _id!;
  String get userId => _userId!;
  String get category => _category!;
  String get brand => _brand!;
  String get quantity => _quantity!;
  double get price => _price!;
  List<dynamic> get size => _size!;
  List<dynamic> get pictures => _pictures!;
  bool get featured => _featured!;
  String get description => _description!;

  void setPictures(List<String> newPictures) {
    _pictures = newPictures;
  }

  ProductFetcher(
    this._name,
    this._id,
    this._userId,
    this._category,
    this._brand,
    this._quantity,
    this._price,
    this._size,
    this._pictures,
    this._featured,
    this._description,
);

  ProductFetcher.fromSnapshot(Map<String,dynamic> snapshot,String id){
    _name = snapshot[NAME];
    _id = id;
    _userId = snapshot[USERID];
    _category = snapshot[CATEGORY];
    _brand = snapshot[BRAND];
    _quantity = snapshot[QUANTITY];
    _price = snapshot[PRICE];
    _size = snapshot[SIZE];
    _pictures = snapshot[PICTURES];
    _featured = snapshot[FEATURED];
    _description = snapshot[DESCRIPTION];
  }

  Map<String, dynamic> toMap() => {
   'name': _name ,
    'id': _id ,
    'userId': _userId ,
    'category':_category ,
    'brand': _brand ,
    'quantity':_quantity,
    'price': _price ,
    'size': _size ,
    'pictures':_pictures ,
    'featured': _featured ,
    'description': _description ,
  };

}
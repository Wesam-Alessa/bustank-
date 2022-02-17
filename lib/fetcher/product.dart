
// ignore_for_file: constant_identifier_names

class ProductFetcher{

 //constant
  static const String NAME = 'name';
  static const String ID = 'id';
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
  String get category => _category!;
  String get brand => _brand!;
  String get quantity => _quantity!;
  double get price => _price!;
  List<dynamic> get size => _size!;
  List<dynamic> get pictures => _pictures!;
  bool get featured => _featured!;
  String get description => _description!;

  ProductFetcher.fromSnapshot(Map<String,dynamic> snapshot){
    _name = snapshot[NAME];
    _id = snapshot[ID];
    _category = snapshot[CATEGORY];
    _brand = snapshot[BRAND];
    _quantity = snapshot[QUANTITY];
    _price = snapshot[PRICE];
    _size = snapshot[SIZE];
    _pictures = snapshot[PICTURES];
    _featured = snapshot[FEATURED];
    _description = snapshot[DESCRIPTION];
  }

}
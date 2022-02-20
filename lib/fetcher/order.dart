
// ignore_for_file: constant_identifier_names

class OrderFetcher {
  static const String ID = "id";
  static const String DESCRIPTION = "description";
  static const String CART = "cart";
  static const String USER_ID = "userId";
  static const String TOTAL = "total";
  static const String ORDERSTATUS = "orderStatus";
  static const String RECEIPTSTATUS = "receiptStatus";
  static const String CREATED_AT = "createdAt";
  static const String PHONENUMBER = "phoneNumber";

  String?_id;
  List<dynamic>?_description;
  String? _userId;
  String? _orderStatus;
  String? _receiptStatus;
  String? _phoneNumber;
  int? _createdAt;
  double? _total;


//  getters
  String get id => _id!;

  List<dynamic> get description => _description!;

  String get userId => _userId!;

  String get orderStatus => _orderStatus!;

  String get receiptStatus => _receiptStatus!;

  String get phoneNumber => _phoneNumber!;

  double get total => _total!;

  int get createdAt => _createdAt!;

  // public variable
  List? cart;

  OrderFetcher.fromSnapshot(Map<String,dynamic> snapshot) {
    _id = snapshot[ID];
    _description = snapshot[DESCRIPTION];
    _total = snapshot[TOTAL];
    _orderStatus = snapshot[ORDERSTATUS];
    _receiptStatus = snapshot[RECEIPTSTATUS];
    _userId = snapshot[USER_ID];
    _createdAt = snapshot[CREATED_AT];
    _phoneNumber = snapshot[PHONENUMBER];
    cart = snapshot[CART];

  }
}
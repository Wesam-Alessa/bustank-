import 'package:bustank/fetcher/cart_items.dart';
import 'package:bustank/fetcher/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderServices{
  String collection = "orders";
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  void createOrder({required String userId ,
    required  String id,required List description,required String orderStatus ,
    required  String receiptStatus,
    required  List<CartItemFetcher> cart,
    required  double totalPrice,required String phoneNumber}) {
    List<Map> convertedCart = [];

    for(CartItemFetcher item in cart){
      convertedCart.add(item.toMap());
    }

    _fireStore.collection(collection).doc(id).set({
      "userId": userId,
      "id": id,
      "cart": convertedCart,
      "total": totalPrice,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "description": description,
      "orderStatus": orderStatus,
      "receiptStatus":receiptStatus,
      "phoneNumber" : phoneNumber
    });
  }

  Future<List<OrderFetcher>> getUserOrders({required String userId}) async =>
      _fireStore
          .collection(collection)
          .where("userId", isEqualTo: userId)
          .get()
          .then((result) {
        List<OrderFetcher> orders = [];
        for (var order in result.docs) {
          orders.add(OrderFetcher.fromSnapshot(order.data() ));
        }
        return orders;
      });

}

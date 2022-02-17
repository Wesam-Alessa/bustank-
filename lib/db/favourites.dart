import 'package:bustank/fetcher/fav_items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavouritesServices{
  String collection = "favourites";
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  void createFavourites({required String userId ,
    required String id,required List description,
    required List<FavItemFetcher> favourites}) {
     List<Map> convertedFav = [];
    for(FavItemFetcher item in favourites){
      convertedFav.add(item.toMap());
    }
    fireStore.collection(collection).doc(id).set({
      "userId": userId,
      "id": id,
      "description": description,
    });
  }

  Future<List<FavItemFetcher>> getUserFavourites({required String userId}) async =>
      fireStore
          .collection(collection)
          .where("userId", isEqualTo: userId)
          .get()
          .then((result) {
        List<FavItemFetcher> favourites = [];
        for (var fav in result.docs) {
          favourites.add(FavItemFetcher.fromSnapshot(fav.data()));
        }
        return favourites;
      });

}

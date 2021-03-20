import 'package:all_items/all_items.dart';
import 'package:cat_items/datasource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:models/models.dart';
import 'package:shopify/constants.dart';

class FirebaseDataSource implements AllItemsDataSource, CatItemsDatasource {
  FirebaseFirestore _firestore;
  FirebaseAuth _auth;
  FirebaseDataSource(
      {required FirebaseFirestore firestore, required FirebaseAuth auth})
      : this._firestore = firestore,
        this._auth = auth;

  @override
  Future<List<Category>> getCats() async {
    var catsQuery = await _firestore.collection(CATS_COLLECTION).get();
    if (catsQuery.size > 0) {
      List<Category> cats = catsQuery.docs
          .map((snapshot) => Category.fromDocument(snapshot.data()!))
          .toList();
      return cats;
    } else {
      return List.empty();
    }
  }

  @override
  Future<List<Product>> getPopularItems() async {
    var itemsQuery = await _firestore
        .collection(PRODUCTS_COLLECTION)
        .where("isPopular", isEqualTo: true)
        .get();
    if (itemsQuery.size > 0) {
      List<Product> items = itemsQuery.docs
          .map((snapshot) => Product.fromDocument(snapshot.data()!))
          .toList();
      print("koko ${items.length}");
      return items;
    } else {
      return List.empty();
    }
  }

  @override
  Future<bool>? cashCats(List cats) {
    return null;
  }

  @override
  Future<void>? cashPopularItems(List<Product> cats) {
    return null;
  }

  @override
  void initCashDatabase() {
    return null;
  }

  @override
  Stream<int>? noNotifications() async* {
    var notificationDoc = _firestore
        .collection(USERS_COLLECTION)
        .doc(_auth.currentUser!.uid)
        .collection(NOTIFICATIONS_COLLECTION)
        .where("isReed", isEqualTo: false);

    yield* notificationDoc.snapshots().asyncMap((data) => data.docs.length);
  }

  @override
  Future<List<Product>> getItems(String catId, String lastId) async {
    var itemsQuery = lastId.isEmpty
        ? await _firestore
            .collection(PRODUCTS_COLLECTION)
            .where("catId", isEqualTo: catId)
            .orderBy("id")
            .limit(ITEMS_LIMIT)
            .get()
        : await _firestore
            .collection(PRODUCTS_COLLECTION)
            .where("catId", isEqualTo: catId)
            .orderBy("id")
            .limit(ITEMS_LIMIT)
            .startAfter([lastId]).get();
    if (itemsQuery.size > 0) {
      List<Product> items = itemsQuery.docs
          .map((snapshot) => Product.fromDocument(snapshot.data()!))
          .toList();
      return items;
    } else {
      return List.empty();
    }
  }

  @override
  Future cashItems(List<Product> items) {
    // TODO: implement cashItems
    throw UnimplementedError();
  }
}

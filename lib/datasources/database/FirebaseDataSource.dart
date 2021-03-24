import 'package:all_items/all_items.dart';
import 'package:cart/datasource.dart';
import 'package:cat_items/datasource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:models/models.dart';

import 'package:shopify/constants.dart';
import 'package:product_details/product_details.dart';

import 'package:app_bar/app_bar.dart';

class FirebaseDataSource
    implements
        AllItemsDataSource,
        CatItemsDatasource,
        AppBarDatasource,
        ProductDetailsDataSource,
        CartDataSource {
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
        .orderBy("created_at", descending: true)
        .limit(POPULAR_ITEMS_LIMIT)
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
  Stream<int> noNotifications() async* {
    var notificationDoc = _firestore
        .collection(USERS_COLLECTION)
        .doc(_auth.currentUser!.uid)
        .collection(NOTIFICATIONS_COLLECTION)
        .where("isReed", isEqualTo: false);

    yield* notificationDoc.snapshots().asyncMap((data) => data.docs.length);
  }

  @override
  Future<List<Product>> getItems(String catId, String lastId) async {
    var itemsQuery;
    if (catId.isEmpty) {
      itemsQuery = await _firestore
          .collection(PRODUCTS_COLLECTION)
          .where("isPopular", isEqualTo: true)
          .orderBy("id", descending: true)
          .limit(ITEMS_LIMIT)
          .get();
    } else {
      itemsQuery = lastId.isEmpty
          ? await _firestore
              .collection(PRODUCTS_COLLECTION)
              .where("catId", isEqualTo: catId)
              .orderBy("id", descending: true)
              .limit(ITEMS_LIMIT)
              .get()
          : await _firestore
              .collection(PRODUCTS_COLLECTION)
              .where("catId", isEqualTo: catId)
              .orderBy("id", descending: true)
              .limit(ITEMS_LIMIT)
              .startAfter([lastId]).get();
    }
    if (itemsQuery.size > 0) {
      List<Product> items = itemsQuery.docs
          .map((snapshot) => Product.fromDocument(snapshot.data()!))
          .toList();
      debugPrint("num items " + items.length.toString());
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

  @override
  Future addToCart(Cart cart) {
    var query = _firestore
        .collection(USERS_COLLECTION)
        .doc(_auth.currentUser!.uid)
        .collection(CART_COLLECTION);
    var cartMap = cart.product.tomap();
    cartMap["numOfItem"] = cart.numOfItem;
    cartMap["selectedColor"] = cart.selectedColor;
    cartMap["created_at"] = FieldValue.serverTimestamp();

    Cart.carts.add(cart);
    return query.doc(cart.product.id).set(cartMap);
  }

  @override
  Future<List<Cart>> getCarts() async {
    var query = await _firestore
        .collection(USERS_COLLECTION)
        .doc(_auth.currentUser!.uid)
        .collection(CART_COLLECTION)
        .orderBy("created_at", descending: true)
        .get();

    var carts = query.docs.map((cart) {
      Product product = Product.fromDocument(cart.data()!);
      var carts = Cart(
          product: product,
          numOfItem: cart.data()!["numOfItem"],
          selectedColor: cart.data()!["selectedColor"]);
      return carts;
    }).toList();
    Cart.carts.clear();
    Cart.carts.addAll(carts);
    return carts;
  }

  @override
  Future removeProduct(String productId) {
    var query = _firestore
        .collection(USERS_COLLECTION)
        .doc(_auth.currentUser!.uid)
        .collection(CART_COLLECTION);

    Cart.carts.removeWhere((cart) => cart.product.id == productId);
    return query.doc(productId).delete();
  }

  @override
  Future numCartProducts() async {
    var query = _firestore
        .collection(USERS_COLLECTION)
        .doc(_auth.currentUser!.uid)
        .collection(CART_COLLECTION);
    var carts = (await query.get()).docs.map((doc) {
      Product product = Product.fromDocument(doc.data()!);
      var carts = Cart(
          product: product,
          numOfItem: doc.data()!["numOfItem"],
          selectedColor: doc.data()!["selectedColor"]);
      return carts;
    });
    Cart.carts.clear();
    Cart.carts.addAll(carts);
    return carts.length;
  }

  @override
  Future removeFromCart(Cart cart) {
    var query = _firestore
        .collection(USERS_COLLECTION)
        .doc(_auth.currentUser!.uid)
        .collection(CART_COLLECTION);

    Cart.carts.removeWhere((cartL) => cartL.product.id == cart.product.id);
    return query.doc(cart.product.id).delete();
  }

  @override
  Future editProductCart(Cart cart) {
    var query = _firestore
        .collection(USERS_COLLECTION)
        .doc(_auth.currentUser!.uid)
        .collection(CART_COLLECTION);

    var map = cart.product.tomap();
    map["numOfItem"] = cart.numOfItem;
    map["selectedColor"] = cart.selectedColor;
    var cartIndex =
        Cart.carts.indexWhere((c) => c.product.id == cart.product.id);
    Cart.carts[cartIndex] = cart;
    return query.doc(cart.product.id).update(map);
  }
}

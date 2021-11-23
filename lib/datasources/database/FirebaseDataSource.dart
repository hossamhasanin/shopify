import 'package:all_items/all_items.dart';
import 'package:cart/datasource.dart';
import 'package:cat_items/datasource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorites/datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:models/models.dart';
import 'package:models/notification.dart' as N;
import 'package:orders/datasource.dart';
import 'package:pay/datasource.dart';

import 'package:shopify/constants.dart';
import 'package:product_details/product_details.dart';

import 'package:app_bar/app_bar.dart';
import 'package:shopify/widgets/utils/guid_gen.dart';

class FirebaseDataSource
    implements
        AllItemsDataSource,
        CatItemsDatasource,
        AppBarDatasource,
        ProductDetailsDataSource,
        CartDataSource,
        PayDatasource,
        OrdersDatasource,
        FavoritesDataSource {
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
      List<Product> items = itemsQuery.docs.map((snapshot) {
        var product = Product.fromDocument(snapshot.data()!);

        List? likedBy = snapshot.data()!["likedBy"];

        product = product.copy(
            isFavourite: likedBy == null
                ? false
                : likedBy.contains(_auth.currentUser!.uid));

        debugPrint("liked " + product.isFavourite.toString());

        return product;
      }).toList();
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

  // @override
  // Stream<List<N.Notification>> noNotifications() async* {
  //   var notificationDoc = _firestore
  //       .collection(USERS_COLLECTION)
  //       .doc(_auth.currentUser!.uid)
  //       .collection(NOTIFICATIONS_COLLECTION)
  //       .where("isReed", isEqualTo: false);

  //   yield* notificationDoc.snapshots().asyncMap((data) => data.docs
  //       .map((doc) => N.Notification.fromDocument(doc.data()!))
  //       .toList());
  // }

  @override
  Future<List<Product>> getItems(String catId, String lastId) async {
    QuerySnapshot itemsQuery;
    if (catId.isEmpty) {
      itemsQuery = await _firestore
          .collection(PRODUCTS_COLLECTION)
          .where("isPopular", isEqualTo: true)
          .orderBy("id", descending: true)
          .limit(ITEMS_LIMIT)
          .get();
    } else {
      debugPrint("from datasource catId " + catId);

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

    if (itemsQuery.docs.length > 0) {
      List<Product> items = itemsQuery.docs.map((snapshot) {
        var product = Product.fromDocument(snapshot.data()!);

        List? likedBy = snapshot.data()!["likedBy"];

        product = product.copy(
            isFavourite: likedBy == null
                ? false
                : likedBy.contains(_auth.currentUser!.uid));
        return product;
      }).toList();
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

  @override
  Future addAddress(Address address) {
    var query = _firestore
        .collection(USERS_COLLECTION)
        .doc(_auth.currentUser!.uid)
        .collection(ADRESS_COLLECTION);
    var id = GUIDGen.generate();
    var _address = address.copy(id: id);
    return query.doc(id).set(_address.tomap());
  }

  @override
  Future addOrder(Order order, List<Code> codes) async {
    return _firestore.runTransaction((transaction) async {
      var query = _firestore.collection(ORDER_COLLECTION);
      var id = GUIDGen.generate();
      var _order =
          order.copy(orderNum: id, payMethod: order.payMethod.split(".")[1]);
      var map = _order.tomap();
      map["created_at"] = FieldValue.serverTimestamp();
      map["userId"] = _auth.currentUser!.uid;
      transaction.set(query.doc(id), map);
      for (Cart cart in order.carts!) {
        var map = cart.product.tomap();
        map["numOfItem"] = cart.numOfItem;
        map["selectedColor"] = cart.selectedColor;
        transaction.set(
            query.doc(id).collection(CART_COLLECTION).doc(cart.product.id),
            map);
        transaction.delete(_firestore
            .collection(USERS_COLLECTION)
            .doc(_auth.currentUser!.uid)
            .collection(CART_COLLECTION)
            .doc(cart.product.id));
      }
      Cart.carts.clear();

      if (codes.isNotEmpty) {
        for (Code code in codes) {
          transaction.set(
              query.doc(id).collection(CODES_COLLECTION).doc(code.id),
              code.tomap());
        }
      }

      return Future.value();
    });
  }

  @override
  Future deleteAddress(Address address) {
    var query = _firestore
        .collection(USERS_COLLECTION)
        .doc(_auth.currentUser!.uid)
        .collection(ADRESS_COLLECTION);
    return query.doc(address.id).delete();
  }

  @override
  Future<List<Address>> getAddresses() async {
    var query = _firestore
        .collection(USERS_COLLECTION)
        .doc(_auth.currentUser!.uid)
        .collection(ADRESS_COLLECTION);

    var docs = await query.get();
    var addresses =
        docs.docs.map((doc) => Address.fromDocument(doc.data()!)).toList();
    return addresses;
  }

  @override
  Future upadateAddress(Address address) {
    var query = _firestore
        .collection(USERS_COLLECTION)
        .doc(_auth.currentUser!.uid)
        .collection(ADRESS_COLLECTION);
    return query.doc(address.id).update(address.tomap());
  }

  @override
  Future<Code?> findVoucherCode(String code) async {
    DateTime _now = DateTime.now();
    DateTime curDate = DateTime(_now.year, _now.month, _now.day, 0, 0);

    var query = await _firestore
        .collection(CODES_COLLECTION)
        .where("code", isEqualTo: code)
        .where('endsIn', isGreaterThanOrEqualTo: curDate)
        .orderBy('endsIn')
        .get();

    debugPrint("code is " + query.docs.toString());
    if (query.docs.length > 0) {
      var _code = Code.fromDocument(query.docs[0].data()!);
      if (curDate.compareTo(_code.startsIn!) > -1) {
        return _code;
      } else {
        return Future.value(null);
      }
    } else {
      return Future.value(null);
    }
  }

  @override
  Future cancelOrder(Order order) async {
    var query = _firestore.collection(ORDER_COLLECTION).doc(order.orderNum);

    var map = order.tomap();
    map["orderState"] = OrderStates.Cancelled.index;
    map["cancelledAt"] = FieldValue.serverTimestamp();
    return query.update(map);
  }

  @override
  Future<List<Cart>> getOrderdItems(String orderId) async {
    var query = await _firestore
        .collection(ORDER_COLLECTION)
        .doc(orderId)
        .collection(CART_COLLECTION)
        .get();

    debugPrint("carts docs " + query.docs.length.toString());
    var carts = query.docs.map((cart) {
      Product product = Product.fromDocument(cart.data()!);
      var carts = Cart(
          product: product,
          numOfItem: cart.data()!["numOfItem"],
          selectedColor: cart.data()!["selectedColor"]);
      return carts;
    }).toList();
    return carts;
  }

  @override
  Future<List<Order>> getOrders(String lastOrder) async {
    QuerySnapshot ordersQuery = lastOrder.isEmpty
        ? await _firestore
            .collection(ORDER_COLLECTION)
            .where("userId", isEqualTo: _auth.currentUser!.uid)
            .orderBy("orderNum")
            .limit(ITEMS_LIMIT)
            .get()
        : await _firestore
            .collection(ORDER_COLLECTION)
            .where("userId", isEqualTo: _auth.currentUser!.uid)
            .orderBy("orderNum")
            .limit(ITEMS_LIMIT)
            .startAfter([lastOrder]).get();

    DateTime _now = DateTime.now();

    debugPrint("num orders " + ordersQuery.docs.length.toString());
    debugPrint("num orders " + _auth.currentUser!.uid);

    if (ordersQuery.docs.length > 0) {
      List<Order> orders = [];
      ordersQuery.docs.forEach((snapshot) {
        var order = Order.fromDocument(snapshot.data()!);
        if (order.cancelledAt != null) {
          var diffrence = order.cancelledAt!.difference(_now).inDays;
          if (diffrence <= 2) {
            orders.add(order);
          }
        } else {
          orders.add(order);
        }
      });
      debugPrint("num orders " + orders.length.toString());
      return orders;
    } else {
      return List.empty();
    }
  }

  @override
  Future<List<Product>> getFavoriteProducts(String lastId) async {
    var query = lastId.isEmpty
        ? _firestore
            .collection(PRODUCTS_COLLECTION)
            .where("likedBy", arrayContains: _auth.currentUser!.uid)
            .orderBy("id")
            .limit(ITEMS_LIMIT)
        : _firestore
            .collection(PRODUCTS_COLLECTION)
            .where("likedBy", arrayContains: _auth.currentUser!.uid)
            .orderBy("id")
            .limit(ITEMS_LIMIT)
            .startAfter([lastId]);

    var items = (await query.get()).docs.map((doc) {
      var product = Product.fromDocument(doc.data()!);

      product = product.copy(isFavourite: true);

      return product;
    }).toList();
    return items;
  }

  @override
  Future toggelFavorite(Product product, bool state) async {
    var query = _firestore.collection(PRODUCTS_COLLECTION).doc(product.id);

    return query.update({
      "likedBy": state
          ? FieldValue.arrayUnion([_auth.currentUser!.uid])
          : FieldValue.arrayRemove([_auth.currentUser!.uid])
    });
  }
}

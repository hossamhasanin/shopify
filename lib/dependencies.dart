import 'package:all_items/all_items.dart';
import 'package:all_items/all_items_controller.dart';
import 'package:app_bar/app_bar.dart';
import 'package:authentication_x/AuthController.dart';
import 'package:authentication_x/authentication_x.dart';
import 'package:authentication_x/validators/FormValidator.dart';
import 'package:cart/cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorites/controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shopify/datasources/database/CashDatabase.dart';
import 'package:shopify/datasources/database/FirebaseDataSource.dart';
import 'datasources/auth/FirebaseAuthDatasource.dart';

inject() {
  Get.put(FormValidator());
  Get.put<AuthDataSource>(FirebaseAuthDatasource());
  Get.put(AuthController(authDataSource: Get.find()));
  Get.put(FirebaseDataSource(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));
  Get.put(CashDatabase());

  Get.put(AllItemsController(
      networkDatasource: Get.find<FirebaseDataSource>(),
      cashDatasource: Get.find<CashDatabase>()));

  Get.put(AppBarController(datasource: Get.find<FirebaseDataSource>()));

  Get.put(CartController(dataSource: Get.find<FirebaseDataSource>()));

  Get.put(FavoritesController(dataSource: Get.find<FirebaseDataSource>()));
}

import 'package:all_items/all_items.dart';
import 'package:all_items/all_items_controller.dart';
import 'package:authentication_x/AuthController.dart';
import 'package:authentication_x/authentication_x.dart';
import 'package:authentication_x/validators/FormValidator.dart';
import 'package:cat_items/controller.dart';
import 'package:cat_items/datasource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:shopify/datasources/database/CashDatabase.dart';
import 'package:shopify/datasources/database/FirebaseDataSource.dart';
import 'datasources/auth/FirebaseAuthDatasource.dart';

inject() {
  Get.put(FormValidator());
  Get.put<AuthDataSource>(FirebaseAuthDatasource());
  Get.create<AuthController>(() => AuthController(authDataSource: Get.find()));
  Get.put(
      FirebaseDataSource(
          firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance),
      tag: "networkDatasource");
  Get.put(CashDatabase(), tag: "cashDatasource");

  Get.create<AllItemsController>(() => AllItemsController(
      networkDatasource:
          Get.find(tag: "networkDatasource") as AllItemsDataSource,
      cashDatasource: Get.find(tag: "cashDatasource") as AllItemsDataSource));

  Get.create<CatItemsController>(() => CatItemsController(
      cashDatasource: Get.find(tag: "cashDatasource") as CatItemsDatasource,
      networkDatasource:
          Get.find(tag: "networkDatasource") as CatItemsDatasource));
}

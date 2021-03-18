import 'package:all_items/all_items.dart';
import 'package:all_items/all_items_controller.dart';
import 'package:authentication_x/AuthController.dart';
import 'package:authentication_x/authentication_x.dart';
import 'package:authentication_x/validators/FormValidator.dart';
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
  Get.put(AuthController(authDataSource: Get.find()));
  Get.put<AllItemsDataSource>(
      FirebaseDataSource(
          firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance),
      tag: "networkDatasource");
  Get.put<AllItemsDataSource>(CashDatabase(), tag: "cashDatasource");
  Get.create(() => AllItemsController(
      networkDatasource: Get.find(tag: "networkDatasource"),
      cashDatasource: Get.find(tag: "cashDatasource")));
}

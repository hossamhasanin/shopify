import 'package:all_items/all_items.dart';
import 'package:authentication_x/authentication_x.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopify/constants.dart';
import 'package:shopify/dependencies.dart';
import 'package:shopify/theme.dart';
import 'package:shopify/widgets/all_items/AllItemsScreen.dart';
import 'package:shopify/widgets/auth/AuthUi.dart';
import 'package:shopify/widgets/cat_items/cat_items_screen.dart';
import 'package:shopify/widgets/utils/helpers.dart';

void main() {
  GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Shopify',
        getPages: [
          GetPage(name: AllItemsScreen.routeName, page: () => AllItemsScreen()),
          GetPage(name: CatItemsScreen.routeName, page: () => CatItemsScreen())
        ],
        theme: theme(),
        home: HomeWidget());
  }
}

class HomeWidget extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: error(),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          SizeConfig().init(context);

          inject();
          Get.find<AllItemsDataSource>(tag: "cashDatasource")
              .initCashDatabase();
          GetStorage box = GetStorage();

          if (Get.find<AuthController>().isLoggedIn()) {
            return AllItemsScreen();
          } else if (box.hasData(FIRST_TIME_OPEN) &&
              box.read(FIRST_TIME_OPEN)) {
            // go to on boarding screen
            return Container();
          }
          return AuthUi();
        }
        return Scaffold(body: loading());
      },
    );
  }

  Widget loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget error() {
    return Center(
      child: Text("Error with the app"),
    );
  }
}

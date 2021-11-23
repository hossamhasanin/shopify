import 'package:all_items/all_items.dart';
import 'package:authentication_x/authentication_x.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopify/constants.dart';
import 'package:shopify/datasources/database/CashDatabase.dart';
import 'package:shopify/dependencies.dart';
import 'package:shopify/theme.dart';
import 'package:shopify/widgets/all_items/AllItemsScreen.dart';
import 'package:shopify/widgets/auth/AuthUi.dart';
import 'package:shopify/widgets/cart/cart_screen.dart';
import 'package:shopify/widgets/cat_items/cat_items_screen.dart';
import 'package:shopify/widgets/favourites/favourites_screen.dart';
import 'package:shopify/widgets/home/home_screen.dart';
import 'package:shopify/widgets/notifications/notifications_screen.dart';
import 'package:shopify/widgets/orders/order_details_screen.dart';
import 'package:shopify/widgets/orders/orders_screen.dart';
import 'package:shopify/widgets/pay/components/put_address_screen.dart';
import 'package:shopify/widgets/pay/payment_screen.dart';
import 'package:shopify/widgets/product_details/details_screen.dart';
import 'package:shopify/widgets/utils/helpers.dart';
import 'package:models/notification.dart' as N;

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
          GetPage(name: HomeScreen.routeName, page: () => HomeScreen()),
          GetPage(name: CatItemsScreen.routeName, page: () => CatItemsScreen()),
          GetPage(name: CartScreen.routeName, page: () => CartScreen()),
          GetPage(name: DetailsScreen.routeName, page: () => DetailsScreen()),
          GetPage(
              name: NotificationsScreen.routeName,
              page: () => NotificationsScreen()),
          GetPage(name: PayMentScreen.routeName, page: () => PayMentScreen()),
          GetPage(
              name: PutAddressScreen.routeName, page: () => PutAddressScreen()),
          GetPage(
              name: OrderDetailsScreen.routeName,
              page: () => OrderDetailsScreen()),
          GetPage(
              name: FavouritesScreen.routeName, page: () => FavouritesScreen()),
        ],
        theme: theme(),
        home: HomeWidget());
  }
}

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

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
          Get.find<CashDatabase>().initCashDatabase();
          GetStorage box = GetStorage();

          if (Get.find<AuthController>().isLoggedIn()) {
            notificationListenInForground();

            return HomeScreen();
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print("Handling a background message: ${message.messageId}");

  N.Notification.notification.add(N.Notification(
      id: message.messageId!,
      title: message.notification!.title!,
      desc: message.notification!.body!));
}

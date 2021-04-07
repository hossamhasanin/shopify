import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:models/cart.dart';
import 'package:models/notification.dart' as N;

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}

hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

showCustomDialog(
    {required BuildContext context,
    required String title,
    required List<Widget> children,
    bool dissmissable = true}) {
  Dialog dialog = Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
              Text(
                title,
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.black),
              ),
              SizedBox(
                height: 20.0,
              ),
            ] +
            children,
      ),
    ),
  );
  showDialog(
      context: context,
      builder: (BuildContext context) => dialog,
      barrierDismissible: dissmissable);
}

notificationListenInForground() async {
  FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(alert: true, sound: true);
  FirebaseMessaging.instance.subscribeToTopic("all");

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print("notify");

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      N.Notification.notification.add(N.Notification(
          id: message.messageId!,
          title: notification.title!,
          desc: notification.body!));
      Get.snackbar(notification.title!, notification.body!);
    }
  });
}

int calcCartItems() {
  var items = 0;
  Cart.carts.forEach((element) {
    items += element.numOfItem;
  });
  return items;
}

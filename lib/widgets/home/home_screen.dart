import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopify/widgets/all_items/AllItemsScreen.dart';
import 'package:shopify/widgets/favourites/favourites_screen.dart';
import 'package:shopify/widgets/orders/orders_screen.dart';
import 'package:shopify/widgets/profile/profile_screen.dart';
import 'package:shopify/widgets/utils/components/coustom_bottom_nav_bar.dart';
import 'package:shopify/widgets/utils/components/enums.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    MenuStateHolder.stateHolder.stream.distinct().listen((page) {
      debugPrint("koko move to " + page.toString());
      _pageController.animateToPage(page!.index,
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          AllItemsScreen(),
          FavouritesScreen(),
          OrdersScreen(),
          ProfileScreen()
        ],
      ),
      bottomNavigationBar: Obx(() {
        return CustomBottomNavBar(
          selectedMenu: MenuStateHolder.stateHolder.value!,
        );
      }),
    );
  }
}

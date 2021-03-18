import 'package:flutter/material.dart';
import 'package:shopify/widgets/utils/components/coustom_bottom_nav_bar.dart';
import 'package:shopify/widgets/utils/components/enums.dart';

import 'components/body.dart';

class AllItemsScreen extends StatelessWidget {
  static String routeName = "/all_items";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}

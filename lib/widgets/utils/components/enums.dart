import 'package:get/get_rx/src/rx_types/rx_types.dart';

enum MenuState { home, favourite, orders, profile }

class MenuStateHolder {
  static Rx<MenuState> stateHolder = MenuState.home.obs;
}

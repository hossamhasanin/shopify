import 'dart:async';

import 'package:get/get.dart';
import 'package:models/models.dart';
import 'package:product_details/events/remove_from_cart.dart';
import 'package:product_details/events/select_color.dart';
import 'events/change_num_of_item.dart';
import 'usecase.dart';
import 'events/product_detail_event.dart';
import './datasource.dart';
import './usecase.dart';
import './repository_impl.dart';
import 'events/add_to_cart.dart';
import './viewstate.dart';

class ProductDetailsController extends GetxController {
  late Rx<ProductDetailsViewState> viewState;

  late ProductDetailsUseCase _useCase;
  StreamController<ProductDetailsEvent> _eventHandler = StreamController();

  ProductDetailsController(
      {required ProductDetailsDataSource networkDataSource,
      required Product product,
      int numOfItem = 1,
      int selectedColor = 0,
      bool isNew = true}) {
    viewState = ProductDetailsViewState(
            product: product,
            addToCartDone: false,
            addingToCart: false,
            errorInCart: "",
            numOfItem: numOfItem,
            removeFromCartDone: false,
            removingFromCart: false,
            editCartDone: false,
            selectedColor: selectedColor,
            isNew: isNew)
        .obs;

    _useCase = ProductDetailsUseCase(
        repo: ProductDetailsRepoImpl(networkDataSource: networkDataSource));

    _eventHandler.stream.listen((event) {
      if (event is AddToCart) {
        _addToCart(event);
      } else if (event is AddItem) {
        _addItem();
      } else if (event is RemoveItem) {
        _removeItem();
      } else if (event is RemoveFromCart) {
        _removeFromCart(event);
      } else if (event is SelectColor) {
        _selectColor(event);
      }
    });
  }

  addToCart() {
    _eventHandler.sink.add(AddToCart());
  }

  removeFromCart() {
    _eventHandler.sink.add(RemoveFromCart());
  }

  addItem() {
    _eventHandler.sink.add(AddItem());
  }

  removeItem() {
    _eventHandler.sink.add(RemoveItem());
  }

  selectColor(int color) {
    _eventHandler.sink.add(SelectColor(color: color));
  }

  _addItem() async {
    var count = viewState.value!.numOfItem;
    count += 1;
    viewState.value = viewState.value!.copy(
        numOfItem: count,
        removeFromCartDone: false,
        removingFromCart: false,
        addingToCart: false,
        addToCartDone: false,
        errorInCart: "",
        editCartDone: false);
    await _cartEdited();
  }

  _removeItem() async {
    var count = viewState.value!.numOfItem;
    if (count == 1) return;
    count -= 1;
    viewState.value = viewState.value!.copy(
        numOfItem: count,
        removeFromCartDone: false,
        removingFromCart: false,
        addingToCart: false,
        addToCartDone: false,
        errorInCart: "",
        editCartDone: false);
    await _cartEdited();
  }

  _selectColor(SelectColor event) async {
    viewState.value = viewState.value!.copy(selectedColor: event.color);
    await _cartEdited();
  }

  _addToCart(AddToCart event) async {
    viewState.value = await _useCase.addToCart(_getCart(), viewState.value!);
  }

  _removeFromCart(RemoveFromCart event) async {
    viewState.value =
        await _useCase.removeFromCart(_getCart(), viewState.value!);
  }

  _cartEdited() async {
    var cart = _getCart();
    if (Cart.carts.indexWhere(
            (cartL) => cartL.product.id == viewState.value!.product.id) ==
        -1) return;
    viewState.value = await _useCase.editProductCart(cart, viewState.value!);
  }

  Cart _getCart() {
    return Cart(
        product: viewState.value!.product,
        numOfItem: viewState.value!.numOfItem,
        selectedColor: viewState.value!.selectedColor);
  }

  @override
  void onClose() {
    _eventHandler.close();
    viewState.close();
    super.onClose();
  }
}

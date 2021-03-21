import 'dart:async';

import 'package:get/get.dart';
import 'package:models/models.dart';
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
      required Product product}) {
    viewState = ProductDetailsViewState(
            product: product,
            addToCartDone: false,
            addingToCart: false,
            errorInCart: "")
        .obs;

    _useCase = ProductDetailsUseCase(
        repo: ProductDetailsRepoImpl(networkDataSource: networkDataSource));

    _eventHandler.stream.listen((event) {
      if (event is AddToCart) {
        _addToCart(event);
      }
    });
  }

  addToCart() {
    _eventHandler.sink.add(AddToCart(product: viewState.value!.product));
  }

  _addToCart(AddToCart event) async {
    viewState.value = await _useCase.addToCart(event.product, viewState.value!);
  }

  @override
  void onClose() {
    _eventHandler.close();
    viewState.close();
    super.onClose();
  }
}

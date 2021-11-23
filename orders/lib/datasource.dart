import 'package:models/models.dart';

abstract class OrdersDatasource {
  Future<List<Order>> getOrders(String lastOrder);

  Future<List<Cart>> getOrderdItems(String orderId);

  Future cancelOrder(Order order);
}

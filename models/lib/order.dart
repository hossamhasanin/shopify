import 'package:equatable/equatable.dart';
import 'package:models/cart.dart';

class Order extends Equatable {
  List<Cart>? carts;
  final String officialName;
  final String address;
  final String phone;
  final String payMethod;
  final String orderNum;
  final double totalPrice;
  final int numAllItems;

  Order(
      {required this.officialName,
      required this.phone,
      required this.address,
      required this.orderNum,
      required this.payMethod,
      required this.totalPrice,
      required this.numAllItems,
      this.carts});

  @override
  List<Object?> get props => [
        carts,
        officialName,
        totalPrice,
        numAllItems,
        address,
        phone,
        payMethod,
        orderNum
      ];

  static Order fromDocument(Map<String, dynamic> map) {
    return Order(
        orderNum: map["orderNum"],
        address: map["address"],
        payMethod: map["payMethod"],
        phone: map["phone"],
        officialName: map["officialName"],
        totalPrice: map["totalPrice"],
        numAllItems: map["numAllItems"]);
  }

  Map<String, dynamic> tomap() {
    return {
      "orderNum": orderNum,
      "address": address,
      "payMethod": payMethod,
      "phone": phone,
      "officialName": officialName,
      "totalPrice": totalPrice,
      "numAllItems": numAllItems
    };
  }

  Order copy({
    String? officialName,
    String? address,
    String? phone,
    String? payMethod,
    String? orderNum,
    double? totalPrice,
    int? numAllItems,
  }) {
    return Order(
        address: address ?? this.address,
        phone: phone ?? this.phone,
        payMethod: payMethod ?? this.payMethod,
        orderNum: orderNum ?? this.orderNum,
        officialName: officialName ?? this.officialName,
        totalPrice: totalPrice ?? this.totalPrice,
        numAllItems: numAllItems ?? this.numAllItems);
  }
}

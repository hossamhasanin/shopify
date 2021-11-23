import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:models/cart.dart';

class Order extends Equatable {
  final List<Cart>? carts;
  final String officialName;
  final String address;
  final String phone;
  final String payMethod;
  final String orderNum;
  final double totalPrice;
  final int numAllItems;
  final int orderState;
  final DateTime? cancelledAt;

  Order(
      {required this.officialName,
      required this.phone,
      required this.address,
      required this.orderNum,
      required this.payMethod,
      required this.totalPrice,
      required this.numAllItems,
      this.carts,
      required this.orderState,
      this.cancelledAt});

  @override
  List<Object?> get props => [
        carts,
        officialName,
        totalPrice,
        numAllItems,
        address,
        phone,
        payMethod,
        orderNum,
        orderState,
        cancelledAt
      ];

  static Order fromDocument(Map<String, dynamic> map) {
    return Order(
        orderNum: map["orderNum"],
        address: map["address"],
        payMethod: map["payMethod"],
        phone: map["phone"],
        officialName: map["officialName"],
        totalPrice: map["totalPrice"],
        numAllItems: map["numAllItems"],
        orderState: map["orderState"],
        cancelledAt: map["cancelledAt"] == null
            ? null
            : (map["cancelledAt"] as Timestamp).toDate());
  }

  Map<String, dynamic> tomap() {
    return {
      "orderNum": orderNum,
      "address": address,
      "payMethod": payMethod,
      "phone": phone,
      "officialName": officialName,
      "totalPrice": totalPrice,
      "numAllItems": numAllItems,
      "orderState": orderState
    };
  }

  Order copy(
      {String? officialName,
      String? address,
      String? phone,
      String? payMethod,
      String? orderNum,
      double? totalPrice,
      int? numAllItems,
      int? orderState,
      DateTime? cancelledAt}) {
    return Order(
        address: address ?? this.address,
        phone: phone ?? this.phone,
        payMethod: payMethod ?? this.payMethod,
        orderNum: orderNum ?? this.orderNum,
        officialName: officialName ?? this.officialName,
        totalPrice: totalPrice ?? this.totalPrice,
        numAllItems: numAllItems ?? this.numAllItems,
        orderState: orderState ?? this.orderState,
        cancelledAt: cancelledAt ?? this.cancelledAt);
  }
}

enum OrderStates { Ordered, Shipping, Delevired, Cancelled }

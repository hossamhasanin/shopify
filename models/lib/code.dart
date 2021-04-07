import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Code extends Equatable {
  final String id;
  final String code;
  final String title;
  final String desc;
  final List<String> products;
  final List<String> cats;
  final double discountPercent;
  final double discountAmount;
  DateTime? startsIn;
  DateTime? endsIn;

  Code(
      {required this.id,
      required this.code,
      required this.title,
      required this.desc,
      required this.products,
      required this.cats,
      required this.discountPercent,
      required this.discountAmount,
      this.startsIn,
      this.endsIn});

  @override
  List<Object?> get props => [
        id,
        title,
        code,
        desc,
        products,
        cats,
        discountAmount,
        discountPercent,
        startsIn,
        endsIn
      ];

  static Code fromDocument(Map<String, dynamic> map) {
    return Code(
        id: map["id"],
        title: map["title"],
        code: map["code"],
        desc: map["desc"],
        products: List<String>.from(map["products"]),
        cats: List<String>.from(map["cats"]),
        discountAmount: double.parse(map["discountAmount"].toString()),
        discountPercent: map["discountPercent"],
        startsIn: (map["startsIn"] as Timestamp).toDate(),
        endsIn: (map["endsIn"] as Timestamp).toDate());
  }

  Map<String, dynamic> tomap() {
    return {
      "id": id,
      "title": title,
      "code": code,
      "desc": desc,
      "products": products,
      "cats": cats,
      "discountAmount": discountAmount,
      "discountPercent": discountPercent,
      "startsIn": startsIn,
      "endsIn": endsIn
    };
  }

  Code copy(
      {String? id,
      String? code,
      String? title,
      String? desc,
      List<String>? products,
      List<String>? cats,
      double? discountPercent,
      double? discountAmount,
      DateTime? startsIn,
      DateTime? endsIn}) {
    return Code(
        id: id ?? this.id,
        code: code ?? this.code,
        title: title ?? this.title,
        desc: desc ?? this.desc,
        products: products ?? this.products,
        cats: cats ?? this.cats,
        discountPercent: discountPercent ?? this.discountPercent,
        discountAmount: discountAmount ?? this.discountAmount,
        startsIn: startsIn ?? this.startsIn,
        endsIn: endsIn ?? this.endsIn);
  }
}

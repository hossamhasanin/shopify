import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:models/models.dart';
part 'product.g.dart';

@HiveType(typeId: 1)
class Product extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final List images;
  @HiveField(4)
  final List<int> colors;
  @HiveField(5)
  final double rating;
  @HiveField(6)
  final double price;
  @HiveField(7)
  final bool isFavourite;
  @HiveField(8)
  final bool isPopular;
  @HiveField(9)
  final String catId;

  Product(
      {required this.id,
      required this.images,
      required this.colors,
      this.rating = 0.0,
      this.isFavourite = false,
      this.isPopular = false,
      required this.title,
      required this.price,
      required this.description,
      required this.catId});

  @override
  List<Object> get props => [
        id,
        title,
        description,
        images,
        colors,
        rating,
        price,
        isFavourite,
        isPopular,
        catId
      ];

  static Product fromDocument(Map<String, dynamic> map) {
    return Product(
        id: map["id"],
        title: map["title"],
        images: map["images"],
        colors: List<int>.from(map["colors"]),
        rating: double.parse(map["rating"].toString()),
        isFavourite: map["isFavourite"],
        isPopular: map["isPopular"],
        price: double.parse(map["price"].toString()),
        description: map["description"],
        catId: map["catId"]);
  }

  Map<String, dynamic> tomap() {
    return {
      "id": id,
      "title": title,
      "images": images,
      "colors": colors,
      "rating": rating,
      "isFavourite": isFavourite,
      "isPopular": isPopular,
      "price": price,
      "description": description,
      "catId": catId
    };
  }

  Product copy({
    String? id,
    String? title,
    String? description,
    List? images,
    List<int>? colors,
    double? rating,
    double? price,
    bool? isFavourite,
    bool? isPopular,
    String? catId,
  }) {
    return Product(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        images: images ?? this.images,
        colors: colors ?? this.colors,
        rating: rating ?? this.rating,
        price: price ?? this.price,
        isFavourite: isFavourite ?? this.isFavourite,
        isPopular: isPopular ?? this.isPopular,
        catId: catId ?? this.catId);
  }
}

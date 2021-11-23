import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'cat.g.dart';

@HiveType(typeId: 0)
class Category extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String icon;
  Category({required this.id, required this.name, required this.icon});
  @override
  List<Object> get props => [id, name, icon];

  static Category fromDocument(Map<String, dynamic> map) {
    return Category(id: map["id"], name: map["name"], icon: map["icon"]);
  }
}

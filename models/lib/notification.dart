import 'package:equatable/equatable.dart';

class Notification extends Equatable {
  final String id;
  final String title;
  final String desc;

  const Notification(
      {required this.id, required this.title, required this.desc});

  @override
  List<Object?> get props => [id, title, desc];
  static Notification fromDocument(Map<String, dynamic> map) {
    return Notification(id: map["id"], title: map["title"], desc: map["desc"]);
  }
}

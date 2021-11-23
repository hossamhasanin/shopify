import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final String? image;
  final int? gender;
  User(
      {required this.id,
      required this.username,
      required this.email,
      this.image,
      this.gender});

  set gender(int? gender) {
    this.gender = gender;
  }

  set username(String name) {
    this.username = name;
  }

  set email(String email) {
    this.email = email;
  }

  set image(String? image) {
    this.image = image;
  }

  Map<String, dynamic> toDocument() {
    return {
      "id": this.id,
      "name": this.username,
      "email": this.email,
      "image": this.image ?? "none",
      "gender": this.gender
    };
  }

  @override
  List<Object> get props => [username, id, email];
}

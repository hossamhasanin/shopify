import 'package:equatable/equatable.dart';

class User extends Equatable {
  String id;
  String username;
  String email;
  int? gender;
  User(
      {required this.id,
      required this.username,
      required this.email,
      this.gender});
  Map<String, dynamic> toDocument() {
    return {
      "id": this.id,
      "name": this.username,
      "email": this.email,
      "gender": this.gender
    };
  }

  @override
  // TODO: implement props
  List<Object> get props => [username, id, email, gender!];
}

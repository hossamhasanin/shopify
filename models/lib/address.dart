import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String id;
  final String street;
  final String governorate;
  final String city;
  final String optionalInfo;

  const Address(
      {required this.id,
      required this.street,
      required this.governorate,
      required this.city,
      this.optionalInfo = ""});

  @override
  List<Object?> get props => [id, street, governorate, city, optionalInfo];

  @override
  String toString() {
    return governorate +
        "," +
        city +
        "," +
        street +
        (optionalInfo.isNotEmpty ? "," + optionalInfo : "");
  }

  static Address fromString(String address) {
    var addressSplit = address.split(",");
    return Address(
        id: "",
        governorate: addressSplit[0],
        city: addressSplit[1],
        street: addressSplit[2],
        optionalInfo: addressSplit.length == 4 ? addressSplit[3] : "");
  }

  static Address fromDocument(Map<String, dynamic> map) {
    return Address(
        id: map["id"],
        street: map["street"],
        governorate: map["governorate"],
        city: map["city"],
        optionalInfo: map["optionalInfo"]);
  }

  Map<String, dynamic> tomap() {
    return {
      "id": id,
      "street": street,
      "governorate": governorate,
      "city": city,
      "optionalInfo": optionalInfo
    };
  }

  Address copy(
      {String? id,
      String? street,
      String? governorate,
      String? city,
      String? optionalInfo}) {
    return Address(
        id: id ?? this.id,
        street: street ?? this.street,
        governorate: governorate ?? this.governorate,
        city: city ?? this.city,
        optionalInfo: optionalInfo ?? this.optionalInfo);
  }
}

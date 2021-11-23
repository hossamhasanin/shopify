import 'package:models/models.dart';

import 'pay_event.dart';

class AddAddress extends PayEvent {
  final Address address;
  const AddAddress({required this.address});
}

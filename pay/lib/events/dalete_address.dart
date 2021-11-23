import 'package:models/models.dart';

import 'pay_event.dart';

class DeleteAddress extends PayEvent {
  final Address address;
  const DeleteAddress({required this.address});
}

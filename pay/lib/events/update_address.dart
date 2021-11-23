import 'package:models/models.dart';

import 'pay_event.dart';

class UpdateAddress extends PayEvent {
  final Address address;
  const UpdateAddress({required this.address});
}

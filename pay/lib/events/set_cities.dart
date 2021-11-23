import 'package:pay/events/pay_event.dart';

class SetCities extends PayEvent {
  final String gov;
  const SetCities({required this.gov});

  @override
  // TODO: implement props
  List<Object?> get props => [gov];
}

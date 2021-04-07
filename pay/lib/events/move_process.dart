import './pay_event.dart';

class MoveProcess extends PayEvent {
  final int processIndex;
  const MoveProcess({required this.processIndex});

  @override
  List<Object?> get props => [processIndex];
}

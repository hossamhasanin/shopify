import 'package:equatable/equatable.dart';

class EventState extends Equatable {
  final bool removeDone;
  final String removeError;

  const EventState({required this.removeDone, required this.removeError});

  @override
  List<Object?> get props => [removeDone, removeError];

  EventState copy({bool? removeDone, String? removeError}) {
    return EventState(
        removeDone: removeDone ?? this.removeDone,
        removeError: removeError ?? this.removeError);
  }
}

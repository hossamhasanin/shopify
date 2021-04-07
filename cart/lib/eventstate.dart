import 'package:equatable/equatable.dart';

class EventState extends Equatable {
  final bool done;
  final String error;

  const EventState({required this.done, required this.error});

  @override
  List<Object?> get props => [done, error];

  EventState copy({bool? done, String? error}) {
    return EventState(done: done ?? this.done, error: error ?? this.error);
  }
}

import 'package:equatable/equatable.dart';

class EventState extends Equatable {
  final bool loading;
  final String error;
  final bool sucessed;

  const EventState(
      {required this.loading, required this.error, required this.sucessed});

  @override
  List<Object?> get props => [loading, error, sucessed];

  EventState copy({bool? loading, String? error, bool? sucessed}) {
    return EventState(
        loading: loading ?? this.loading,
        sucessed: sucessed ?? this.sucessed,
        error: error ?? this.error);
  }
}

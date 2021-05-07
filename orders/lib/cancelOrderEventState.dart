import 'package:equatable/equatable.dart';

class CancelOrderEventState extends Equatable {
  final bool loading;
  final String error;
  final bool done;

  CancelOrderEventState(
      {required this.loading, required this.error, required this.done});

  @override
  List<Object?> get props => [loading, error, done];

  CancelOrderEventState copy({bool? loading, String? error, bool? done}) {
    return CancelOrderEventState(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        done: done ?? this.done);
  }
}

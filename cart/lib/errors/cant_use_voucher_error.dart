class CantUseVoucherCodeException implements Exception {
  final String _message;

  CantUseVoucherCodeException({required String message})
      : this._message = message;
  @override
  String toString() {
    return _message;
  }
}

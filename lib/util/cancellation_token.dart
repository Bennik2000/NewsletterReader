class CancellationToken {
  bool _isCancelled;
  bool get isCancelled => _isCancelled;

  void setCancelled() {
    _isCancelled = true;
  }
}

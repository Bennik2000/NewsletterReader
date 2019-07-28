class CancellationToken {
  bool get isCancelled => DateTime.now().isAfter(cancellationTime);
  final DateTime cancellationTime;

  CancellationToken(this.cancellationTime);
}

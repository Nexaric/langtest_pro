import 'dart:async';

class OfferTimerManager {
  static final OfferTimerManager _instance = OfferTimerManager._internal();
  factory OfferTimerManager() => _instance;
  OfferTimerManager._internal();

  int _remainingSeconds = 30 * 60; // 30 minutes default
  bool _isOfferExpired = false;
  Timer? _countdownTimer;
  Function? _onUpdate; // Callback to notify listeners (e.g., setState)

  int get remainingSeconds => _remainingSeconds;
  bool get isOfferExpired => _isOfferExpired;

  void startCountdown({required Function onUpdate}) {
    if (_isOfferExpired) return;
    _onUpdate = onUpdate;
    _countdownTimer?.cancel(); // Cancel any existing timer
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        _onUpdate?.call();
      } else {
        _countdownTimer?.cancel();
        _isOfferExpired = true;
        _onUpdate?.call();
      }
    });
  }

  void stopCountdown() {
    _countdownTimer?.cancel();
    _isOfferExpired = true;
    _onUpdate?.call();
  }

  void reset() {
    _countdownTimer?.cancel();
    _remainingSeconds = 30 * 60;
    _isOfferExpired = false;
    _onUpdate?.call();
  }
}

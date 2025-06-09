import 'dart:async';
import 'package:flutter/material.dart';

class PracticeTestTimer {
  final Duration initialDuration;
  final VoidCallback onTimeExpired;
  final ValueChanged<Duration>? onTick;

  Timer? _timer;
  Duration _remainingTime;
  bool _isRunning = false;

  PracticeTestTimer({
    required this.initialDuration,
    required this.onTimeExpired,
    this.onTick,
  }) : _remainingTime = initialDuration;

  Duration get remainingTime => _remainingTime;
  bool get isRunning => _isRunning;

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void pause() {
    _isRunning = false;
    _timer?.cancel();
  }

  void reset() {
    _isRunning = false;
    _timer?.cancel();
    _remainingTime = initialDuration;
    onTick?.call(_remainingTime);
  }

  void _tick(Timer timer) {
    if (_remainingTime.inSeconds <= 0) {
      timer.cancel();
      _isRunning = false;
      onTimeExpired();
      return;
    }

    _remainingTime -= const Duration(seconds: 1);
    onTick?.call(_remainingTime);
  }

  void dispose() {
    _timer?.cancel();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes.remainder(60))}:"
        "${twoDigits(duration.inSeconds.remainder(60))}";
  }
}

class TimerDisplay extends StatelessWidget {
  final Duration duration;
  final bool isWarning;

  const TimerDisplay({
    super.key,
    required this.duration,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(duration),
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isWarning ? Colors.red[300] : Colors.white,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes.remainder(60))}:"
        "${twoDigits(duration.inSeconds.remainder(60))}";
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

class TimerNotifier with ChangeNotifier {
  Timer? _timer;

  int _seconds = 0;
  int get seconds => _seconds;

  void startIfInactive() {
    final timer = _timer;
    if (timer == null || !timer.isActive) {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), _handleTick);
      reset();
    }
  }

  void reset() {
    _seconds = 0;
    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  void _handleTick(Timer timer) {
    _seconds++;
    notifyListeners();
  }
}

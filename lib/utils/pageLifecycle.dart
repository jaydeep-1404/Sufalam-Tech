import 'dart:async';
import 'package:flutter/material.dart';

class AppLifecycleHandler with WidgetsBindingObserver {
  final VoidCallback? onPaused, onResumed, onInactive, onDetached, onInactiveForMinute;

  Timer? _inactiveTimer;
  static const Duration inactiveDuration = Duration(seconds: 5);

  AppLifecycleHandler({this.onPaused, this.onResumed, this.onInactive, this.onDetached, this.onInactiveForMinute,}) {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactiveTimer?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        if (onPaused != null) onPaused!();
        break;
      case AppLifecycleState.resumed:
        if (onResumed != null) onResumed!();
        _stopInactiveTimer();
        break;
      case AppLifecycleState.inactive:
        if (onInactive != null) onInactive!();
        _startInactiveTimer();
        break;
      case AppLifecycleState.detached:
        if (onDetached != null) onDetached!();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _startInactiveTimer() {
    _stopInactiveTimer();
    _inactiveTimer = Timer(inactiveDuration, () {
      if (onInactiveForMinute != null) {
        onInactiveForMinute!();
      }
    });
  }

  void _stopInactiveTimer() {
    _inactiveTimer?.cancel();
    _inactiveTimer = null;
  }
}


class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
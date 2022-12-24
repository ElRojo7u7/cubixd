import 'dart:async' show Timer;

import 'package:flutter/material.dart' show VoidCallback;

class CubixdDebouncer {
  final Duration debounceTime;
  Timer? _timer;

  CubixdDebouncer({required this.debounceTime});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(debounceTime, action);
  }
}

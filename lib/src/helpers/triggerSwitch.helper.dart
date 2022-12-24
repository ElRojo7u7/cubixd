import 'package:flutter/material.dart' show VoidCallback;

class CubixdTriggerSwitch {
  bool _opt;
  CubixdTriggerSwitch(this._opt);

  void run(VoidCallback call, bool opt) {
    if (_opt != opt) {
      call();
      _opt = !_opt;
    }
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart' show Widget, AnimationController;
import 'package:vector_math/vector_math_64.dart' show Vector2;

import '../enums/index.dart' show SelectedSide;

typedef OnSelectedC = void Function(SelectedSide opt, Vector2 delta);
typedef OnSelectedA = bool Function(SelectedSide opt);
typedef BuildOnSelect = Widget Function(
    double size, AnimationController selecCtrl);

abstract class CubixdUtils {
  // The margin factor to consider the selection (iSel * fiveDeg)
  static const int iSel = 4;
  static const double fiveDeg = math.pi / 36;

  static double getIvalue(double val) {
    final resP = val.abs() % (math.pi / 2);
    final resN = -val.abs() % (math.pi / 2);
    if (resP < CubixdUtils.iSel * CubixdUtils.fiveDeg) {
      return val < 0 ? val + resP : val - resP;
    }
    return val < 0 ? val - resN : val + resN;
  }
}

import 'package:flutter/animation.dart' show Curve, Curves;

class SimpleAnimRequirements {
  /// The angle in radians that whould be set when the animation starts
  final double xBegin;

  /// The angle in radians that should be set when the animation ends
  final double xEnd;

  /// The angle in radians that whould be set when the animation starts
  final double yBegin;

  /// The angle in radians that should be set when the animation ends
  final double yEnd;

  /// If the animation repeats infinitely
  ///
  /// By default: `infinite: true`
  final bool infinite;

  /// If the animation shoud play backwards when it finishes
  ///
  /// By default: `reverseWhenDone: false`
  final bool reverseWhenDone;

  /// Duration of the cubixd rotation
  final Duration duration;

  /// Curve that should be excecuted by playing the animation
  /// on the x angle (horizontal)
  ///
  /// By default: `xCurve = Curves.liner`
  final Curve xCurve;

  /// Curve that should be excecuted by playing the animation
  /// on the y angle (vertical)
  ///
  /// By default: `yCurve = Curves.liner`
  final Curve yCurve;

  SimpleAnimRequirements({
    required this.duration,
    required this.xBegin,
    required this.xEnd,
    required this.yBegin,
    required this.yEnd,
    this.infinite = true,
    this.reverseWhenDone = false,
    this.xCurve = Curves.linear,
    this.yCurve = Curves.linear,
  });
}

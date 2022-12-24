import 'package:flutter/animation.dart' show Animation, AnimationController;

class AnimRequirements {
  final AnimationController controller;
  final Animation<double> xAnimation;
  final Animation<double> yAnimation;

  AnimRequirements({
    required this.controller,
    required this.xAnimation,
    required this.yAnimation,
  });
}

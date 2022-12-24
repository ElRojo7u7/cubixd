import 'package:flutter/animation.dart' show Animation;

class StarsAnimations {
  final Animation<double> xAnim;
  final Animation<double> yAnim;
  final double size;

  StarsAnimations(this.xAnim, this.yAnim, this.size);
}

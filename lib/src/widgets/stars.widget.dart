import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:cubixd/src/models/index.dart' show StarsAnimations;

class Stars extends StatelessWidget {
  final CurvedAnimation _curvedA;
  final double overflowQ = 0.5;
  final List<StarsAnimations> _starsA = [];
  final List<int> _minMax = [20, 35];

  Stars({
    Key? key,
    required AnimationController ctrl,
    required double size,
  })  : _curvedA = CurvedAnimation(parent: ctrl, curve: Curves.easeOutQuint),
        super(key: key) {
    _initParams(size);
    ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _initParams(size);
      }
    });
  }

  void _initParams(double size) {
    _starsA.clear();
    final int length =
        math.Random().nextInt(_minMax[1] - _minMax[0]) + _minMax[0];
    final double overflow = overflowQ * size;
    for (int i = 0; i < length; i++) {
      final double shapeSize = math.Random().nextDouble() * size * 0.8;

      final double lPos = math.Random().nextDouble() * size;
      final double tPos = math.Random().nextDouble() * size;

      final double xEnd;
      final double yEnd;

      if (-lPos.abs() % size < -tPos.abs() % size) {
        xEnd = lPos > size / 2 ? size + overflow : -overflow;
        yEnd = xEnd * (tPos / xEnd);
      } else {
        yEnd = tPos > size / 2 ? size + overflow : -overflow;
        xEnd = yEnd / (tPos / lPos);
      }
      _starsA.add(StarsAnimations(
        Tween<double>(begin: lPos, end: xEnd).animate(_curvedA),
        Tween<double>(begin: tPos, end: yEnd).animate(_curvedA),
        shapeSize,
      ));
    }
  }

  List<Widget> get _buildList {
    final List<Widget> list = [];
    final Color color = Color((math.Random().nextDouble() * 0xFFFFFF).toInt());
    for (int i = 0; i < _starsA.length; i++) {
      list.add(Transform.translate(
        offset: Offset(_starsA[i].xAnim.value, _starsA[i].yAnim.value),
        child: ClipPath(
          clipper: _ClipperStar(),
          child: Container(
            color: color.withOpacity(1 - _curvedA.value),
            height: _starsA[i].size,
            width: _starsA[i].size,
          ),
        ),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curvedA,
      builder: (_, __) {
        return Stack(children: _buildList);
      },
    );
  }
}

class _ClipperStar extends CustomClipper<Path> {
  static const _starShrink = 2;
  static const _starSides = 5;
  static const _deg90 = math.pi / 2;
  @override
  Path getClip(Size size) {
    final double bigRad = math.min(size.width, size.height) / 2;
    final double smallRad = bigRad / _starShrink;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    const double sides = 2 * math.pi / _starSides;
    const double semiSide = sides / 2;

    final Path path = Path()..moveTo(size.width / 2, 0);
    for (int i = 0; i < _starSides; i++) {
      path.lineTo(math.cos(sides * i + _deg90) * bigRad + centerX,
          centerY - math.sin(sides * i + _deg90) * bigRad);

      path.lineTo(math.cos(semiSide + sides * i + _deg90) * smallRad + centerX,
          centerY - math.sin(semiSide + sides * i + _deg90) * smallRad);
    }
    return path..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

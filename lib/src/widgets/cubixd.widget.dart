import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector2, Vector3;

import '../enums/index.dart' show SelectedSide;
import '../helpers/index.dart' show CubixdTriggerSwitch, CubixdDebouncer;

import '../types/cubixdTypes.type.dart';

class CubixD extends StatefulWidget {
  /// The x (horizontal) and y (vertical) angle (in radians)
  ///
  /// Unlike [AnimatedCubixD] the x and y angle are inverted
  ///  `delta: Vector2(dy,dx)`
  final Vector2 delta;

  /// The width and height of every side of the cubixd
  final double size;

  /// The callback triggered when a side has been selected
  ///
  /// User wont be able to move the cubix if this parameter isn't set (null)
  final OnSelectedC? onSelected;

  /// The callback that triggers when the cubix is moving
  final VoidCallback? onPanUpdate;

  /// A number > 0 and near 1 to dial selection motion sensivility.
  ///
  /// By default: `sensitivityFac: 1`
  final double sensitivityFac;

  /// The debouncer duration that triggers to handle a side selection
  final Duration debounceTime;

  /// Widget for each side
  /// ```dart
  /// top: Container(
  ///   color: Colors.red,
  /// ),
  /// ```
  final Widget top;

  /// Widget for each side
  /// ```dart
  /// bottom: Container(
  ///   color: Colors.pink,
  /// ),
  /// ```
  final Widget bottom;

  /// Widget for each side
  /// ```dart
  /// left: Container(
  ///   color: Colors.blue,
  /// ),
  /// ```
  final Widget left;

  /// Widget for each side
  /// ```dart
  /// right: Container(
  ///   color: Colors.yellow,
  /// ),
  /// ```
  final Widget right;

  /// Widget for each side
  /// ```dart
  /// front: Container(
  ///   color: Colors.amber,
  /// ),
  /// ```
  final Widget front;

  /// Widget for each side
  /// ```dart
  /// front: Container(
  ///   color: Colors.greenAccent,
  /// ),
  /// ```
  final Widget back;

  const CubixD({
    Key? key,
    required this.delta,
    required this.size,
    required this.top,
    required this.bottom,
    required this.front,
    required this.back,
    required this.right,
    required this.left,
    this.onSelected,
    this.onPanUpdate,
    this.sensitivityFac = 1.0,
    this.debounceTime = const Duration(milliseconds: 500),
  })  : assert(sensitivityFac > 0),
        super(key: key);

  @override
  State<CubixD> createState() => _CubixDState();
}

class _CubixDState extends State<CubixD> with SingleTickerProviderStateMixin {
  static const int _iSel = CubixdUtils.iSel; // margin factor of selection
  static const double _fiveDeg = CubixdUtils.fiveDeg;
  late final double _transitionMargin;
  late final double _height;
  late final double _width;
  late final double _sensibility;
  static const double _barrier = math.pi * 2;
  List<Widget> faces = [];
  late Widget top;
  late Widget rgt;
  late Widget bottom;
  late Widget lft;
  late Widget front;
  late Widget back;
  late final CubixdDebouncer _debouncer;
  final CubixdTriggerSwitch _switch = CubixdTriggerSwitch(false);

  @override
  void initState() {
    _width = widget.size;
    _height = widget.size;
    _debouncer = CubixdDebouncer(debounceTime: widget.debounceTime);
    _sensibility = widget.sensitivityFac * 1 / (0.005 * (_height + _width) / 2);
    _transitionMargin = _fiveDeg * 0.005 * (_height + _width) / 2;
    top = _buildFace(side: 0, rotate: false, child: widget.top);
    bottom = _buildFace(side: 2, rotate: false, child: widget.bottom);
    _buildFaces(false);
    super.initState();
  }

  void _buildFaces(bool rotate) {
    rgt = _buildFace(side: 1, rotate: rotate, child: widget.right);
    lft = _buildFace(side: 3, rotate: rotate, child: widget.left);
    front = Transform(
      transform: Matrix4.identity()
        ..translate(Vector3(0, 0, -_width / 2))
        ..rotateZ(rotate ? math.pi : 0),
      child: widget.front,
      alignment: Alignment.center, // Enfrente
    );
    back = Transform(
      transform: Matrix4.identity()
        ..translate(Vector3(0, 0, _height / 2))
        ..rotateZ(rotate ? math.pi : 0)
        ..rotateY(math.pi),
      child: widget.back,
      alignment: Alignment.center, // Atrás
    );
  }

  @override
  Widget build(BuildContext context) {
    final opt = (widget.delta.x > math.pi / 2 &&
            widget.delta.x < 3 * math.pi / 2) ||
        (widget.delta.x < -math.pi / 2 && widget.delta.x > -3 * math.pi / 2);
    _cubeEngine(widget.delta.y > 0);
    _switch.run(() => _buildFaces(opt), opt);
    return SizedBox(
      height: _height * 1.2,
      width: _width * 1.2,
      child: Stack(
        children: [
          SizedBox(
            height: _height,
            width: _width,
            child: Transform(
              transform: Matrix4.identity()
                ..translate(_width * 0.09, _height * 0.09, 0)
                ..setEntry(3, 2, 0.001)
                ..rotateX(widget.delta.x)
                ..rotateY(widget.delta.y),
              alignment: FractionalOffset.center,
              child: Stack(children: faces),
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onPanUpdate: widget.onSelected != null ? _onDraging : null,
              child: Container(
                color: Colors.transparent,
                height: _height * 1.2,
                width: _width * 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFace({
    required int side,
    required bool rotate,
    required Widget child,
  }) {
    final double translate;
    if (side > 3 || side < 0) throw Exception('Non side "$side" was found');
    final topOrBottom = side == 0 || side == 2;
    final Matrix4 transform;

    if (topOrBottom) {
      translate = side == 0 ? -_height / 2 : _height / 2;
      transform = Matrix4.identity()
        ..translate(0.0, translate, 0.0)
        ..rotateX(math.pi / 2)
        ..rotateX(side == 2 ? 0 : math.pi);
    } else {
      translate = side == 3 ? _width / -2 : _width / 2;
      transform = Matrix4.identity()
        ..translate(translate, 0.0, 0.0)
        ..rotateY(math.pi / 2)
        ..rotateY(side == 3 ? 0 : math.pi);
    }

    return Positioned.fill(
      child: Transform(
        transform: transform..rotateZ(rotate && !topOrBottom ? math.pi : 0),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  void _cubeEngine(bool opt) {
    if (widget.delta.x < -3 * math.pi / 2) {
      // -270 deg
      opt ? positiveYAux(true) : negativeYAux(true);
    } else if (widget.delta.x < -math.pi / 2) {
      // -90 deg
      opt ? positiveYAux(false) : negativeYAux(false);
    } else if (widget.delta.x < math.pi / 2) {
      // 90 deg
      opt ? positiveYAux(true) : negativeYAux(true);
    } else if (widget.delta.x < 3 * math.pi / 2) {
      // 270 deg
      opt ? positiveYAux(false) : negativeYAux(false);
    } else {
      // 360 deg
      opt ? positiveYAux(true) : negativeYAux(true);
    }
    universal();
  }

  void universal() {
    if (widget.delta.x < -2 * math.pi + 0.95 * _transitionMargin) {
      faces.insert(0, top);
    } else if (widget.delta.x < -math.pi - 1.35 * _transitionMargin) {
      faces.add(top);
    } else if (widget.delta.x < -math.pi + 0.95 * _transitionMargin) {
      faces.insert(0, top);
    } else if (widget.delta.x < -1.35 * _transitionMargin) {
      faces.add(bottom);
    } else if (widget.delta.x < 0.95 * _transitionMargin) {
      faces.insert(0, top);
    } else if (widget.delta.x < math.pi - 1.35 * _transitionMargin) {
      faces.add(top);
    } else if (widget.delta.x < math.pi + 0.95 * _transitionMargin) {
      faces.insert(0, bottom);
    } else if (widget.delta.x < 2 * math.pi - 1.35 * _transitionMargin) {
      faces.add(bottom);
    } else {
      faces.insert(0, bottom);
    }
  }

  void negativeYAux(bool opt) {
    if (opt) {
      if (widget.delta.y < -(3 * math.pi / 2 + _transitionMargin)) {
        // -275 deg
        faces = widget.delta.y < -_fiveDeg * 63 ? [rgt, front] : [front, rgt];
      } else if (widget.delta.y < -(math.pi + _transitionMargin)) {
        // -185 deg
        faces = widget.delta.y < -_fiveDeg * 45 ? [back, rgt] : [rgt, back];
      } else if (widget.delta.y < -(math.pi / 2 + _transitionMargin)) {
        // -95 deg
        faces = widget.delta.y < -_fiveDeg * 27 ? [lft, back] : [back, lft];
      } else {
        // -5 deg
        faces = widget.delta.y < -_fiveDeg * 9 ? [front, lft] : [lft, front];
      }
    } else {
      if (widget.delta.y < -(3 * math.pi / 2 + _transitionMargin)) {
        // -275 deg
        faces = widget.delta.y < -_fiveDeg * 63 ? [lft, back] : [back, lft];
      } else if (widget.delta.y < -(math.pi + _transitionMargin)) {
        // -185 deg
        faces = widget.delta.y < -_fiveDeg * 45 ? [front, lft] : [lft, front];
      } else if (widget.delta.y < -(math.pi / 2 + _transitionMargin)) {
        // -95 deg
        faces = widget.delta.y < -_fiveDeg * 27 ? [rgt, front] : [front, rgt];
      } else {
        // -5 deg
        faces = widget.delta.y < -_fiveDeg * 9 ? [back, rgt] : [rgt, back];
      }
    }
  }

  void positiveYAux(bool opt) {
    if (opt) {
      if (widget.delta.y < (math.pi / 2) - _transitionMargin) {
        // 85 deg
        faces = widget.delta.y > _fiveDeg * 9 ? [front, rgt] : [rgt, front];
      } else if (widget.delta.y < math.pi + _transitionMargin) {
        // 185 deg
        faces = widget.delta.y > _fiveDeg * 27 ? [rgt, back] : [back, rgt];
      } else if (widget.delta.y < 3 * math.pi / 2 + _transitionMargin) {
        // 275 deg
        faces = widget.delta.y > _fiveDeg * 45 ? [back, lft] : [lft, back];
      } else {
        // 315 deg
        faces = widget.delta.y < _fiveDeg * 63 ? [front, lft] : [lft, front];
      }
    } else {
      if (widget.delta.y < (math.pi / 2) - _transitionMargin) {
        // 85 deg
        faces = widget.delta.y > _fiveDeg * 9 ? [back, lft] : [lft, back];
      } else if (widget.delta.y < math.pi + _transitionMargin) {
        // 185 deg
        faces = widget.delta.y > _fiveDeg * 27 ? [lft, front] : [front, lft];
      } else if (widget.delta.y < 3 * math.pi / 2 + _transitionMargin) {
        // 275 deg
        faces = widget.delta.y > 45 * _fiveDeg ? [front, rgt] : [rgt, front];
      } else {
        // 315 deg
        faces = widget.delta.y < _fiveDeg * 63 ? [back, rgt] : [rgt, back];
      }
    }
  }

  void _onDraging(DragUpdateDetails delta) {
    if (widget.onPanUpdate != null) widget.onPanUpdate!();
    if (widget.delta.x < -3 * math.pi / 2) {
      // -270 deg
      widget.delta.y -= _sensibility * delta.delta.dx * math.pi / 180 * 0.6;
    } else if (widget.delta.x < -math.pi / 2) {
      // -90 deg
      widget.delta.y += _sensibility * delta.delta.dx * math.pi / 180 * 0.6;
    } else if (widget.delta.x < math.pi / 2) {
      // 90 deg
      widget.delta.y -= _sensibility * delta.delta.dx * math.pi / 180 * 0.6;
    } else if (widget.delta.x < 3 * math.pi / 2) {
      // 270 deg
      widget.delta.y += _sensibility * delta.delta.dx * math.pi / 180 * 0.6;
    } else {
      // 360 deg
      widget.delta.y -= _sensibility * delta.delta.dx * math.pi / 180 * 0.6;
    }
    widget.delta.x += _sensibility * delta.delta.dy * math.pi / 180 * 0.6;

    if (widget.delta.x >= _barrier || widget.delta.x <= -_barrier)
      widget.delta.x = 0;
    if (widget.delta.y >= _barrier || widget.delta.y <= -_barrier)
      widget.delta.y = 0;
    setState(() {});
    _debouncer.run(() => widget.onSelected!(_debouceTrigger(), widget.delta));
  }

  SelectedSide _debouceTrigger() {
    if (widget.delta.x < 0) {
      if (widget.delta.x - _fiveDeg * _iSel < -3 * math.pi / 2 &&
          widget.delta.x + _fiveDeg * _iSel > -3 * math.pi / 2) {
        return SelectedSide.top;
      } else if (widget.delta.x - _fiveDeg * _iSel < -math.pi / 2 &&
          widget.delta.x + _fiveDeg * _iSel > -math.pi / 2) {
        return SelectedSide.bottom;
      }
    } else {
      if (widget.delta.x - _fiveDeg * _iSel < math.pi / 2 &&
          widget.delta.x + _fiveDeg * _iSel > math.pi / 2) {
        return SelectedSide.top;
      } else if (widget.delta.x - _fiveDeg * _iSel < 3 * math.pi / 2 &&
          widget.delta.x + _fiveDeg * _iSel > 3 * math.pi / 2) {
        return SelectedSide.bottom;
      }
    }
    final List<double> _values = [
      widget.delta.x.abs() % (math.pi / 2),
      widget.delta.y.abs() % (math.pi / 2)
    ];
    const barrier = _fiveDeg * _iSel;
    if ((_values[0] < barrier || _values[0] > math.pi / 2 - barrier) &&
        (_values[1] < barrier || _values[1] > math.pi / 2 - barrier)) {
      return _selectedHelper();
    }

    return SelectedSide.none;
  }

  SelectedSide _selectedHelper() {
    final int index = (faces.last == bottom || faces.last == top) ? 1 : 2;
    final Widget selected = faces[index];
    if (selected == front) {
      return SelectedSide.front;
    } else if (selected == back) {
      return SelectedSide.back;
    } else if (selected == rgt) {
      return SelectedSide.right;
    }
    return SelectedSide.left;
  }
}

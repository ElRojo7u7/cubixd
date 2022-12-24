import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector2;

import 'index.dart' show CubixD, Stars;
import '../models/index.dart' show SimpleAnimRequirements, AnimRequirements;

import '../enums/index.dart';
import '../types/index.dart';

class AnimatedCubixD extends StatefulWidget {
  /// The width and height of every side of the cubixd
  final double size;

  /// The curve that uses when user selects a side (when the debouncer
  /// is triggered).
  ///
  /// By default: `onSelecCurve: Curves.fastOutSlowIn`
  final Curve onSelecCurve;

  /// The curve that uses when the cubix is restores to its begin values.
  ///
  /// By default: `onRestCurve: Curves.fastOutSlowIn`
  final Curve onRestCurve;

  /// The callback that triggers when user selects a side, if this isn't
  /// set (null), cubix can't move to select. This callback gives the selected
  /// side and if it returns true the cubixd moves to that selected side
  /// otherwise if false the cubixd restores to its begin values (as if
  /// nothing was selected)
  ///
  /// ```dart
  /// onSelected: (SelectedSide opt) {
  ///   switch (opt) {
  ///     case SelectedSide.back:
  ///       return true;
  ///     case SelectedSide.top:
  ///       return true;
  ///     case SelectedSide.front:
  ///       return true;
  ///     case SelectedSide.bottom:
  ///       return false; // out of service
  ///     case SelectedSide.right:
  ///       return true;
  ///     case SelectedSide.left:
  ///       return true;
  ///     case SelectedSide.none:
  ///       return false;
  ///      default:
  ///       throw Exception("Unimplemented option");
  ///   }
  /// },
  /// ```
  final OnSelectedA? onSelected;

  /// The callback that triggers when the cubix is moving
  final VoidCallback? onPanUpdate;

  /// Advanced configurations for animation. You can set the x or y angle
  /// movment setting a [Animation] to each one, you will have to set a
  /// [AnimationController] for the controller too.
  ///
  /// This is only for the x and y angle movment; setting this configuration
  /// for the shadow, selection and restore is not supported and it sets
  /// automatically
  ///
  /// **By setting this option, forward and dispose methods aren't called
  /// automatically from the controller**
  ///
  /// ```dart
  /// advancedXYposAnim: AnimRequirements(
  ///   controller: _ctrl,
  ///   xAnimation: Tween<double>(begin: -pi / 4, end: pi * 2 - pi / 4)
  ///     .animate(_ctrl),
  ///   yAnimation: Tween<double>(begin: pi / 4, end: pi / 4)
  ///     .animate(_ctrl),
  /// ),
  /// ```
  final AnimRequirements? advancedXYposAnim;

  /// Simple configuration for animation. If you don't want to set the
  /// controller and the animations ([Animation]), you can simple give
  /// a few parameters to get the animation
  ///
  /// ```dart
  /// simplePosAnim: SimpleAnimRequirements(
  ///   duration: const Duration(seconds: 8),
  ///   xBegin: pi / 4,
  ///   xEnd: 2 * pi,
  ///   yBegin: -pi / 4,
  ///   yEnd: 4 * pi,
  ///   reverseWhenDone: true,
  /// ),
  /// ```
  final SimpleAnimRequirements? simplePosAnim;

  /// if true reduces the height and it not longer moves up an down.
  ///
  /// By default: `shadow: true`
  final bool shadow;

  /// A number > 0 and near 1 to dial selection motion sensivility.
  ///
  /// By default: `sensitivityFac: 1`
  final double sensitivityFac;

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

  /// The duration that takes to restore the cubixd to its begin values.
  ///
  /// By default: `restDuration: Duration(milliseconds: 800)`
  final Duration restDuration;

  /// The duration that takes to move to the selected side of the cubixd.
  ///
  /// By default: `selDuration: Duration(milliseconds: 400)`
  final Duration selDuration;

  /// The duration that takes after the cubixd moved to the selected side
  /// and before moving to the restore animation.
  ///
  /// By default: `afterSelDel: Duration(seconds: 4)`
  final Duration afterSelDel;

  /// The duration that takes after the cubixd was retore to its begin values
  /// and before moving to the main animation.
  ///
  /// By default: `afterRestDel: Duration(milliseconds: 50)`
  final Duration afterRestDel;

  /// Whether or not the stars animation triggers
  ///
  /// By default: `stars: true`
  final bool stars;

  /// The debouncer duration that triggers to handle a side selection
  ///
  /// By default: `debounceTime: const Duration(miliseconds: 500)`
  final Duration debounceTime;

  /// You have the freedom to animate another animation instead of the stars explosion
  ///
  /// This callback is executed once (in the initState) and it must return the widget with
  /// the animation that will display when user selects a side, preferly a widget with
  /// [AnimatedBuilder]
  ///
  /// The size parameter is the same size you specify in [AnimatedCubixD.size]
  ///
  /// The controller corresponds to a controller generated by [AnimatedCubixD] that handles
  /// the animation when user selects a side
  ///
  /// ```dart
  /// ...
  /// buildOnSelect: (double size, AnimationController ctrl) {
  ///   return CircleStar(ctrl: ctrl, size: size);
  /// },
  /// ...
  /// class _Animations {
  ///   final Animation<double> xAnim;
  ///   final Animation<double> yAnim;
  ///   final double size;
  ///
  ///   _Animations(this.xAnim, this.yAnim, this.size);
  /// }
  ///
  /// class CircleStar extends StatelessWidget {
  ///   final CurvedAnimation _curvedA;
  ///   final double overflowQ = 0.4;
  ///   final List<_Animations> _starsA = [];
  ///   final List<int> _minMax = [20, 35];
  ///
  ///   CircleStar({
  ///     Key? key,
  ///     required AnimationController ctrl,
  ///     required double size,
  ///   })  : _curvedA = CurvedAnimation(parent: ctrl, curve: Curves.easeOutCubic),
  ///         super(key: key) {
  ///     _initParams(size);
  ///     ctrl.addStatusListener((status) {
  ///       if (status == AnimationStatus.completed) {
  ///         _initParams(size);
  ///       }
  ///     });
  ///   }
  ///
  ///   void _initParams(double size) {
  ///     _starsA.clear();
  ///     final int length = Random().nextInt(_minMax[1] - _minMax[0]) + _minMax[0];
  ///     final double overflow = overflowQ * size;
  ///     for (int i = 0; i < length; i++) {
  ///       final double shapeSize = Random().nextDouble() * size * 0.8;
  ///
  ///       final double lPos = Random().nextDouble() * size;
  ///       final double tPos = Random().nextDouble() * size;
  ///
  ///       final double xEnd;
  ///       final double yEnd;
  ///
  ///       if (-lPos.abs() % size < -tPos.abs() % size) {
  ///         xEnd = lPos > size / 2 ? size + overflow : -overflow;
  ///         yEnd = xEnd * (tPos / xEnd);
  ///       } else {
  ///         yEnd = tPos > size / 2 ? size + overflow : -overflow;
  ///         xEnd = yEnd / (tPos / lPos);
  ///       }
  ///       _starsA.add(_Animations(
  ///         Tween<double>(begin: lPos, end: xEnd).animate(_curvedA),
  ///         Tween<double>(begin: tPos, end: yEnd).animate(_curvedA),
  ///         shapeSize,
  ///       ));
  ///     }
  ///   }
  ///
  ///   List<Widget> get _buildList {
  ///     final List<Widget> list = [];
  ///     final Color color = Color((Random().nextDouble() * 0xFFFFFF).toInt());
  ///     for (int i = 0; i < _starsA.length; i++) {
  ///       list.add(Positioned(
  ///         left: 0,
  ///         top: 0,
  ///         child: Transform.translate(
  ///           offset: Offset(_starsA[i].xAnim.value, _starsA[i].yAnim.value),
  ///           child: Transform.rotate(
  ///             angle: -4 * pi * _curvedA.value,
  ///             child: ClipPath(
  ///               clipper: _CircleStarClip(),
  ///               child: Container(
  ///                 color: color.withOpacity(1 - _curvedA.value),
  ///                 height: _starsA[i].size,
  ///                 width: _starsA[i].size,
  ///               ),
  ///             ),
  ///           ),
  ///         ),
  ///       ));
  ///     }
  ///     return list;
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return AnimatedBuilder(
  ///       animation: _curvedA,
  ///       builder: (_, __) {
  ///         return Stack(children: _buildList);
  ///       },
  ///     );
  ///   }
  /// }
  /// ```
  final BuildOnSelect? buildOnSelect;

  const AnimatedCubixD({
    Key? key,
    required this.size,
    required this.top,
    required this.bottom,
    required this.front,
    required this.back,
    required this.right,
    required this.left,
    this.advancedXYposAnim,
    this.simplePosAnim,
    this.onSelected,
    this.onPanUpdate,
    this.onSelecCurve = Curves.fastOutSlowIn,
    this.onRestCurve = Curves.fastOutSlowIn,
    this.shadow = true,
    this.sensitivityFac = 1,
    this.restDuration = const Duration(milliseconds: 800),
    this.selDuration = const Duration(milliseconds: 400),
    this.afterSelDel = const Duration(seconds: 4),
    this.afterRestDel = const Duration(milliseconds: 50),
    this.stars = true,
    this.debounceTime = const Duration(milliseconds: 500),
    this.buildOnSelect,
  })  : assert(sensitivityFac > 0),
        assert(!(advancedXYposAnim != null && simplePosAnim != null)),
        super(key: key);

  @override
  State<AnimatedCubixD> createState() => _AnimatedCubixDState();
}

class _AnimatedCubixDState extends State<AnimatedCubixD>
    with TickerProviderStateMixin {
  bool? _infinite;
  bool? _reverseWhenDone;
  late final double _xBeginVal;
  late final double _yBeginVal;
  late final bool _isAdvanced; // if advancedXYposAnim != null

  double _xAminVal = 0;
  double _yAminVal = 0;

  int _xQuotient = 0; // for handle grades grater than 2*pi
  int _yQuotient = 0; // for handle grades grater than 2*pi

  late final AnimRequirements _advancedXYposAnim;
  AnimationController? _selectedAnim; // for handle selection
  AnimationController? _restoreAnim; // for handle restore

  late Animation<double> _xVal;
  late Animation<double> _yVal;
  late Animation<double> _shadowRanim;

  // To know what state render (restore, moving, select)
  CurrentState _currentState = CurrentState.moving;

  late final CurvedAnimation _restoreCurve;
  late final CurvedAnimation _selectedCurve;

  Widget? _customStars;
  Widget? _starsWidget;

  void _selectionRelated() {
    _selectedAnim = AnimationController(
      vsync: this,
      duration: widget.selDuration,
    );
    _restoreAnim = AnimationController(
      vsync: this,
      duration: widget.restDuration,
    );
    _selectedCurve = CurvedAnimation(
      parent: _selectedAnim!,
      curve: Curves.fastOutSlowIn,
    );
    _restoreCurve = CurvedAnimation(
      parent: _restoreAnim!,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _buildControllers() {
    if (widget.onSelected != null) _selectionRelated();
    if (widget.simplePosAnim != null) {
      final AnimationController _ctrl = AnimationController(
          vsync: this, duration: widget.simplePosAnim!.duration);
      final CurvedAnimation _xCurved =
          CurvedAnimation(parent: _ctrl, curve: widget.simplePosAnim!.xCurve);
      final CurvedAnimation _yCurved =
          CurvedAnimation(parent: _ctrl, curve: widget.simplePosAnim!.yCurve);

      _advancedXYposAnim = AnimRequirements(
        controller: _ctrl,
        xAnimation: Tween<double>(
                begin: widget.simplePosAnim!.xBegin,
                end: widget.simplePosAnim!.xEnd)
            .animate(_xCurved),
        yAnimation: Tween<double>(
                begin: widget.simplePosAnim!.yBegin,
                end: widget.simplePosAnim!.yEnd)
            .animate(_yCurved),
      );
      _infinite = widget.simplePosAnim!.infinite;
      _reverseWhenDone = widget.simplePosAnim!.reverseWhenDone;
    } else if (widget.advancedXYposAnim != null) {
      _advancedXYposAnim = widget.advancedXYposAnim!;
    } else {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 10),
      );
      _advancedXYposAnim = AnimRequirements(
        controller: ctrl,
        xAnimation:
            Tween<double>(begin: -math.pi / 4, end: math.pi * 2 - math.pi / 4)
                .animate(ctrl),
        yAnimation:
            Tween<double>(begin: math.pi / 4, end: math.pi / 4).animate(ctrl),
      );
      _infinite = true;
      _reverseWhenDone = false;
    }
  }

  double get _shadowAnimVal =>
      3 +
      math.sin(
          _advancedXYposAnim.controller.value * math.pi * 12 + 3 * math.pi / 2);

  void _resetQuotients() {
    _xQuotient = 0;
    _yQuotient = 0;
  }

  void _setListeners() {
    if (!_isAdvanced) {
      if (_infinite == null || _reverseWhenDone == null) {
        throw Exception("_infinite or _reverseWhenDone are null");
      }
      if (_infinite! && _reverseWhenDone!) {
        _advancedXYposAnim.controller.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _advancedXYposAnim.controller.reverse();
            _resetQuotients();
          } else if (status == AnimationStatus.dismissed) {
            _advancedXYposAnim.controller.forward();
            _resetQuotients();
          }
        });
      } else if (!_infinite! && _reverseWhenDone!) {
        _advancedXYposAnim.controller.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _advancedXYposAnim.controller.reverse();
            _resetQuotients();
          }
        });
      } else if (_infinite! && !_reverseWhenDone!) {
        _advancedXYposAnim.controller.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _advancedXYposAnim.controller.repeat();
            _resetQuotients();
          }
        });
      }
    }
    _advancedXYposAnim.xAnimation.addListener(() {
      final double val = _advancedXYposAnim.xAnimation.value;
      if (val > 0) {
        // val - (360 * _xQuotient) > 360 ? LIMITE_SUPERIOR
        while (val - _xQuotient * 2 * math.pi > 2 * math.pi) _xQuotient++;
        // val - (360 * _xQuotient) < 0 ? LIMITE_ INFERIOR
        while (val - _xQuotient * 2 * math.pi < 0) _xQuotient--;
        _xAminVal = val - _xQuotient * 2 * math.pi;
      } else {
        // val + (360 * _xQuotient) < -360 ? LIMITE_INFERIOR
        while (val + _xQuotient * 2 * math.pi < -2 * math.pi) _xQuotient++;
        // val + (360 * _xQuotient) > 0 ? LIMITE_SUPERIOR
        while (val + _xQuotient * 2 * math.pi > 0) _xQuotient--;
        _xAminVal = val + _xQuotient * 2 * math.pi;
      }
    });
    _advancedXYposAnim.yAnimation.addListener(() {
      final double val = _advancedXYposAnim.yAnimation.value;
      if (val > 0) {
        // val - (360 * _yQuotient) > 360 ? LIMITE_SUPERIOR
        while (val - _yQuotient * 2 * math.pi > 2 * math.pi) _yQuotient++;
        // val - (360 * _yQuotient) < 0 ? LIMITE_INFERIOR
        while (val - _yQuotient * 2 * math.pi < 0) _yQuotient--;
        _yAminVal = val - _yQuotient * 2 * math.pi;
      } else {
        // val + (360 * _yQuotient) < -360 ? LIMITE_INFERIOR
        while (val + _yQuotient * 2 * math.pi < -2 * math.pi) _yQuotient++;
        // vl + (360 * _yQuotient) > 0 ? LIMITE_SUPERIOR
        while (val + _yQuotient * 2 * math.pi > 0) _yQuotient--;
        _yAminVal = val + _yQuotient * 2 * math.pi;
      }
    });
    _advancedXYposAnim.xAnimation.addListener(_setXbegin);
    _advancedXYposAnim.yAnimation.addListener(_setYbegin);
  }

  void _setXbegin() {
    _xBeginVal = _advancedXYposAnim.xAnimation.value;
    _advancedXYposAnim.xAnimation.removeListener(_setXbegin);
  }

  void _setYbegin() {
    _yBeginVal = _advancedXYposAnim.yAnimation.value;
    _advancedXYposAnim.yAnimation.removeListener(_setYbegin);
  }

  @override
  void initState() {
    _isAdvanced = widget.advancedXYposAnim != null;
    _buildControllers();
    _setListeners();
    if (!_isAdvanced) _advancedXYposAnim.controller.forward();
    if (widget.buildOnSelect != null && _selectedAnim != null) {
      _customStars = widget.buildOnSelect!(widget.size, _selectedAnim!);
    }
    if (widget.stars && _selectedAnim != null) {
      _starsWidget = Stars(ctrl: _selectedAnim!, size: widget.size);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.onSelected != null
          ? Listenable.merge(
              [_advancedXYposAnim.controller, _selectedAnim!, _restoreAnim!])
          : _advancedXYposAnim.controller,
      builder: (context, child) {
        switch (_currentState) {
          case CurrentState.moving:
            return _buildMoving();
          case CurrentState.selected:
            return _buildSelected();
          case CurrentState.restore:
            return _buildRestore();
          default:
            throw Exception('Unimplemented state');
        }
      },
    );
  }

  // Get the height of the cubix
  double get _cubixTop =>
      _shadowAnimVal * widget.size * 0.5 * 5 / 12 - widget.size * 5 / 12;

  // Begin build mooving
  SizedBox _buildMoving() {
    return SizedBox(
      height: widget.shadow ? widget.size * 2 : widget.size * 1.2,
      width: widget.size * 1.2,
      child: Stack(
        children: [
          if (widget.shadow) _buildShadow(),
          Positioned(
            top: widget.shadow ? _cubixTop : 0,
            child: CubixD(
              delta: Vector2(_yAminVal, _xAminVal),
              onPanUpdate: widget.onSelected != null ? _onPanUpdate : null,
              size: widget.size,
              onSelected: widget.onSelected != null ? _seleCall : null,
              sensitivityFac: widget.sensitivityFac,
              top: widget.top,
              bottom: widget.bottom,
              left: widget.left,
              right: widget.right,
              front: widget.front,
              back: widget.back,
              debounceTime: widget.debounceTime,
            ),
          ),
        ],
      ),
    );
  }

  Positioned _buildShadow() => Positioned(
        bottom: 0,
        left: widget.size * 1.08 / 2,
        child: Transform.scale(
          scaleX: 7 / (_shadowAnimVal - 0.5),
          child: SizedBox(
            width: widget.size / 9,
            height: widget.size / 9,
            child: CustomPaint(
              foregroundPainter: _CircleBlurPainter(
                color: Colors.black.withOpacity(_shadowAnimVal / 6),
                blurSigma: 6 / (_shadowAnimVal),
                circleWidth: widget.size / 9,
              ),
            ),
          ),
        ),
      );
  // End build mooving

  // Begin build selected
  SizedBox _buildSelected() {
    return SizedBox(
      height: widget.shadow ? widget.size * 2 : widget.size * 1.2,
      width: widget.size * 1.2,
      child: Stack(
        children: [
          if (widget.shadow) _buildShadow(),
          Positioned(
            top: widget.shadow ? _cubixTop : 0,
            child: CubixD(
              delta: Vector2(_yVal.value, _xVal.value),
              size: widget.size,
              sensitivityFac: widget.sensitivityFac,
              top: widget.top,
              bottom: widget.bottom,
              left: widget.left,
              right: widget.right,
              front: widget.front,
              back: widget.back,
            ),
          ),
          if (_starsWidget != null)
            Positioned(
              top: _cubixTop,
              child: SizedBox(
                height: widget.size,
                width: widget.size,
                child: _starsWidget,
              ),
            ),
          if (_customStars != null)
            Positioned(
              top: _cubixTop,
              child: SizedBox(
                child: _customStars!,
                height: widget.size,
                width: widget.size,
              ),
            ),
        ],
      ),
    );
  }
  // End build selected

  // Begin restore
  // Get the height value for restore
  double get _shadowRtop =>
      _shadowRanim.value * widget.size * 0.5 * 5 / 12 - widget.size * 5 / 12;

  SizedBox _buildRestore() {
    return SizedBox(
      height: widget.shadow ? widget.size * 2 : widget.size * 1.2,
      width: widget.size * 1.2,
      child: Stack(
        children: [
          if (widget.shadow) _buildShadowR(),
          Positioned(
            top: widget.shadow ? _shadowRtop : 0,
            child: CubixD(
              delta: Vector2(_yVal.value, _xVal.value),
              size: widget.size,
              sensitivityFac: widget.sensitivityFac,
              top: widget.top,
              bottom: widget.bottom,
              left: widget.left,
              right: widget.right,
              front: widget.front,
              back: widget.back,
            ),
          ),
        ],
      ),
    );
  }

  Positioned _buildShadowR() {
    return Positioned(
      bottom: 0,
      left: widget.size * 1.08 / 2,
      child: Transform.scale(
        scaleX: 7 / (_shadowRanim.value - 0.5),
        child: SizedBox(
          width: widget.size / 9,
          height: widget.size / 9,
          child: CustomPaint(
            foregroundPainter: _CircleBlurPainter(
              color: Colors.black.withOpacity(_shadowRanim.value / 6),
              blurSigma: 6 / (_shadowRanim.value),
              circleWidth: widget.size / 9,
            ),
          ),
        ),
      ),
    );
  }
  // End build restore

  // Begin handle selection and restoring mechanism
  void _onPanUpdate() {
    _advancedXYposAnim.controller.stop();
    if (widget.onPanUpdate != null) widget.onPanUpdate!();
  }

  void _seleCall(SelectedSide opt, Vector2 tmp) {
    if (opt != SelectedSide.none && widget.onSelected!(opt)) {
      final Duration callDelay = widget.afterSelDel + widget.selDuration;
      final double tmpXval = CubixdUtils.getIvalue(tmp.x);
      final double tmpYval =
          opt == SelectedSide.bottom || opt == SelectedSide.top
              ? 0
              : CubixdUtils.getIvalue(tmp.y);

      _xVal = Tween<double>(begin: tmp.y, end: tmpYval).animate(_selectedCurve);
      _yVal = Tween<double>(begin: tmp.x, end: tmpXval).animate(_selectedCurve);

      Future.delayed(callDelay, () => _setRestoreAnim(tmpYval, tmpXval));
      _currentState = CurrentState.selected;
      _selectedAnim!.reset();
      _selectedAnim!.forward();
    } else {
      _setRestoreAnim(tmp.y, tmp.x);
    }
  }

  void _setRestoreAnim(double xBval, double yBval) {
    final Duration callDel = widget.afterRestDel + widget.restDuration;

    _xVal = Tween<double>(begin: xBval, end: _xBeginVal).animate(_restoreCurve);
    _yVal = Tween<double>(begin: yBval, end: _yBeginVal).animate(_restoreCurve);
    _shadowRanim =
        Tween<double>(begin: _shadowAnimVal, end: 2).animate(_restoreCurve);

    _currentState = CurrentState.restore;
    _restoreAnim!.reset();
    _restoreAnim!.forward();

    Future.delayed(callDel, () {
      _currentState = CurrentState.moving;
      _advancedXYposAnim.controller.reset();
      _advancedXYposAnim.controller.forward();
    });
  }
  // End handle selection and restoring mechanism

  @override
  void dispose() {
    if (!_isAdvanced) {
      _advancedXYposAnim.controller.dispose();
    }
    _restoreAnim?.dispose();
    _selectedAnim?.dispose();
    super.dispose();
  }
}

class _CircleBlurPainter extends CustomPainter {
  _CircleBlurPainter({
    required this.circleWidth,
    required this.blurSigma,
    required this.color,
  });
  final Color color;
  final double circleWidth;
  final double blurSigma;

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = circleWidth
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurSigma);
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = math.min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, line);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

# CubixD, a 3d cube

<div align="center">
  <img src="https://raw.githubusercontent.com/ElRojo7u7/cubixd/main/screenshots/main.webp" alt="3d cube mooving from right to left" title="Main demostration">
</div>

## Installation

Add cubixd to your pubspec.yaml dependencies

```yaml
dependencies:
  cubixd: ^0.1.1
```

And then import it:

```dart
import 'package:cubixd/cubixd.dart';
```

## Features

- Add this to your flutter app to get a 3d cube!

## Getting started

This package includes 2 widgets:

1. AnimatedCubixD
2. CubixD

AnimatedCubixD is the 3d cube animated, this widget uses 3 controllers (`AnimationController`) for 3 different animations.
Includes the shadow, the colorful stars, all animations and the functionality to select a field

CubixD is the static 3d cube, this widget includes the functionality to select a field (without the animation)

The example you saw at the beginning you can do it with the following code:

```dart
import 'package:cubixd/cubixd.dart';

Center(
  child: AnimatedCubixD(
    onSelected: ((SelectedSide opt) => opt == SelectedSide.bottom ? false : true),
    size: 200.0,
    left: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/graphql.png"),
          fit: BoxFit.cover,
        ),
      ),
    ),
    front: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/nestjs.png"),
          fit: BoxFit.cover,
        ),
      ),
    ),
    back: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/mongodb.png"),
          fit: BoxFit.cover,
        ),
      ),
    ),
    top: ...,
    bottom: ...,
    right: ...,
  ),
),
```

## AnimatedCubixD

### Parameters

| Parameter         | Type                                         |                                                                             Default value                                                                              | Description                                                                                                                                                                                                                                                                                                                                                                                        |
| ----------------- | -------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------: | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| advancedXYposAnim | AnimRequirements                             |                                                                                   -                                                                                    | Advanced XY Position Animation. If you want more control over the AnimationController and the 2 animations that requires, you could set this parameter. Keep in mind that the AnimationController won't forward and dispose automatically when you set this option. **You can read more information and examples down below**                                                                      |
| afterRestDel      | Duration                                     |                                                                      `Duration(miliseconds: 50)`                                                                       | After Restore Delay. This parameter represents the delay after the cubixd restore animation executes to make way to the main animation again                                                                                                                                                                                                                                                       |
| afterSelDel       | Duration                                     |                                                                         `Duration(seconds: 4)`                                                                         | After Selection Delay. This parameter represents the duration that cubixd waits after a face is selected, and right after that time restores the cubixd to the main animation                                                                                                                                                                                                                      |
| back \*           | Widget                                       |                                                                                   -                                                                                    | The widget that should be displayed on the back face side                                                                                                                                                                                                                                                                                                                                          |
| bottom \*         | Widget                                       |                                                                                   -                                                                                    | The widget that should be displayed on the bottom face side                                                                                                                                                                                                                                                                                                                                        |
| buildOnSelect     | Widget Function(double, AnimationController) |                                                                                  null                                                                                  | If you don't like the default starts animation that triggers when the user selects a face. With a great freedom, you could set a different one with this parameter. This one is quite complex, so **you can read more about this down below**                                                                                                                                                      |
| debounceTime      | Duration                                     |                                                                      `Duration(miliseconds: 500)`                                                                      | Debonce Time. The cubixd works with a debouncer, this means that when you constantly move the cubixd to select a face it won't execute the selection until you leave it static with a valid face and wait the duration specified here it will trigger the selection, otherwise if you move it just before time runs, it will "bounce" the selection and count back from 0 this time specified here |
| front \*          | Widget                                       |                                                                                   -                                                                                    | The widget that should be displayed on the front face side                                                                                                                                                                                                                                                                                                                                         |
| left \*           | Widget                                       |                                                                                   -                                                                                    | The widget that should be displayed on the left face side                                                                                                                                                                                                                                                                                                                                          |
| onPanUpdate       | void Function()                              |                                                                                  null                                                                                  | On Pan Update. This is a callback that executes whatever the user moves the cubixd to select a face                                                                                                                                                                                                                                                                                                |
| onRestCurve       | Curve                                        |                                                                         `Curves.fastOutSlowIn`                                                                         | On Restore Curve. This parameter sets the curve that should have the restore animation. Understand the restore animation as the animation that executes after the selection of a face occurs to restore the cubixd to its starting position                                                                                                                                                        |
| onSelecCurve      | Curve                                        |                                                                         `Curves.fastOutSlowIn`                                                                         | On Selection Curve. This parameter sets the curve that have the selection animation. Understand the selection animation as the animation that triggers just right when the debounce timer ends and triggers the selection                                                                                                                                                                          |
| onSelect          | bool Function(SelectedSide)                  |                                                                                  null                                                                                  | On Select. The callback that should trigger when a user selects a face                                                                                                                                                                                                                                                                                                                             |
| restDuration      | Duration                                     |                                                                      `Duration(miliseconds: 800)`                                                                      | Restore Duration. The duration that the restore animation should take                                                                                                                                                                                                                                                                                                                              |
| right \*          | Widget                                       |                                                                                   -                                                                                    | The widget that should be displayed on the right face side                                                                                                                                                                                                                                                                                                                                         |
| selDuration       | Duration                                     |                                                                      `Duration(miliseconds: 400)`                                                                      | Select Duration. The duration that the selection animation should take. Understand the selection animation as the animation that occurs just right after the debouncer triggers                                                                                                                                                                                                                    |
| sensitivityFac    | double                                       |                                                                                  1.0                                                                                   | Sensitivity Factor. Just like a mouse has a sensitivity when you move it. The cubixd has a sensitivity too. It's ideal that this value should be near 1 and not 0 or less. The greater its value, the sensitivity will be too                                                                                                                                                                      |
| shadow            | bool                                         |                                                                                  true                                                                                  | Shadow. Defines if the cubixd should have shadow. Take in mind that if there is no shadow, the cubixd it won't nicely move up and down at all (and the final height that this widget take up will be reduced)                                                                                                                                                                                      |
| simplePosAnim     | SimpleAnimRequirements                       | `SimpleAnimRequirements(duration: const Duration(seconds: 10), xBegin: -pi / 4, xEnd: (7*pi)/4, yBegin: pi / 4, yEnd: pi / 4, reverseWhenDone: false, infinite: true)` | If you don't want to set advanced options with an AnimationController you could use this parameter to set a few parameters to get your cubixd moving c: **You can read more information about this parameter down below**                                                                                                                                                                          |
| size \*           | double                                       |                                                                                   -                                                                                    | The width and height that each face should have                                                                                                                                                                                                                                                                                                                                                    |
| stars             | bool                                         |                                                                                  true                                                                                  | If the colorful stars should appear right after a face is selected                                                                                                                                                                                                                                                                                                                                 |
| top \*            | Widget                                       |                                                                                   -                                                                                    | The widget that should be displayed on the top face side                                                                                                                                                                                                                                                                                                                                           |

### onSelect

A 3d cube should always have 6 faces, but maybe you only want 5 faces. You could have 5 faces ready to be selected and 1 out of service.
that's what was thought when considering this parameter: A callback that sends the face that was selected, and if this callback returns false
that face can't be selected, otherwise it cans

```dart
AnimatedCubixD(
    ...
    onSelected: (SelectedSide opt) {
        switch (opt) {
            case SelectedSide.back:
                return true;
            case SelectedSide.top:
                return true;
            case SelectedSide.front:
                return true;
            case SelectedSide.bottom:
                return false; // out of service
            case SelectedSide.right:
                return true;
            case SelectedSide.left:
                return true;
            case SelectedSide.none:
                // You can do something else
                return false; // Nothing will happend if you return true at this point
            default:
                throw Exception("Unimplemented option");
        }
    }
    ...
),
```

If this parameter isn't set (null). The user won't be able to move the cubixd

As a result we obtain

<div align="center">
  <img src="https://raw.githubusercontent.com/ElRojo7u7/cubixd/main/screenshots/out-of-order.webp" alt="Mooving a 3d cube with the mouse" title="Out of order">
</div>

### advancedXYposAnim

### AnimRequirements

| Parameter     | Type                | Default value | Description                                                                                                                       |
| ------------- | ------------------- | :-----------: | --------------------------------------------------------------------------------------------------------------------------------- |
| controller \* | AnimationController |       -       | The AnimationController that should be used on the main animation. Here you can set the duration of the main animation            |
| xAnimation \* | Animation<double>   |       -       | The Animation<double> that should be used on the horizontal axis. Here you set the x start angle and the x end angle (in radians) |
| yAnimation \* | Animation<double>   |       -       | The Animation<double> that should be used on the vertical axis. Here you set the y start angle and the y end angle (in radians)   |

#### Example

```dart
...
late final AnimationController _mainCtrl;
late final Animation<double> _xAnimation;
late final Animation<double> _yAnimation;
...
@override
void initState(){
    _mainCtrl   = AnimationController(vsync: this, duration: const Duration(seconds: 10));

    _xAnimation = Tween<double>(begin: -pi / 4, end: pi * 2 - pi / 4).animate(_mainCtrl);
    _yAnimation = Tween<double>(begin: pi / 4, end: pi / 4).animate(_mainCtrl);

    _mainCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _mainCtrl.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _mainCtrl.forward();
      }
      print(status);
    });

    _mainCtrl.forward();
    super.initState();
}
...
AnimatedCubixD(
    ...
    advancedXYposAnim: AnimRequirements(
        controller: _mainCtrl,
        xAnimation: _xAnimation,
        yAnimation: _yAnimation,
    ),
    ...
),
...
@override
void dispose(){
    _mainCtrl.dispose();
    super.dispose();
}
...
```

### buildOnSelect

This is probably the most complex parameter of all this package, so I recommend you to read this section the times you need it

What if you would like to have another splash animation when you select a face? With this parameter, you could do so.
When the user selects a face, another animation is running to place the de cubixd to the selected face, I call this "select animation"
and this animation is completely different from the main animation, for that reason it has another AnimationController.

AnimatedCubixD use 3 different controllers for 3 different animations:

1. Main animation. It uses the controller you may or not passed to AnimatedCubixD from `advancedXYposAnim` parameter, if you didn't
   passed him any controller at all, it will create it himself and execute forward and dispose methods automatically

2. Select animation. It creates its controller only if `onSelect` parameter isn't null. This is used to execute the animation that
   plays to adjust the exact angles of the selected face

3. Restore animation. It creates its controller only if `onSelect` parameter isn't null. This is used to execute the animation that
   plays to adjust the cubixd to its initial position after a face was selected by the user

With this in mind, the callback of this parameter sends 2 arguments: size (double) and the select animation controller (`AnimationController`),
this callback expects you to return a widget that will display right after user selects a face

```dart
import 'dart:math';

import 'package:cubixd/cubixd.dart';
...
AnimatedCubixD(
    ...
    buildOnSelect: (double size, AnimationController ctrl) => CircleStar(ctrl: ctrl, size: size),
    stars: false,
    ...
),
...
class _Animations {
  final Animation<double> xAnim;
  final Animation<double> yAnim;
  final double size;

  _Animations(this.xAnim, this.yAnim, this.size);
}

class CircleStar extends StatelessWidget {
  final CurvedAnimation _curvedA;
  final double overflowQ            = 0.4;
  final List<_Animations> _starsA   = [];
  final List<int> _minMax           = [20, 35];

  CircleStar({
    Key? key,
    required AnimationController ctrl,
    required double size,
  })  : _curvedA = CurvedAnimation(parent: ctrl, curve: Curves.easeOutCubic),
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

    final int length        = Random().nextInt(_minMax[1] - _minMax[0]) + _minMax[0];
    final double overflow   = overflowQ * size;

    for (int i = 0; i < length; i++) {
      final double shapeSize = Random().nextDouble() * size * 0.8;

      final double lPos = Random().nextDouble() * size;
      final double tPos = Random().nextDouble() * size;

      final double xEnd;
      final double yEnd;

      if (-lPos.abs() % size < -tPos.abs() % size) {
        xEnd = lPos > size / 2 ? size + overflow : -overflow;
        yEnd = xEnd * (tPos / xEnd);
      } else {
        yEnd = tPos > size / 2 ? size + overflow : -overflow;
        xEnd = yEnd / (tPos / lPos);
      }
      _starsA.add(_Animations(
        Tween<double>(begin: lPos, end: xEnd).animate(_curvedA),
        Tween<double>(begin: tPos, end: yEnd).animate(_curvedA),
        shapeSize,
      ));
    }
  }

  List<Widget> get _buildList {
    final List<Widget> list = [];
    final Color color       = Color((Random().nextDouble() * 0xFFFFFF).toInt());

    for (int i = 0; i < _starsA.length; i++) {
      list.add(Positioned(
        left: 0,
        top: 0,
        child: Transform.translate(
          offset: Offset(_starsA[i].xAnim.value, _starsA[i].yAnim.value),
          child: Transform.rotate(
            angle: -4 * pi * _curvedA.value,
            child: ClipPath(
              clipper: _CircleStarClip(),
              child: Container(
                color: color.withOpacity(1 - _curvedA.value),
                height: _starsA[i].size,
                width: _starsA[i].size,
              ),
            ),
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

class _CircleStarClip extends CustomClipper<Path> {
  static const _starShrink  = 2;
  static const _starSides   = 5;
  static const _deg90       = pi / 2;

  @override
  Path getClip(Size size) {
    final double bigRad   = size.width / 2;

    final double centerX  = size.width / 2;
    final double centerY  = size.height / 2;

    final double smallRad = bigRad / _starShrink;

    const double sides    = 2 * pi / _starSides;
    final Path path       = Path()..moveTo(size.width / 2, 0);

    for (int i = 0; i < _starSides + 1; i++) {
      path.lineTo(cos(sides * i + _deg90) * bigRad + centerX,
          sin(sides * i + _deg90) * bigRad + centerY);

      path.lineTo(cos(sides * i + _deg90) * smallRad + centerX,
          sin(sides * i + _deg90) * smallRad + centerY);
    }
    return path..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
...
```

Hints:

1. You could have your custom animation and the default one (the starts) running together
2. You could code your custom animation with a `StatefulWidget` instead of a `StatelessWidget`
   and use a more orthodox method

**Here's a slow motion of the result:**

<div align="center">
  <img src="https://raw.githubusercontent.com/ElRojo7u7/cubixd/main/screenshots/circle-stars.webp" alt="Circle stars splashing when selecting" title="Circle stars">
</div>

### simplePosAnim

Previously, we stated that the default value that this parameter takes is:

```dart
import 'package:cubixd/cubixd.dart';
...
simplePosAnim: SimpleAnimRequirements(
    duration: const Duration(seconds: 10),
    infinite: true,
    reverseWhenDone: false,
    xBegin: -pi / 4,
    xEnd: (7*pi)/4,
    yBegin: pi / 4,
    yEnd: pi / 4,
),
...
```

cubixd takes that values as the default animation only if this parameter (simplePosAnim) and advancedXYposAnim are'nt set

Another example

```dart
import 'package:cubixd/cubixd.dart';
...
simplePosAnim: SimpleAnimRequirements(
    duration: const Duration(seconds: 11),
    infinite: true,
    reverseWhenDone: true,
    xBegin: pi / 4,
    xCurve: Curves.ease,
    xEnd: 2 * pi,
    yBegin: -pi / 4,
    yCurve: Curves.ease,
    yEnd: 4 * pi,
),
...
```

### SimpleAnimRequirements

| Parameter       | Type     |  Default value  | Description                                                                        |
| --------------- | -------- | :-------------: | ---------------------------------------------------------------------------------- |
| duration \*     | Duration |        -        | The duration that the main animation should have                                   |
| infinite        | bool     |      true       | If the main animation should play infinitely                                       |
| reverseWhenDone | bool     |      false      | If the cubixd should play backwards when it finishes                               |
| xBegin \*       | double   |        -        | The horizontal angle (in radians) that should be set at the start of the animation |
| xCurve          | Curve    | `Curves.linear` | The curve that should have the main animation on its horizontal axis               |
| xEnd \*         | double   |        -        | The horizontal angle (in radians) that should be set at the end of the animation   |
| yBegin \*       | double   |        -        | The vertical angle (in radians) that should be set at the start of the animation   |
| yCurve          | Curve    | `Curves.linear` | The curve that should have the main animation on its vertical axis                 |
| yEnd \*         | double   |        -        | The vertical angle (in radians) that should be set at the end of the animation     |

## CubixD

CubixD is the widget that displays the 3d cube. The shadow and the rotating animation are'nt part of this widget,
but the selection of a face it is part of this widget (almost), by the exception that the animation that plays to place
the cubixd to its exact correct position of the face it'sn't part of this widget

### Parameters

| Parameter      | Type                                           |         Default value         | Description                                                                                                                                                                                                                                                                                                                                                                                        |
| -------------- | ---------------------------------------------- | :---------------------------: | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| back \*        | Widget                                         |               -               | The widget that should be displayed on the back face side                                                                                                                                                                                                                                                                                                                                          |
| bottom \*      | Widget                                         |               -               | The widget that should be displayed on the bottom face side                                                                                                                                                                                                                                                                                                                                        |
| debounceTime   | Duration                                       | `Duration(milliseconds: 500)` | Debonce Time. The cubixd works with a debouncer, this means that when you constantly move the cubixd to select a face it won't execute the selection until you leave it static with a valid face and wait the duration specified here it will trigger the selection, otherwise if you move it just before time runs, it will "bounce" the selection and count back from 0 this time specified here |
| delta \*       | Vector2                                        |               -               | The horizontal and vertical angle (in radians) of the cubixd. **You can read more about this down below**                                                                                                                                                                                                                                                                                          |
| front \*       | Widget                                         |               -               | The widget that should be displayed on the front face side                                                                                                                                                                                                                                                                                                                                         |
| left \*        | Widget                                         |               -               | The widget that should be displayed on the left face side                                                                                                                                                                                                                                                                                                                                          |
| onPanUpdate    | VoidCallback                                   |             null              | On Pan Update. This is a callback that executes whatever the user moves the cubixd to select a face                                                                                                                                                                                                                                                                                                |
| onSelected     | void Function(SelectedSide opt, Vector2 delta) |             null              | On Selected. The callback that should trigger when a user selects a face                                                                                                                                                                                                                                                                                                                           |
| right \*       | Widget                                         |               -               | The widget that should be displayed on the right face side                                                                                                                                                                                                                                                                                                                                         |
| sensitivityFac | double                                         |              1.0              | Sensitivity Factor. Just like a mouse has a sensitivity when you move it. The cubixd has a sensitivity too. It's ideal that this value should be near 1 and not 0 or less. The greater its value, the sensitivity will be too                                                                                                                                                                      |
| size \*        | double                                         |               -               | The width and height that each face should have                                                                                                                                                                                                                                                                                                                                                    |
| top \*         | Widget                                         |               -               | The widget that should be displayed on the top face side                                                                                                                                                                                                                                                                                                                                           |

### delta

This parameter represents the horizontal and vertical angle of the cubixd (in radians)
AnimatedCubixD uses this parameter with an AnimatedBuilder to get the animation running by
updating every time its respective controller indicates it

```dart
import 'package:vector_math/vector_math_64.dart' show Vector2;
import 'package:cubixd/cubixd.dart';
...
CubixD(
    ...
    delta: Vector2(verticalAngle, horizontalAngle)
    ...
),
...
```

Here's an example

```dart
import 'package:cubixd/cubixd.dart';
...
CubixD(
  size: 200.0,
  delta: Vector2(pi / 4, pi / 4),
  onSelected: (SelectedSide opt, Vector2 delta) {
    print('On selected callback:\n\topt = ${opt}\n\tdelta = ${delta}');
  },
  front: ...,
  back: ...,
  right: ...,
  left: ...,
  top: ...,
  bottom: ...,
),
...
```

As a result we obtain:

<div align="center">
  <img src="https://raw.githubusercontent.com/ElRojo7u7/cubixd/main/screenshots/static.webp" alt="Mooving a 3d cube with the mouse" title="Static">
</div>

## Extras

### SelectedSide

SelectedSide it's an enum that helps to know which side has been selected:

```dart
enum SelectedSide { front, back, right, left, top, bottom, none }
```

### Calculations are'nt exact

Be aware that when you want to get a specific angle. The horizontal angle "changes" the direction
based on the vertical angle, here's an example of this:

If the vertical angle is between -90° and 90°. A horizontal angle grater than 0 (positive)
has a direction from right to left.

Otherwise, if the vertical angle is grater than 90°. A horizontal angle grater than 0 (positive)
has a direction from left to right.

<div align="center">
  <img src="https://raw.githubusercontent.com/ElRojo7u7/cubixd/main/screenshots/angles.webp" alt="3d cube rotating on itself showing its angles of rotation" title="Angles and direction">
</div>

### TODO

1. Maybe attach the front, back, right, left, top and bottom widgets would be better
   to do with a widget list `List<Widget>`

2. Offer the possibility to control the up and down animation

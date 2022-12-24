import 'dart:math';
import 'package:flutter/material.dart';

import 'package:cubixd/cubixd.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    _ctrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _ctrl.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CubixD test")),
      body: Center(
        child: AnimatedCubixD(
          size: 300,
          // simplePosAnim: SimpleAnimRequirements(
          //   duration: const Duration(seconds: 8),
          //   xBegin: pi / 4,
          //   xEnd: 2 * pi,
          //   yBegin: -pi / 4,
          //   yEnd: 4 * pi,
          //   reverseWhenDone: true,
          // ),
          advancedXYposAnim: AnimRequirements(
            controller: _ctrl,
            xAnimation: Tween<double>(begin: -pi / 4, end: pi * 2 - pi / 4)
                .animate(_ctrl),
            yAnimation:
                Tween<double>(begin: pi / 4, end: pi / 4).animate(_ctrl),
          ),
          stars: true,
          shadow: true,
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
                return false;
              default:
                throw Exception("Unimplemented option");
            }
          },
          top: Container(
            color: Colors.red,
          ),
          bottom: Container(
            color: Colors.pink,
          ),
          left: Container(
            color: Colors.blue,
          ),
          right: Container(
            color: Colors.yellow,
          ),
          front: Container(
            color: Colors.amber,
          ),
          back: Container(
            color: Colors.greenAccent,
          ),
        ),
      ),
    );
  }
}

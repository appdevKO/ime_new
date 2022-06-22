import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/TD_game.dart';

class SpinningContainer extends AnimatedWidget {
  const SpinningContainer({
    Key? key,
    required AnimationController controller,
  }) : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable as Animation<double>;
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      alignment: Alignment.center,
      angle: _progress.value * GetPos() * math.pi,
      // 12.25 右上 12.75 右下 1更新房間3.25 左下 13.75 左上  雙數:右 單數:左
      child: Container(
        width: 200,
        height: 250,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/tdGame/arrow.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

/*class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));

    _controller!.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpinningContainer(controller: _controller!);
  }
}*/

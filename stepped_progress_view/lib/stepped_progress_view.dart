library stepped_progress_view;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stepped_progress_view/painters/circular_animation_painter.dart';

class SteppedProgressView extends StatefulWidget {
  const SteppedProgressView({Key? key}) : super(key: key);

  @override
  State<SteppedProgressView> createState() => _SteppedProgressViewState();
}

class _SteppedProgressViewState extends State<SteppedProgressView>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  Tween<double> _rotationTween = Tween(begin: 0, end: 1);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = _rotationTween.animate(_controller!)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller!.repeat();
        } else if (status == AnimationStatus.dismissed) {
          _controller!.forward();
        }
      });

    _controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(22, 188, 62, 188),
      height: 200,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: CircularAnimationPainter(
              color: Color.fromARGB(100, 80, 57, 16),
              startAngle: 1,
              value: _animation!.value,
              strokeWidth: 5,
            ),
            child: const SizedBox(
              height: 200,
              width: 200,
            ),
          ),
          CustomPaint(
            painter: CircularAnimationPainter(
              color: Color.fromARGB(100, 200, 7, 16),
              startAngle: pi / 4,
              value: _animation!.value,
            ),
            child: const SizedBox(
              height: 180,
              width: 180,
            ),
          ),
          CustomPaint(
            painter: CircularAnimationPainter(
              color: Color.fromARGB(99, 1, 255, 102),
              startAngle: 1,
              strokeWidth: 4,
              reverse: true,
              value: _animation!.value,
            ),
            child: const SizedBox(
              height: 130,
              width: 130,
            ),
          ),
                    CustomPaint(
            painter: CircularAnimationPainter(
              color: Color.fromARGB(98, 255, 2, 150),
              startAngle: 1,
              strokeWidth: 7,
              reverse: true,
              value: _animation!.value,
            ),
            child: const SizedBox(
              height: 110,
              width: 110,
            ),
          ),
        ],
      ),
    );
  }
}

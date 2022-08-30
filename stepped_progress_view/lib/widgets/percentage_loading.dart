import 'dart:math';

import 'package:flutter/material.dart';

import '../painters/circular_animation_painter.dart';

class PercentageLoading extends StatefulWidget {
  final double startValue;
  final double percentage;

  const PercentageLoading({Key? key, this.startValue = 0, this.percentage = 0})
      : super(key: key);

  @override
  State<PercentageLoading> createState() => _PercentageLoadingState();
}

class _PercentageLoadingState extends State<PercentageLoading>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  Tween<double>? _rotationTween;
  double? startValue;

  @override
  void initState() {
    super.initState();
    startValue = widget.startValue;
    _rotationTween = Tween(begin: startValue, end: 1);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _animation = _rotationTween!.animate(_controller!)
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
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: CircularAnimationPainter(
            color: Color.fromARGB(100, 80, 57, 16),
            startAngle: 1,
            strokeWidth: 7,
            value: _animation!.value,
            sweepAngle: widget.percentage * 2 * pi,
          ),
          child: const SizedBox(
            height: 200,
            width: 200,
          ),
        ),
        Text(
          '${(widget.percentage * 100).toInt()}%',
          style: TextStyle(color: Color(0xFFFFFFFF)),
        ),
      ],
    );
  }

  @override
  dispose() {
    _controller!.dispose();
    super.dispose();
  }
}

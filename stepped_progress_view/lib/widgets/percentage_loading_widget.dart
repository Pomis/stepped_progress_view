import 'dart:math';

import 'package:flutter/material.dart';

import '../models/animated_arc.dart';
import '../painters/circular_animation_painter.dart';

class PercentageLoadingWidget extends StatefulWidget {
  final double startValue;
  final double percentage;
  final AnimatedArc arc;
  final TextStyle textStyle;

  const PercentageLoadingWidget({
    Key? key,
    required this.arc,
    required this.textStyle,
    this.startValue = 0,
    this.percentage = 0,
  }) : super(key: key);

  @override
  State<PercentageLoadingWidget> createState() =>
      _PercentageLoadingWidgetState();
}

class _PercentageLoadingWidgetState extends State<PercentageLoadingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late final Tween<double> _tween;
  double? startValue;

  @override
  void initState() {
    super.initState();
    startValue = widget.startValue;
    _tween = Tween(begin: startValue, end: 1);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _animation = _tween.animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.repeat();
        }
      });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: CircularAnimationPainter(
            color: widget.arc.color,
            startAngle: widget.arc.startAngle,
            strokeWidth: widget.arc.strokeWidth,
            reverse: widget.arc.reverse,
            value: _animation.value,
            sweepAngle: widget.percentage * 2 * pi,
          ),
          child: SizedBox(
            height: widget.arc.size,
            width: widget.arc.size,
          ),
        ),
        Text(
          '${(widget.percentage * 100).toInt()}%',
          style: widget.textStyle,
        ),
      ],
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }
}

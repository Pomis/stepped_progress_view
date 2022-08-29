import 'package:flutter/material.dart';

import '../painters/circular_animation_painter.dart';

class AnimatedArc extends StatelessWidget {
  final Color color;
  final double size;
  final double startAngle;
  final bool reverse;
  final double strokeWidth;
  final double value;

  const AnimatedArc({
    Key? key,
    required this.color,
    required this.size,
    required this.startAngle,
    this.reverse = false,
    required this.strokeWidth,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CircularAnimationPainter(
        color: color,
        startAngle: startAngle,
        strokeWidth: strokeWidth,
        reverse: reverse,
        value: value,
      ),
      child: SizedBox(
        height: size,
        width: size,
      ),
    );
  }
}

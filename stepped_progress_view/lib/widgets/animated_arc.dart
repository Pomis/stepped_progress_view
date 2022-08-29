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
        color: Color.fromARGB(98, 255, 2, 150),
        startAngle: 1,
        strokeWidth: 7,
        reverse: true,
        value: value,
      ),
      child: const SizedBox(
        height: 110,
        width: 110,
      ),
    );
  }
}

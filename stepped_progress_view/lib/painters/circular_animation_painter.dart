import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CircularAnimationPainter extends CustomPainter {
  /// Start point on circle in radians
  final double startAngle;
  final Color color;

  /// Animation value in range of 0 to 1
  final double value;
  final double maxSweepAngle;
  final List<double> animationPattern;

  CircularAnimationPainter({
    required this.startAngle,
    required this.color,
    required this.value,
    this.maxSweepAngle = pi,
    this.animationPattern = const [0.1, 0.1, 0.1, 1, 0.1, 1, 0.1],
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawArc(
      Rect.fromLTRB(0, 0, size.width, size.height),
      _calculateOffsetAngle(),
      // 0.5,
      // 10,
      _calculateSweepAngle(),
      false,
      paint,
    );
  }

  double _calculateSweepAngle() {
    final lengthValue = value * (animationPattern.length - 1);
    final lowerValue = animationPattern[lengthValue.toInt()];
    final upperValue = animationPattern[lengthValue.ceil().toInt()];
    final lowK = lengthValue - lowerValue;
    final upK = 1 - lowK;
    final extrapolatedValue = lowerValue * lowK + upperValue * upK;
    return maxSweepAngle * extrapolatedValue;
  }

  double _calculateOffsetAngle() {
    return 2 * pi * value;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return (oldDelegate as CircularAnimationPainter).value != value;
  }
}

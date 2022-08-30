import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CircularAnimationPainter extends CustomPainter {
  /// Start point on circle in radians
  final double startAngle;
  final Color color;

  /// Animation value in range of 0 to 1. Corresponds to [spins] amount.
  final double value;

  /// In case you want to override sweep angle
  final double? sweepAngle;
  final double maxSweepAngle;
  final double minSweepAngle;
  final double expandAt;
  final int spins;
  final double strokeWidth;
  final bool reverse;

  CircularAnimationPainter({
    required this.startAngle,
    required this.color,
    required this.value,
    this.expandAt = 0.5,
    this.maxSweepAngle = pi / 2,
    this.minSweepAngle = pi / 10,
    this.strokeWidth = 2,
    this.spins = 2,
    this.sweepAngle,
    this.reverse = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawArc(
      Rect.fromLTRB(0, 0, size.width, size.height),
      reverse ? 2 * pi - _calculateOffsetAngle() : _calculateOffsetAngle(),
      _calculateSweepAngle(),
      false,
      paint,
    );
  }

  double _calculateSweepAngle() {
    if (sweepAngle != null) {
      return sweepAngle!;
    }
    if (value < expandAt) {
      return minSweepAngle;
    } else {
      final radians = pi * (value - expandAt) * (1 / expandAt);
      final y = sin(radians);
      return minSweepAngle + y * maxSweepAngle;
    }
  }

  double _calculateOffsetAngle() {
    return startAngle + spins * 2 * pi * value -
        (_calculateSweepAngle() * (reverse ? -1 : 1) / 2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return (oldDelegate as CircularAnimationPainter).value != value;
  }
}

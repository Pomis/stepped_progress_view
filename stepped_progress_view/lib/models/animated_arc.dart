import 'package:flutter/material.dart';

class AnimatedArc {
  final Color color;
  final double size;
  final double startAngle;
  final bool reverse;
  final double strokeWidth;

  AnimatedArc({
    required this.color,
    required this.size,
    this.startAngle = 0,
    this.reverse = false,
    this.strokeWidth = 3,
  });
}

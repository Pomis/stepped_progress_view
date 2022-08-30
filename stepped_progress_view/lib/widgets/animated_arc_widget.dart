import 'package:flutter/material.dart';
import 'package:stepped_progress_view/stepped_progress_view.dart';

import '../painters/circular_animation_painter.dart';

class AnimatedArcWidget extends StatelessWidget {
  final Color color;
  final double size;
  final double startAngle;
  final bool reverse;
  final double strokeWidth;
  final double value;

  const AnimatedArcWidget({
    Key? key,
    required this.color,
    required this.size,
    required this.startAngle,
    this.reverse = false,
    required this.strokeWidth,
    required this.value,
  }) : super(key: key);

  factory AnimatedArcWidget.fromModel(AnimatedArc model, double value) {
    return AnimatedArcWidget(
      value: value,
      color: model.color,
      size: model.size,
      startAngle: model.startAngle,
      strokeWidth: model.strokeWidth,
      reverse: model.reverse,
    );
  }

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

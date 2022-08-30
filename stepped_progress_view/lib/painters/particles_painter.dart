import 'dart:math';

import 'package:flutter/material.dart';

class ParticlesPainter extends CustomPainter {
  final double value;
  final int particlesCount;
  final List<Color> colors;
  final int particlesMargin;
  final double hideAt;

  ParticlesPainter({
    required this.value,
    required this.particlesCount,
    this.particlesMargin = 5,
    this.hideAt = 0.9,
    required this.colors,
  });

  static const _gravity = 15;
  static const _baseVelocity = 30;

  @override
  void paint(Canvas canvas, Size size) {
    final opacity = value > hideAt ? 0 : 1;
    final paint = Paint()
      ..color = Color(0xFFaa33aa).withAlpha(a)
      ..style = PaintingStyle.fill;
    for (var i = 0; i < particlesCount - 1; i++) {
      canvas.drawCircle(_calculateOffset(size, i), 5, paint);
    }
  }

  Offset _calculateOffset(Size size, int i) {
    final v = _baseVelocity * value;
    var x = size.width / 2 + sin(i) * particlesMargin * i * v;
    var y = size.height / 2 +
        cos(i) * particlesMargin * i * v +
        _gravity * v * v / 2;
    if (x <= 0) {
      x = -1 * x;
    }
    if (x >= size.width) {
      x = size.width - x.remainder(size.width);
    }
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    final painter = (oldDelegate as ParticlesPainter);
    return painter.value != value && painter.particlesCount != particlesCount;
  }
}

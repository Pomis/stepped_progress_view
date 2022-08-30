import 'dart:math';

import 'package:flutter/material.dart';

import '../models/particle.dart';

class ParticlesPainter extends CustomPainter {
  final double value;
  final List<Particle> particles;
  final List<Color> colors;
  final int particlesMargin;
  final double hideAt;

  ParticlesPainter({
    required this.value,
    required this.particles,
    this.particlesMargin = 5,
    this.hideAt = 0.9,
    required this.colors,
  });

  static const _gravity = 30;
  static const _baseVelocity = 30;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final offset = _calculateOffset(size, particle);
      final rotation =
          particle.initialRotation + value * min(2, offset.dy / offset.dx);
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(rotation);
      canvas.drawPath(particle.path, particle.paint);
      canvas.rotate(-rotation);
      canvas.translate(-offset.dx, -offset.dy);
    }
  }

  Offset _calculateOffset(Size size, Particle particle) {
    var x = size.width / 2 + particle.velocityVector.dx * value;
    var y = size.height / 2 +
        particle.velocityVector.dy * value +
        value * _gravity * value * value / 2;
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
    return painter.value != value && painter.particles != particles;
  }
}

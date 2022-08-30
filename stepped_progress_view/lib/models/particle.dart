import 'package:flutter/material.dart';

class Particle {
  final Offset velocityVector;
  final Path path;
  final Paint paint;
  final double initialRotation;

  Particle({
    required this.velocityVector,
    required this.path,
    required this.paint,
    required this.initialRotation,
  });
}

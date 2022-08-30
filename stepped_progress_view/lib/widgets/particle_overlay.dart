import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stepped_progress_view/models/particle.dart';

import '../painters/particles_painter.dart';

class ParticleOverlay extends StatefulWidget {
  final int particlesCount;
  final List<Color> colors;
  final int durationSeconds;
  final double particlesBaseVelocity;

  const ParticleOverlay({
    Key? key,
    this.particlesCount = 60,
    this.durationSeconds = 10,
    this.particlesBaseVelocity = 400,
    required this.colors,
  }) : super(key: key);

  @override
  State<ParticleOverlay> createState() => _ParticleOverlayState();
}

class _ParticleOverlayState extends State<ParticleOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  Tween<double>? _tween;
  double? startValue;
  List<Particle>? _particles;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _tween = Tween(begin: 0.3, end: 6);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.durationSeconds),
    );

    _animation = _tween!.animate(_controller!)
      ..addListener(() {
        setState(() {});
      });
    _controller!.forward();

    _particles = _generateParticles().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Opacity(
              opacity: min(1, 6 - _animation!.value),
              child: CustomPaint(
                painter: ParticlesPainter(
                  colors: [],
                  particles: _particles!,
                  value: _animation!.value,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Iterable<Particle> _generateParticles() sync* {
    for (var i = 0; i < widget.particlesCount - 1; i++) {
      final showCurvedParticle = _random.nextDouble() > 0.7;
      yield Particle(
        initialRotation: _random.nextDouble() * pi,
        velocityVector: Offset(
            _random.nextDouble() * widget.particlesBaseVelocity -
                widget.particlesBaseVelocity / 2,
            _random.nextDouble() * widget.particlesBaseVelocity -
                widget.particlesBaseVelocity / 2),
        paint: Paint()
          ..style = showCurvedParticle
              ? PaintingStyle.stroke
              : PaintingStyle.fill
          ..strokeWidth = 2
          ..color = widget.colors[_random.nextInt(widget.colors.length - 1)],
        path: showCurvedParticle ? _getCurvedPath() : _getRectPath(),
      );
    }
  }

  Path _getCurvedPath() {
    return Path()
      ..quadraticBezierTo(30, 5, 15, 10)
      ..quadraticBezierTo(0, 5, 30, 0);
  }

  Path _getRectPath() {
    return Path()
      ..addRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: _random.nextDouble() * 25,
          height: _random.nextDouble() * 25,
        ),
      );
  }
}

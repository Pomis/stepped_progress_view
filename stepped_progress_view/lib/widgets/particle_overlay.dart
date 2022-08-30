import 'package:flutter/material.dart';

import '../painters/particles_painter.dart';

class ParticleOverlay extends StatefulWidget {
  const ParticleOverlay({Key? key}) : super(key: key);

  @override
  State<ParticleOverlay> createState() => _ParticleOverlayState();
}

class _ParticleOverlayState extends State<ParticleOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  Tween<double>? _tween;
  double? startValue;

  @override
  void initState() {
    super.initState();
    _tween = Tween(begin: 0, end: 1);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animation = _tween!.animate(_controller!)
      ..addListener(() {
        setState(() {});
      });
    _controller!.forward();
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
            child: CustomPaint(
              painter: ParticlesPainter(
                colors: [],
                particlesCount: 30,
                value: _animation!.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

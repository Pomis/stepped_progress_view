import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stepped_progress_view/widgets/particle_overlay.dart';

import '../painters/circular_animation_painter.dart';
import '../painters/particles_painter.dart';

class DoneAnimation extends StatefulWidget {
  final double startValue;
  final double percentage;

  const DoneAnimation({Key? key, this.startValue = 0, this.percentage = 0})
      : super(key: key);

  @override
  State<DoneAnimation> createState() => _DoneAnimationState();
}

class _DoneAnimationState extends State<DoneAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? _scaleController;
  Animation<double>? _scaleAnimation;
  Tween<double>? _scaleTween;

  @override
  void initState() {
    super.initState();
    _scaleTween = Tween(begin: 0.3, end: 1);
    _scaleController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration * 10,
    );

    _scaleAnimation = _scaleTween!.animate(_scaleController!)
      ..addListener(() {
        setState(() {});
      });

    _scaleController!.forward();

    _showOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: CircularAnimationPainter(
            color: Color.fromARGB(100, 80, 57, 16),
            startAngle: 1,
            strokeWidth: 7,
            value: 0,
            sweepAngle: 2 * pi,
          ),
          child: const SizedBox(
            height: 200,
            width: 200,
          ),
        ),
        Transform.scale(
          scale: _scaleAnimation!.value,
          child: const Text(
            'Done',
            style: TextStyle(color: Color(0xFFFFFFFF)),
          ),
        ),
      ],
    );
  }

  void _showOverlay() async {
    OverlayState? overlayState = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      maintainState: true,
      builder: (context) {
        return FadeTransition(
          opacity: _scaleAnimation!,
          child: ParticleOverlay(),
        );
      },
    );
    _scaleController!.addListener(() {
      overlayState!.setState(() {});
    });
    // inserting overlay entry
    overlayState!.insert(overlayEntry);
    _scaleController!.forward();
    await Future.delayed(const Duration(seconds: 3))
        .whenComplete(() => _scaleController!.reverse())
        // removing overlay entry after stipulated time.
        .whenComplete(() => overlayEntry.remove());
  }
}

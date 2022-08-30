import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stepped_progress_view/widgets/particle_overlay.dart';

import '../painters/circular_animation_painter.dart';
import '../painters/particles_painter.dart';

class DoneAnimation extends StatefulWidget {
  final double startValue;
  final double percentage;
  final int durationSeconds;

  const DoneAnimation(
      {Key? key,
      this.startValue = 0,
      this.percentage = 0,
      this.durationSeconds = 10})
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
    _scaleTween = Tween(begin: 0, end: widget.durationSeconds.toDouble());
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _scaleAnimation = _scaleTween!.animate(_scaleController!)
      ..addListener(() {
        setState(() {});
      });

    _scaleController!.forward();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _showOverlay();
    });
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
        RepaintBoundary(
          child: Transform.scale(
            scale: min(_scaleAnimation!.value, 1),
            child: const Text(
              'Done',
              style: TextStyle(color: Color(0xFFFFFFFF)),
            ),
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
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 1, end: 0),
          builder: (_, value, __) {
            return Opacity(
              key: Key('particle_overlay'),
              opacity: value,
              child: ParticleOverlay(
                durationSeconds: 5,
                colors: [
                  Colors.deepOrangeAccent,
                  Colors.deepPurpleAccent,
                  Colors.lime,
                ],
              ),
            );
          },
          duration: Duration(seconds: 5),
        );
      },
    );
    _scaleController!.addListener(() {
      overlayState!.setState(() {});
    });
    // inserting overlay entry
    overlayState!.insert(overlayEntry);
    // _scaleController!.forward();
    // await Future.delayed(const Duration(seconds: 3))
    //     .whenComplete(() => _scaleController!.reverse())
    //     .whenComplete(() => overlayEntry.remove());
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stepped_progress_view/widgets/particle_overlay.dart';

import '../models/animated_arc.dart';
import '../painters/circular_animation_painter.dart';

class DoneAnimation extends StatefulWidget {
  final double startValue;
  final double percentage;
  final int durationSeconds;
  final List<AnimatedArc> arcs;
  final TextStyle textStyle;

  const DoneAnimation({
    Key? key,
    this.startValue = 0,
    this.percentage = 0,
    required this.arcs,
    required this.textStyle,
    this.durationSeconds = 10,
  }) : super(key: key);

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
      duration: const Duration(seconds: 1),
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
            color: widget.arcs.first.color,
            startAngle: widget.arcs.first.startAngle,
            strokeWidth: widget.arcs.first.strokeWidth,
            value: 0,
            sweepAngle: 2 * pi,
          ),
          child: SizedBox(
            height: widget.arcs.first.size,
            width: widget.arcs.first.size,
          ),
        ),
        RepaintBoundary(
          child: Transform.scale(
            scale: min(_scaleAnimation!.value, 1),
            child: Text(
              'All done',
              style: widget.textStyle,
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
              key: const Key('particle_overlay'),
              opacity: value,
              child: ParticleOverlay(
                durationSeconds: 5,
                colors: widget.arcs.map((e) => e.color).toList(),
              ),
            );
          },
          duration: const Duration(seconds: 5),
        );
      },
    );
    _scaleController!.addListener(() {
      overlayState!.setState(() {});
    });
    overlayState!.insert(overlayEntry);
  }
}

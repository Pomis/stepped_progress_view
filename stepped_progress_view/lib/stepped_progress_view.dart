library stepped_progress_view;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stepped_progress_view/painters/circular_animation_painter.dart';

import 'widgets/animated_arc.dart';
import 'widgets/percentage_loading.dart';

class SteppedProgressView extends StatefulWidget {
  final double value;
  const SteppedProgressView({
    this.value = 0,
    Key? key,
  }) : super(key: key);

  @override
  State<SteppedProgressView> createState() => _SteppedProgressViewState();
}

class _SteppedProgressViewState extends State<SteppedProgressView>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  Tween<double> _rotationTween = Tween(begin: 0, end: 1);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = _rotationTween.animate(_controller!)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller!.repeat();
        } else if (status == AnimationStatus.dismissed) {
          _controller!.forward();
        }
      });
    _controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value == 0) {
      return _undefinedLoading();
    }
    return _percentageLoading();
  }

  Widget _undefinedLoading() {
    return Container(
      color: Color.fromARGB(22, 188, 62, 188),
      height: 200,
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedArc(
            color: Color.fromARGB(100, 80, 57, 16),
            startAngle: 1,
            value: _animation!.value,
            strokeWidth: 7,
            size: 200,
          ),
          AnimatedArc(
            color: Color.fromARGB(100, 200, 7, 16),
            startAngle: pi / 4,
            value: _animation!.value,
            size: 180,
            strokeWidth: 2,
          ),
          AnimatedArc(
            color: Color.fromARGB(99, 1, 255, 102),
            startAngle: 1,
            strokeWidth: 4,
            reverse: true,
            value: _animation!.value,
            size: 130,
          ),
          AnimatedArc(
            color: Color.fromARGB(98, 255, 2, 150),
            startAngle: 1,
            strokeWidth: 7,
            reverse: true,
            value: _animation!.value,
            size: 110,
          ),
        ],
      ),
    );
  }

  Widget _percentageLoading() {
    return PercentageLoading(
      percentage: widget.value,
      startValue: _animation!.value,
    );
  }
}

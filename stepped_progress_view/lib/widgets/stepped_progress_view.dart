import 'package:flutter/material.dart';

import '../models/animated_arc.dart';
import 'animated_arc_widget.dart';
import 'done_animation.dart';
import 'percentage_loading_widget.dart';

class SteppedProgressView extends StatefulWidget {
  /// Animation value from 0.0 to 1.0
  final double value;

  /// Arcs to be shown during loading when [value] is 0.0. First item is assumed to be a primary arc
  /// and will be shown in the next steps
  final List<AnimatedArc> arcs;

  final TextStyle textStyle;

  const SteppedProgressView({
    this.value = 0,
    required this.arcs,
    this.textStyle = const TextStyle(color: Colors.white),
    Key? key,
  })  : assert(arcs.length > 0, 'You should pass at least one arc'),
        super(key: key);

  @override
  State<SteppedProgressView> createState() => _SteppedProgressViewState();
}

class _SteppedProgressViewState extends State<SteppedProgressView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  );
  late final Animation<double> _animation;
  final Tween<double> _rotationTween = Tween(begin: 0, end: 1);

  @override
  void initState() {
    super.initState();

    _animation = _rotationTween.animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value == 0) {
      return _undefinedLoading();
    }
    if (widget.value >= 1) {
      return DoneAnimation(arcs: widget.arcs, textStyle: widget.textStyle);
    }
    return PercentageLoadingWidget(
      percentage: widget.value,
      startValue: _animation.value,
      textStyle: widget.textStyle,
      arc: widget.arcs.first,
    );
  }

  Widget _undefinedLoading() {
    return SizedBox(
      height: widget.arcs.first.size,
      width: widget.arcs.first.size,
      child: Stack(
        alignment: Alignment.center,
        children: widget.arcs
            .map((it) => AnimatedArcWidget.fromModel(it, _animation.value))
            .toList(),
      ),
    );
  }
}

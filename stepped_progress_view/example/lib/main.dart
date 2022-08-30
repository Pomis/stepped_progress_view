import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stepped_progress_view/stepped_progress_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  final Tween<double> _tween = Tween(begin: 0, end: 1);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animation = _tween.animate(_controller!)
      ..addListener(() {
        setState(() {});
      });
    Future.delayed(const Duration(seconds: 3), () {
      _controller!.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d0f26),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SteppedProgressView(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
              ),
              value: _animation!.value,
              arcs: [
                AnimatedArc(
                  color: const Color(0xFFfad080),
                  strokeWidth: 10,
                  size: 200,
                ),
                AnimatedArc(
                  color: const Color(0xFF383a56),
                  startAngle: pi,
                  size: 180,
                  reverse: true,
                  strokeWidth: 2,
                ),
                AnimatedArc(
                  color: const Color(0xFF5d5f77),
                  strokeWidth: 6,
                  size: 130,
                ),
                AnimatedArc(
                  color: const Color(0xFFa4a4c4),
                  startAngle: 1,
                  strokeWidth: 7,
                  reverse: true,
                  size: 110,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

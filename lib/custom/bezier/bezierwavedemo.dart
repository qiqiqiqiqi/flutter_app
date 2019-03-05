import 'package:flutter/material.dart';
import 'bezierwave.dart';
main() {
  runApp(MaterialApp(
    title: "BezierWave Demo",
    home: Scaffold(
      appBar: AppBar(
        title: Text("BezierWave Demo"),
      ),
      body: BezierWaveDemo(),
    ),
  ));
}

class BezierWaveDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BezierWaveState();
  }
}

class BezierWaveState extends State<BezierWaveDemo> {
  Size size = Size(300, 300);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: size,
        painter: BezierWavePainter(),
      ),
    );
  }
}

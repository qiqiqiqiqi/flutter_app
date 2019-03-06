import 'package:flutter/material.dart';
import 'bezierwave.dart';
import 'dart:ui' as ui;

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
  double offset1 = 0, offset2 = 0;
  ui.Image image;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    var widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((Duration duration) {
      widgetsBinding.addPersistentFrameCallback((duration) {
        if (mounted) {
          setState(() {
            offset1 += 1;
            if (offset1 > size.width / 2) {
              offset1 -= size.width / 2; //一个波长的距离
            }
            progress = offset1 / (size.width / 2);
            offset2 += 2;
            if (offset2 > size.width / 2) {
              offset2 -= size.width / 2;
            }
          });
        }
        widgetsBinding.scheduleFrame();
      });
    });

    BezierWavePainter.getImage("images/boat.png").then((image2) {
      setState(() {
        image = image2;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: size,
        painter: BezierWavePainter(
            waveHeight: size.height / 2,
            wavePeak: 20,
            offSetX1: offset1,
            offSetX2: offset2,
            image: image,
            progress: progress),
      ),
    );
  }
}

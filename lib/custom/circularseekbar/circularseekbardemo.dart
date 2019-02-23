import 'package:flutter/material.dart';
import 'circularseekbar.dart';
import 'dart:math' as Math;

main() {
  runApp(MaterialApp(title: "seekbar demo", home: CircularSeekBarApp()));
}

class CircularSeekBarApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CircularSeekBarState();
  }
}

class CircularSeekBarState extends State<CircularSeekBarApp> {
  Size cirularSize;
  GlobalKey globalKey;
  double angle=135.0;

  @override
  void initState() {
    super.initState();
    cirularSize = Size(300.0, 300.0);
    globalKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("seekbar demo"),
      ),
      body: Center(
        child: GestureDetector(
          onPanStart: (DragStartDetails dragStartDetails) {},
          onPanDown: (DragDownDetails dragDownDetails) {
            setState(() {
              angle =
                  caculateRadianByTouchPoint(dragDownDetails.globalPosition);
            });
          },
          onPanUpdate: (DragUpdateDetails dragUpdateDetails) {
            setState(() {
              angle =
                  caculateRadianByTouchPoint(dragUpdateDetails.globalPosition);
            });
          },
          onPanCancel: () {},
          onPanEnd: (DragEndDetails dragEndDetails) {},
          child: CustomPaint(
            key: globalKey,
            size: cirularSize,
            painter: CircularSeekBar(angle),
          ),
        ),
      ),
    );
  }

  double caculateRadianByTouchPoint(Offset globalPosition) {
    RenderBox renderBox = globalKey.currentContext.findRenderObject();
    Offset globalToLocal = renderBox.globalToLocal(globalPosition);
    double tan = ((globalToLocal.dy - cirularSize.height / 2) /
        (globalToLocal.dx - cirularSize.width / 2)).abs();
    double radian = Math.atan(tan);
    double angle = radian / Math.pi * 180;
    if ((globalToLocal.dy - cirularSize.height / 2) < 0 &&
        (globalToLocal.dx - cirularSize.width / 2) > 0) {
      //第一象限
      angle = 225 - angle;
    } else if ((globalToLocal.dy - cirularSize.height / 2) < 0 &&
        (globalToLocal.dx - cirularSize.width / 2) < 0) {
      //第二象限
      angle = 45 + angle;
    } else if ((globalToLocal.dy - cirularSize.height / 2) >0 &&
        (globalToLocal.dx - cirularSize.width / 2) <0) {
      //第三象限
      angle = 45 - angle;
    } else if ((globalToLocal.dy - cirularSize.height / 2) > 0 &&
        (globalToLocal.dx - cirularSize.width / 2) > 0) {
      //第四象限
      angle = 225 + angle;
    }
    return angle;
  }
}

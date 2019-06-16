import 'package:flutter/material.dart';
import 'sleepseekbar.dart';
import 'dart:math';

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
  double startAngle = 0.0;
  double endAngle = 90.0;
  Point<double> offsetS;
  Point<double> offsetE;

  @override
  void initState() {
    super.initState();
    cirularSize = Size(240.0, 240.0);
    globalKey = GlobalKey();
    offsetS = Point(0.0, -cirularSize.height / 2);
    offsetE = Point(cirularSize.width / 2, 0.0);
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
              caculateRadianByTouchPoint(dragDownDetails.globalPosition);
            });
          },
          onPanUpdate: (DragUpdateDetails dragUpdateDetails) {
            print(
                "build():dragUpdateDetails.delta.dy=${dragUpdateDetails.delta.dy},"
                "dragUpdateDetails.delta.dx=${dragUpdateDetails.delta.dx},dragUpdateDetails.primaryDelta=${dragUpdateDetails.primaryDelta}");
            setState(() {
              caculateRadianByTouchPoint(dragUpdateDetails.globalPosition);
            });
          },
          onPanCancel: () {},
          onPanEnd: (DragEndDetails dragEndDetails) {},
          child: CustomPaint(
            key: globalKey,
            size: cirularSize,
            painter: CircularSeekBar(
                angleS: startAngle,
                angleE: endAngle,
                pointS: offsetS,
                pointE: offsetE),
          ),
        ),
      ),
    );
  }

  void caculateRadianByTouchPoint(Offset globalPosition) {
    RenderBox renderBox = globalKey.currentContext.findRenderObject();
    Offset globalToLocal = renderBox.globalToLocal(globalPosition);
    print(
        "caculateRadianByTouchPoint():globalPosition=$globalPosition,globalToLocal=$globalToLocal");
    double tan = ((globalToLocal.dy - cirularSize.height / 2) /
            (globalToLocal.dx - cirularSize.width / 2))
        .abs();
    double radian = atan(tan);
    double angle = radian / pi * 180;
    if ((globalToLocal.dy - cirularSize.height / 2) < 0 &&
        (globalToLocal.dx - cirularSize.width / 2) >= 0) {
      //第一象限
      angle = 90 - angle;
    } else if ((globalToLocal.dy - cirularSize.height / 2) < 0 &&
        (globalToLocal.dx - cirularSize.width / 2) < 0) {
      //第二象限
      angle = 270 + angle;
    } else if ((globalToLocal.dy - cirularSize.height / 2) > 0 &&
        (globalToLocal.dx - cirularSize.width / 2) < 0) {
      //第三象限
      angle = 270 - angle;
    } else if ((globalToLocal.dy - cirularSize.height / 2) > 0 &&
        (globalToLocal.dx - cirularSize.width / 2) > 0) {
      //第四象限
      angle = 90 + angle;
    }
    if ((pow(((globalToLocal.dx-cirularSize.width/2) - offsetS.x).abs(), 2) +
            pow(((globalToLocal.dy-cirularSize.height/2) - offsetS.y).abs(), 2)) >
        (pow(((globalToLocal.dx-cirularSize.width/2) - offsetE.x).abs(), 2) +
            pow(((globalToLocal.dy-cirularSize.height/2) - offsetE.y).abs(), 2))) {
      endAngle = angle;
      offsetE =
          calulatePointPosition(endAngle, cirularSize, cirularSize.width / 2);
    } else {
      startAngle = angle;
      offsetS =
          calulatePointPosition(startAngle, cirularSize, cirularSize.width / 2);
    }
    print(
        'caculateRadianByTouchPoint():startAngle=$startAngle,endAngle=$endAngle');
  }

  Point<double> calulatePointPosition(double angle, Size size, double raduis) {
    Point<double> point = Point(0, 0);
    if (angle >= 0 && angle < 90) {
      double sinValue = sin((90 - angle) / 180 * pi);
      double cosValue = cos((90 - angle) / 180 * pi);
      point = Point(raduis * cosValue, -raduis * sinValue);
    } else if (angle >= 90 && angle < 180) {
      double sinValue = sin((angle - 90) / 180 * pi);
      double cosValue = cos((angle - 90) / 180 * pi);
      point = Point(raduis * cosValue, raduis * sinValue);
    } else if (angle >= 180 && angle < 270) {
      double sinValue = sin((270 - angle) / 180 * pi);
      double cosValue = cos((270 - angle) / 180 * pi);
      point = Point(-raduis * cosValue, raduis * sinValue);
    } else if (angle >= 270 && angle <= 360) {
      double sinValue = sin((360 - angle) / 180 * pi);
      double cosValue = cos((360 - angle) / 180 * pi);
      point = Point(-raduis * sinValue, -raduis * cosValue);
    }
    return point;
  }
}

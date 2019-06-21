import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter_app/custom/sleep/timeseekbar/sleepseekbar.dart';


class SleepSeekBarPage extends StatefulWidget {
  final OnProgressChange onProgressChange;

  const SleepSeekBarPage({this.onProgressChange});

  @override
  State<StatefulWidget> createState() {
    return new CircularSeekBarState();
  }
}

class CircularSeekBarState extends State<SleepSeekBarPage> {
  Size cirularSize;
  GlobalKey globalKey;
  double startAngle = 345.0;
  double endAngle = 225.0;
  Point<double> pointS;
  Point<double> pointE;
  ui.Image sleepImage, nongzhongImage;

  @override
  void initState() {
    super.initState();
    cirularSize = Size(240.0, 240.0);
    globalKey = GlobalKey();
    pointS =
        calulatePointPosition(startAngle, cirularSize, cirularSize.width / 2);
    pointE =
        calulatePointPosition(endAngle, cirularSize, cirularSize.width / 2);
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      rangeChange();
      SleepSeekBar.getImage(
              asset:
                  'packages/hb_solution/images/datarecord/data_record_sleep.png')
          .then((image) {
        setState(() {
          sleepImage = image;
        });
      });
      SleepSeekBar.getImage(
              asset:
                  'packages/hb_solution/images/datarecord/data_record_naozhong.png')
          .then((image) {
        setState(() {
          nongzhongImage = image;
        });
      });
    });
  }

  void rangeChange() {
    double startAngleRadian = startAngle * pi / 180;
    double endAngleRadian = endAngle * pi / 180;
    double dtRadian = endAngleRadian - startAngleRadian >= 0
        ? endAngleRadian - startAngleRadian
        : 2 * pi - (startAngleRadian - endAngleRadian);
    widget.onProgressChange?.call(
        (startAngleRadian / (2 * pi) * 12 * 60).toInt(),
        (endAngleRadian / (2 * pi) * 12 * 60).toInt(),
        (dtRadian / (2 * pi) * 12 * 60).toInt());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        alignment: Alignment.center,
        child: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          dragStartBehavior: DragStartBehavior.down,
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
            painter: SleepSeekBar(
              angleS: startAngle,
              angleE: endAngle,
              pointS: pointS,
              pointE: pointE,
              sleepImage: sleepImage,
              nongzhongImage: nongzhongImage,
            ),
          ),
        ),
      );
    });
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
    if ((pow(((globalToLocal.dx - cirularSize.width / 2) - pointS.x).abs(), 2) +
            pow(((globalToLocal.dy - cirularSize.height / 2) - pointS.y).abs(),
                2)) >
        (pow(((globalToLocal.dx - cirularSize.width / 2) - pointE.x).abs(), 2) +
            pow(((globalToLocal.dy - cirularSize.height / 2) - pointE.y).abs(),
                2))) {
      endAngle = angle;
      pointE =
          calulatePointPosition(endAngle, cirularSize, cirularSize.width / 2);
    } else {
      startAngle = angle;
      pointS =
          calulatePointPosition(startAngle, cirularSize, cirularSize.width / 2);
    }
//    if ((angle - startAngle).abs() < (angle - endAngle).abs()) {
//      endAngle = angle;
//      pointE =
//          calulatePointPosition(endAngle, cirularSize, cirularSize.width / 2);
//    } else {
//      startAngle = angle;
//      pointS =
//          calulatePointPosition(startAngle, cirularSize, cirularSize.width / 2);
//    }

    rangeChange();
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

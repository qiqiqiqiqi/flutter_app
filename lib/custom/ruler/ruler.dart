import 'package:flutter/material.dart';
import 'ruler_painter.dart';
import 'dart:math' as Math;

class Ruler extends StatefulWidget {
  double width;
  double height;

  Ruler({this.width, this.height});

  @override
  State<StatefulWidget> createState() {
    return RulerState();
  }
}

class RulerState extends State<Ruler> with TickerProviderStateMixin {
  Offset velocity;
  AnimationController _animationController;
  double translationX = 0.0;
  int minValue = 30;
  int middleValue;
  int maxValue = 200;
  double unitScale = 0.5;
  double unitScaleLength;
  int scaleNum;
  double sumLength;
  double emptyLenth;
  int showScaleNum = 9;
  double offsetX = 0.0;

  int currentScale;
  double maxOffsetX;

  @override
  void initState() {
    super.initState();

    scaleNum = (maxValue - minValue) ~/ unitScale;
    if (middleValue == null) {
      middleValue = (minValue + maxValue) ~/ 2;
    }
    unitScaleLength = (widget.width / (showScaleNum - 1));
    emptyLenth = widget.width / 2;
    sumLength = unitScaleLength * ((maxValue - minValue) / unitScale) +
        (showScaleNum - 1) * unitScaleLength; //另外加上一屏的空白宽度使两端能滑到中点
    offsetX = translationX +
        emptyLenth -
        (middleValue - minValue) * unitScaleLength * 2;
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    maxOffsetX =
        -(unitScaleLength * ((maxValue - minValue) / unitScale) - emptyLenth);
    currentScale = (middleValue - minValue) ~/ unitScale;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.redAccent,
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
//          double maxOffsetX =
//              -(unitScaleLength * ((maxValue - minValue) / unitScale) -
//                  emptyLenth);
          translationX += details.delta.dx;
          offsetX = translationX +
              emptyLenth -
              (middleValue - minValue) * unitScaleLength * 2;
          if (offsetX > emptyLenth) {
            translationX -= details.delta.dx;
            offsetX = emptyLenth;
          } else if (offsetX < maxOffsetX) {
            offsetX = maxOffsetX;
            translationX -= details.delta.dx;
          }
          offsetX = translationX +
              emptyLenth -
              (middleValue - minValue) * unitScaleLength * 2;
          setState(() {});

          print(
              'RulerState--build()--onPanUpdate():offsetX=$offsetX,translationX=$translationX,details.delta=${details.delta}');
        },
        onPanEnd: (DragEndDetails details) {
          velocity = details.velocity.pixelsPerSecond;
          if (velocity.dx.abs() > 0 &&
              offsetX >
                  -(unitScaleLength * ((maxValue - minValue) / unitScale) -
                      emptyLenth) &&
              offsetX < emptyLenth) {
            //fling
            double velocityX = velocity.dx / 2;
            double preFrameTime = 0.0;
            Tween<double> tween = Tween(begin: 0, end: 1);
            _animationController.duration = Duration(seconds: 1);
            Animation animate = tween.animate(_animationController);
            animate.addListener(() {
              setState(() {
                // velocity.dx > 0.0 ? emptyLenth : maxOffsetX
                translationX += velocityX * (animate.value - preFrameTime) -
                    0.5 * 9.8 * Math.pow((animate.value - preFrameTime), 2);
                offsetX = translationX +
                    emptyLenth -
                    (middleValue - minValue) * unitScaleLength * 2;
                if (offsetX > emptyLenth) {
//                  _animationController.stop(canceled: true);
//                  offsetX = emptyLenth;
                  translationX -= velocityX * (animate.value - preFrameTime) -
                      0.5 * 9.8 * Math.pow((animate.value - preFrameTime), 2);
                } else if (offsetX < maxOffsetX) {
//                  _animationController.stop(canceled: true);
//                  offsetX = maxOffsetX;
                  translationX -= velocityX * (animate.value - preFrameTime) -
                      0.5 * 9.8 * Math.pow((animate.value - preFrameTime), 2);
                }
                offsetX = translationX +
                    emptyLenth -
                    (middleValue - minValue) * unitScaleLength * 2;
                if (velocity.dx > 0) {
                  velocityX = velocity.dx - 9.8 * animate.value;
                } else {
                  velocityX = velocity.dx + 9.8 * animate.value;
                }
                preFrameTime = animate.value;
              });
            });
            _animationController.forward(from: 0.0);

            print('RulerState--build()--onPanEnd():offsetX=$offsetX');
          } else if (velocity.dx == 0) {
            //自动居中
            smoothToCenter();
          }
          // smoothToCenter();
        },
        child: CustomPaint(
          size: Size(widget.width, 80),
          painter: RulerPainter(
              currentSacle: currentScale,
              unitScale: 0.5,
              minValue: minValue,
              maxValue: maxValue,
              unitScaleLength: unitScaleLength,
              offsetX: offsetX,
              scaleNum: scaleNum),
        ),
      ),
    );
  }

  void smoothToCenter() {
    int leftScale =
        ((middleValue - minValue) * 2 - translationX ~/ unitScaleLength) > 0
            ? ((middleValue - minValue) * 2 - translationX ~/ unitScaleLength)
            : 0;
    if (translationX > 0) {
      leftScale = leftScale - 1;
    }
    double leftScalePositionLeft = emptyLenth +
        (translationX < 0
            ? -(translationX.abs() % unitScaleLength)
            : translationX.abs() % unitScaleLength - unitScaleLength);
    double rightScalePositionLeft = leftScalePositionLeft + unitScaleLength;
    if ((leftScalePositionLeft - emptyLenth).abs() >
        (rightScalePositionLeft - emptyLenth).abs()) {
      currentScale = leftScale + 1;
      Tween<double> tween = Tween(
          begin: offsetX, end: offsetX - (rightScalePositionLeft - emptyLenth));
      Animation animate = tween.animate(_animationController);
      _animationController.duration = Duration(milliseconds: 200);
      animate.addListener(() {
        setState(() {
          offsetX = animate.value;
        });
      });
      animate.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {}
      });
      _animationController.forward(from: 0.0);
    } else {
      currentScale = leftScale;
      Tween<double> tween = Tween(
          begin: offsetX, end: offsetX + (emptyLenth - leftScalePositionLeft));
      Animation animate = tween.animate(_animationController);
      _animationController.duration = Duration(milliseconds: 200);
      animate.addListener(() {
        setState(() {
          offsetX = animate.value;
        });
      });
      _animationController.forward(from: 0.0);
    }

    _animationController.forward(from: 0);
//    print(
//        'leftScale=$leftScale,currentScale=$currentScale,leftScalePositionLeft=$leftScalePositionLeft,translationX=$translationX');
  }
}

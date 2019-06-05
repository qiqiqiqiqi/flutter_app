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
  int minValue = 0;
  int middleValue;
  int maxValue = 20;
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
        onHorizontalDragUpdate: (DragUpdateDetails details) {
//          double maxOffsetX =
//              -(unitScaleLength * ((maxValue - minValue) / unitScale) -
//                  emptyLenth);

          setState(() {
            translationX += details.delta.dx;
            double currentOffsetX = translationX +
                emptyLenth -
                (middleValue - minValue) * unitScaleLength * 2;
            if (currentOffsetX > emptyLenth) {
              currentOffsetX = emptyLenth;
              translationX = (middleValue - minValue) * unitScaleLength * 2;
            } else if (currentOffsetX < maxOffsetX) {
              currentOffsetX = maxOffsetX;
              translationX = maxOffsetX -
                  emptyLenth +
                  (middleValue - minValue) * unitScaleLength * 2;
            }
            offsetX = currentOffsetX;
          });

//          print(
//              'RulerState--build()--onPanUpdate():offsetX=$offsetX,translationX=$translationX,details.delta=${details.delta}');
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          velocity = details.velocity.pixelsPerSecond;
          if (velocity.dx.abs() > 0 &&
              offsetX >
                  -(unitScaleLength * ((maxValue - minValue) / unitScale) -
                      emptyLenth) &&
              offsetX < emptyLenth) {
            //fling
            double translationX0 = translationX;
            double a = 1.0;
            double v0 = velocity.dx;
            int period = (v0 / a).abs().toInt();
            Tween<double> tween = Tween(begin: 0, end: period.toDouble());
            _animationController.duration = Duration(milliseconds: period);
            Animation animate = tween.animate(_animationController);
            animate.addListener(() {
              print(
                  'RulerState--build()--onPanEnd():offsetX=$offsetX,velocity=$velocity,period=$period,animate.value=${animate.value}');
              double currentTranslationX = translationX0;
              double t=animate.value/1000;
              if (velocity.dx < 0) {
                //向右滑动
                currentTranslationX +=
                    v0 * t + 0.5 * a * Math.pow(t, 2);
              } else {
                currentTranslationX +=
                    v0 * t - 0.5 * a * Math.pow(t, 2);
              }

              double currentOffsetX = currentTranslationX +
                  emptyLenth -
                  (middleValue - minValue) * unitScaleLength * 2;
              if (currentOffsetX > emptyLenth) {
                currentOffsetX = emptyLenth;
                currentTranslationX =
                    (middleValue - minValue) * unitScaleLength * 2;
              } else if (currentOffsetX < maxOffsetX) {
                currentOffsetX = maxOffsetX;
                currentTranslationX = maxOffsetX -
                    emptyLenth +
                    (middleValue - minValue) * unitScaleLength * 2;
              }
              setState(() {
                offsetX = currentOffsetX;
                translationX = currentTranslationX;
              });
            });
            _animationController.forward(from: 0);

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
          translationX = offsetX -
              (emptyLenth - (middleValue - minValue) * unitScaleLength * 2);
        });
      });
      animate.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          translationX = offsetX -
              (emptyLenth - (middleValue - minValue) * unitScaleLength * 2);
        }
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
          translationX = offsetX -
              (emptyLenth - (middleValue - minValue) * unitScaleLength * 2);
        });
      });
      animate.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          translationX = offsetX -
              (emptyLenth - (middleValue - minValue) * unitScaleLength * 2);
        }
      });
      _animationController.forward(from: 0.0);
    }
    _animationController.forward(from: 0);
//    print(
//        'leftScale=$leftScale,currentScale=$currentScale,leftScalePositionLeft=$leftScalePositionLeft,translationX=$translationX');
  }
}

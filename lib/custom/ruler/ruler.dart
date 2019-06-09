import 'package:flutter/material.dart';
import 'ruler_painter.dart';
import 'dart:math' as Math;

typedef OnSelectedValue = void Function(BuildContext context,double value);

class Ruler extends StatefulWidget {
  double width;
  double height;
  OnSelectedValue onSelectedValue;

  Ruler({this.width, this.height, this.onSelectedValue});

  @override
  State<StatefulWidget> createState() {
    return RulerState();
  }
}

class RulerState extends State<Ruler> with TickerProviderStateMixin {
  Offset velocity;
  AnimationController _animationControllerSmooth;
  AnimationController _animationControllerFling;
  num translationX = 0.0;
  int minValue = 30;
  int middleValue;
  int maxValue = 1000;
  double unitScale = 0.5;
  int unitScaleLength = 0;
  int scaleNum = 0;
  double sumLength;
  double emptyLenth;
  int showScaleNum = 9;
  double offsetX = 0.0;

  int currentScale = 0;
  double maxOffsetX;
  Tween<double> tweenSmooth;
  Tween<double> tweenFling;
  double v0 = 0.0;
  double translationX0 = 0.0;
  double a = 1.0;
  GlobalKey globalKey;

  @override
  void initState() {
    super.initState();
    globalKey = GlobalKey();
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      setState(() {
        widget.width = globalKey.currentContext.size.width;
        unitScaleLength = (widget.width ~/ (showScaleNum - 1));
        emptyLenth = widget.width / 2;
        sumLength = unitScaleLength * ((maxValue - minValue) / unitScale) +
            (showScaleNum - 1) * unitScaleLength; //另外加上一屏的空白宽度使两端能滑到中点
        offsetX = translationX +
            emptyLenth -
            (middleValue - minValue) * unitScaleLength * 2;

        maxOffsetX = -(unitScaleLength * ((maxValue - minValue) / unitScale) -
            emptyLenth);
        currentScale = (middleValue - minValue) ~/ unitScale;
      });
    });
    scaleNum = (maxValue - minValue) ~/ unitScale;
    if (middleValue == null) {
      middleValue = (minValue + maxValue) ~/ 2;
    }

    //平滑
    _animationControllerSmooth =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    tweenSmooth = Tween();
    Animation animateSmooth = tweenSmooth.animate(_animationControllerSmooth);
    _animationControllerSmooth.duration = Duration(milliseconds: 200);
    animateSmooth.addListener(() {
      setState(() {
        offsetX = animateSmooth.value;
        translationX = offsetX -
            (emptyLenth - (middleValue - minValue) * unitScaleLength * 2);
      });
    });
    animateSmooth.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          translationX = offsetX -
              (emptyLenth - (middleValue - minValue) * unitScaleLength * 2);
        });
        widget.onSelectedValue?.call(context,currentScale * unitScale + minValue);
      }
    });
    //fling滑
    _animationControllerFling =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    Animation curve = CurvedAnimation(
        parent: _animationControllerFling, curve: Curves.easeOutExpo);
    tweenFling = Tween();
    Animation animateFling = tweenFling.animate(curve);
    animateFling.addListener(() {
      double currentOffsetX = animateFling.value;
      double currentTranslationX = currentOffsetX -
          (emptyLenth - (middleValue - minValue) * unitScaleLength * 2);
      if (currentOffsetX > emptyLenth) {
        currentOffsetX = emptyLenth;
        currentTranslationX =
            ((middleValue - minValue) * unitScaleLength * 2).toDouble();
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
    animateFling.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        smoothToTargetScale();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
          color: Colors.blueAccent,
        child: GestureDetector(
          onHorizontalDragStart: (DragStartDetails details) {
            if (_animationControllerFling.isAnimating) {
              _animationControllerFling.stop();
            }
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
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
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            velocity = details.velocity.pixelsPerSecond;
            if (velocity.dx.abs() > 0 &&
                offsetX >
                    -(unitScaleLength * ((maxValue - minValue) / unitScale) -
                        emptyLenth) &&
                offsetX < emptyLenth) {
              //fling
              translationX0 = translationX;
              v0 = velocity.dx;
              double period = (v0 / a).abs(); //以毫秒为单位
              double targetScaleDistance =
                  find2TargetScaleDistanceByVelocity(v0, period / 1000, a);
              tweenFling.begin = offsetX;
              tweenFling.end = targetScaleDistance;
              print("distance=${targetScaleDistance - offsetX}");
              _animationControllerFling.duration = Duration(
                  milliseconds: (targetScaleDistance - offsetX).abs().toInt()~/2);

              _animationControllerFling.forward(from: 0);
            } else if (velocity.dx == 0) {
              //自动居中
              smoothToTargetScale();
            }
            // smoothToCenter();
          },
          child: CustomPaint(
            key: globalKey,
            size: Size(constraints.maxWidth - 96, 80),
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
    });
  }

  double find2TargetScaleDistanceByVelocity(double v0, double t, double a) {
    double sourceTranslationX = translationX;
    if (velocity.dx < 0) {
      //向右滑动
      sourceTranslationX += v0 * t + 0.5 * a * Math.pow(t, 2);
    } else {
      sourceTranslationX += v0 * t - 0.5 * a * Math.pow(t, 2);
    }
    double sourceOffsetX = sourceTranslationX +
        emptyLenth -
        (middleValue - minValue) * unitScaleLength * 2;
    if (sourceOffsetX > emptyLenth) {
      sourceOffsetX = emptyLenth;
      sourceTranslationX =
          ((middleValue - minValue) * unitScaleLength * 2).toDouble();
    } else if (sourceOffsetX < maxOffsetX) {
      sourceOffsetX = maxOffsetX;
      sourceTranslationX = maxOffsetX -
          emptyLenth +
          (middleValue - minValue) * unitScaleLength * 2;
    }

    return findTargetOffsetX(sourceTranslationX, sourceOffsetX,
        refreshCurrentScale: false);
    //return sourceTranslationX;
  }

  void smoothToTargetScale() {
    startAnima(offsetX,
        findTargetOffsetX(translationX, offsetX, refreshCurrentScale: true));
  }

  double findTargetOffsetX(double translationX, double offsetX,
      {bool refreshCurrentScale = false}) {
    //translationX 除以 unitScaleLength 如果结果(68.999999999999)很接近一个整数，
    // 那么 ~/和/操作符的结果都是整数(69)
    int leftScale =
        ((middleValue - minValue) * 2 - translationX ~/ unitScaleLength) > 0
            ? ((middleValue - minValue) * 2 - translationX ~/ unitScaleLength)
            : 0;
    if (translationX >= 0 && leftScale > 0) {
      if ((translationX % unitScaleLength).abs() > 0) {
        leftScale = leftScale - 1;
      }
    }
    double leftScalePositionLeft = emptyLenth +
        (translationX < 0
            ? -(translationX.abs() % unitScaleLength)
            : translationX.abs() % unitScaleLength == 0
                ? 0
                : (translationX.abs() % unitScaleLength - unitScaleLength));
    double end = offsetX;
    if (((leftScalePositionLeft - emptyLenth).abs() >
        ((leftScalePositionLeft + unitScaleLength) - emptyLenth).abs())) {
      if (refreshCurrentScale) {
        currentScale = leftScale + 1;
      }
      end = offsetX - ((leftScalePositionLeft + unitScaleLength) - emptyLenth);
    } else {
      if (refreshCurrentScale) {
        currentScale = leftScale;
      }
      end = offsetX + (emptyLenth - leftScalePositionLeft);
    }
    return end;
  }

  void startAnima(double start, double end) {
    // Tween<double> tween = Tween(begin: start, end: end);
    tweenSmooth.begin = start;
    tweenSmooth.end = end;

    _animationControllerSmooth.forward(from: 0);
  }
}

import 'package:flutter/material.dart';
import 'ruler_text_painter.dart';
import 'dart:math' as Math;

typedef OnSelectedValue = void Function(BuildContext context, double value);

class RulerText extends StatefulWidget {
  double width;
  double height;
  int minValue;
  int middleValue;
  int maxValue;
  String unit;
  OnSelectedValue onSelectedValue;

  RulerText(
      {this.width,
      this.height,
      @required this.minValue,
      @required this.maxValue,
      this.middleValue,
      this.onSelectedValue,
      this.unit = 'kg'}) {
    if (middleValue == null) {
      middleValue = (minValue + maxValue) ~/ 2;
    }
  }

  @override
  State<StatefulWidget> createState() {
    return RulerTextState();
  }
}

class RulerTextState extends State<RulerText> with TickerProviderStateMixin {
  Offset velocity;
  AnimationController _animationControllerSmooth;
  AnimationController _animationControllerFling;
  num translationX = 0.0;

  double unitScale = 1;
  int unitScaleLength = 0;
  int scaleNum = 0;
  int sumLength;
  double emptyLenth = 0;
  int showScaleNum = 7;
  double offsetX = 0.0;

  int currentScale = 0;
  double maxOffsetX;
  Tween<double> tweenSmooth;
  Tween<double> tweenFling;
  double v0 = 0.0;
  double translationX0 = 0.0;
  double a = 1.0;
  GlobalKey globalKey;
  List<String> contents;

  @override
  void initState() {
    super.initState();
    globalKey = GlobalKey();
    contents=['克','颗','只','枚','碗','只','枚',];
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      setState(() {
        widget.width = globalKey.currentContext.size.width;
        unitScaleLength = (widget.width ~/ (showScaleNum - 1));
        emptyLenth = widget.width / 2;
        sumLength = unitScaleLength *
                ((widget.maxValue - widget.minValue) ~/ unitScale) +
            (showScaleNum - 1) * unitScaleLength; //另外加上一屏的空白宽度使两端能滑到中点
        currentScale = (widget.middleValue - widget.minValue) ~/ unitScale;
        offsetX = translationX +
            emptyLenth -
            (widget.middleValue - widget.minValue) *
                unitScaleLength /
                unitScale;

        maxOffsetX = -(unitScaleLength *
                ((widget.maxValue - widget.minValue) ~/ unitScale) -
            emptyLenth);
      });
    });
    if (widget.middleValue == null) {
      widget.middleValue = (widget.minValue + widget.maxValue) ~/ 2;
    }
    widget.onSelectedValue?.call(context, widget.middleValue.toDouble());
    scaleNum = (widget.maxValue - widget.minValue) ~/ unitScale;
    //smooth
    _animationControllerSmooth =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    tweenSmooth = Tween();
    Animation animateSmooth = tweenSmooth.animate(_animationControllerSmooth);
    _animationControllerSmooth.duration = Duration(milliseconds: 200);
    animateSmooth.addListener(() {
      setState(() {
        offsetX = animateSmooth.value;
        translationX = offsetX -
            (emptyLenth -
                (widget.middleValue - widget.minValue) *
                    unitScaleLength ~/
                    unitScale);
      });
    });
    animateSmooth.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          translationX = offsetX -
              (emptyLenth -
                  (widget.middleValue - widget.minValue) *
                      unitScaleLength ~/
                      unitScale);
        });
        widget.onSelectedValue?.call(context,
            currentScale.toDouble() * unitScale + widget.minValue.toDouble());
      }
    });
    //fling
    _animationControllerFling = AnimationController(vsync: this);
    Animation curve = CurvedAnimation(
        parent: _animationControllerFling, curve: Curves.easeOutExpo);
    tweenFling = Tween();
    Animation animateFling = tweenFling.animate(curve);
    animateFling.addListener(() {
      double currentOffsetX = animateFling.value;
      double currentTranslationX = currentOffsetX -
          (emptyLenth -
              (widget.middleValue - widget.minValue) *
                  unitScaleLength ~/
                  unitScale);
      if (currentOffsetX > emptyLenth) {
        currentOffsetX = emptyLenth;
        currentTranslationX = ((widget.middleValue - widget.minValue) *
                unitScaleLength ~/
                unitScale)
            .toDouble();
      } else if (currentOffsetX < maxOffsetX) {
        currentOffsetX = maxOffsetX;
        currentTranslationX = maxOffsetX -
            emptyLenth +
            (widget.middleValue - widget.minValue) *
                unitScaleLength ~/
                unitScale;
      }
      setState(() {
        offsetX = currentOffsetX;
        translationX = currentTranslationX;

        //todo 未复用
        int leftScale = ((widget.middleValue - widget.minValue) ~/ unitScale -
                    translationX ~/ unitScaleLength) >
                0
            ? ((widget.middleValue - widget.minValue) ~/ unitScale -
                translationX ~/ unitScaleLength)
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
        if (((leftScalePositionLeft - emptyLenth).abs() >
            ((leftScalePositionLeft + unitScaleLength) - emptyLenth).abs())) {
          currentScale = leftScale + 1;
        } else {
          currentScale = leftScale;
        }
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
//        padding: EdgeInsets.symmetric(horizontal: 48),
        // color: Colors.blueAccent,
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
                  (widget.middleValue - widget.minValue) *
                      unitScaleLength ~/
                      unitScale;
              if (currentOffsetX > emptyLenth) {
                currentOffsetX = emptyLenth;
                translationX = (widget.middleValue - widget.minValue) *
                    unitScaleLength ~/
                    unitScale;
              } else if (currentOffsetX < maxOffsetX) {
                currentOffsetX = maxOffsetX;
                translationX = maxOffsetX -
                    emptyLenth +
                    (widget.middleValue - widget.minValue) *
                        unitScaleLength ~/
                        unitScale;
              }
              offsetX = currentOffsetX;
              findTargetOffsetX(translationX, offsetX,
                  refreshCurrentScale: true);
            });
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            velocity = details.velocity.pixelsPerSecond;
            setState(() {
              if (velocity.dx.abs() > 0 &&
                  offsetX >
                      -(unitScaleLength *
                              ((widget.maxValue - widget.minValue) /
                                  unitScale) -
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
                //  print("distance=${targetScaleDistance - offsetX}");
                _animationControllerFling.duration = Duration(
                    milliseconds:
                        (targetScaleDistance - offsetX).abs().toInt());

                _animationControllerFling.forward(from: 0);
              } else if (velocity.dx == 0) {
                //自动居中
                smoothToTargetScale();
              }
            });
          },
          child: CustomPaint(
            key: globalKey,
            size: Size(constraints.maxWidth, 80),
            painter: RulerTextPainter(
                currentSacle: currentScale,
                unitScale: unitScale,
                minValue: widget.minValue,
                maxValue: widget.maxValue,
                middleValue: widget.middleValue,
                unitScaleLength: unitScaleLength,
                emptyLenth: emptyLenth,
                offsetX: offsetX,
                scaleNum: scaleNum,
                unit: widget.unit,contents: contents),
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
        (widget.middleValue - widget.minValue) * unitScaleLength ~/ unitScale;
    if (sourceOffsetX > emptyLenth) {
      sourceOffsetX = emptyLenth;
      sourceTranslationX = ((widget.middleValue - widget.minValue) *
              unitScaleLength ~/
              unitScale)
          .toDouble();
    } else if (sourceOffsetX < maxOffsetX) {
      sourceOffsetX = maxOffsetX;
      sourceTranslationX = maxOffsetX -
          emptyLenth +
          (widget.middleValue - widget.minValue) * unitScaleLength ~/ unitScale;
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
    int leftScale = ((widget.middleValue - widget.minValue) ~/ unitScale -
                translationX ~/ unitScaleLength) >
            0
        ? ((widget.middleValue - widget.minValue) ~/ unitScale -
            translationX ~/ unitScaleLength)
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
    tweenSmooth.begin = start;
    tweenSmooth.end = end;
    _animationControllerSmooth.forward(from: 0);
  }
}

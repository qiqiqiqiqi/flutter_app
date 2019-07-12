import 'package:flutter/material.dart';
import 'ruler_painter.dart';
import 'dart:math' as Math;

typedef OnSelectedValue = void Function(BuildContext context, double value);

class Ruler extends StatefulWidget {
  double width;
  double height;
  int minValue;
  double middleValue;
  int maxValue;
  String unit;
  OnSelectedValue onSelectedValue;
  bool showHL = true;
  double unitScale = 1;
  int showScaleNum = 9;

  double minScaleLength = 4.0;
  double middleScaleLength = 8.0;
  double maxScaleLength = 12.0;
  double cursorScaleLength = 25.0;

  Ruler(
      {Key key,
      this.width,
      this.height,
      @required this.minValue,
      @required this.maxValue,
      this.middleValue,
      this.onSelectedValue,
      this.unit = 'kg',
      this.showHL = true,
      this.unitScale = 1,
      this.showScaleNum = 9,
      this.minScaleLength = 4.0,
      this.middleScaleLength = 8.0,
      this.maxScaleLength = 12.0,
      this.cursorScaleLength = 25.0})
      : super(key: key) {
    print('Ruler():middleValue=$middleValue');
    if (middleValue == null) {
      if (unitScale - unitScale.toInt() == 0) {
        middleValue = ((minValue + maxValue) ~/ 2).toDouble();
      } else {
        middleValue = (minValue + maxValue) / 2;
      }
    } else {
      if (middleValue < minValue) {
        middleValue = minValue.toDouble();
      } else if (middleValue > maxValue) {
        middleValue = maxValue.toDouble();
      }
    }
  }

  @override
  State<StatefulWidget> createState() {
    return RulerState();
  }
}

class RulerState extends State<Ruler> with TickerProviderStateMixin {
  Offset velocity;
  AnimationController _animationControllerSmooth;
  AnimationController _animationControllerFling;
  double translationX = 0.0;
  double middleValue;
  int unitScaleLength = 10;
  int scaleNum = 0;
  int sumLength;
  double emptyLenth = 0;
  double offsetX = 0.0;
  int currentScale = 0;
  double maxOffsetX;

  Tween<double> tweenSmooth;
  Tween<double> tweenFling;
  double v0 = 0.0;
  double a = 1.0;
  GlobalKey globalKey;
  bool touch = false;

  @override
  void initState() {
    super.initState();
    globalKey = GlobalKey();
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      setState(() {
        widget.width = globalKey.currentContext.size.width;

        unitScaleLength = (widget.width ~/ (widget.showScaleNum - 1));
        emptyLenth = widget.width / 2;
        sumLength = unitScaleLength *
                ((widget.maxValue * 10 - widget.minValue * 10) ~/
                    (widget.unitScale * 10)) +
            (widget.showScaleNum - 1) * unitScaleLength; //另外加上一屏的空白宽度使两端能滑到中点
        currentScale = (middleValue * 10 - widget.minValue * 10) ~/
            (widget.unitScale * 10);
        offsetX = translationX +
            emptyLenth -
            (middleValue * 10 - widget.minValue * 10) *
                unitScaleLength /
                (widget.unitScale * 10);

        maxOffsetX = -(unitScaleLength *
                ((widget.maxValue - widget.minValue) ~/ widget.unitScale) -
            emptyLenth);
        widget.onSelectedValue?.call(context, middleValue.toDouble());
      });

    });
    scaleNum = (widget.maxValue - widget.minValue) ~/ widget.unitScale;
    middleValue = widget.middleValue;
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
                (middleValue * 10 - widget.minValue * 10) *
                    unitScaleLength ~/
                    (widget.unitScale * 10));
      });
    });
    animateSmooth.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        print('animateSmooth--completed');

        setState(() {
          translationX = offsetX -
              (emptyLenth -
                  (middleValue * 10 - widget.minValue * 10) *
                      unitScaleLength ~/
                      (widget.unitScale * 10));
        });
        onSelectedValue();
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
              (middleValue * 10 - widget.minValue * 10) *
                  unitScaleLength ~/
                  (widget.unitScale * 10));
      if (currentOffsetX > emptyLenth) {
        currentOffsetX = emptyLenth;
        currentTranslationX = ((middleValue * 10 - widget.minValue * 10) *
                unitScaleLength ~/
                (widget.unitScale * 10))
            .toDouble();
      } else if (currentOffsetX < maxOffsetX) {
        currentOffsetX = maxOffsetX;
        currentTranslationX = maxOffsetX -
            emptyLenth +
            (middleValue * 10 - widget.minValue * 10) *
                unitScaleLength ~/
                (widget.unitScale * 10);
      }
      setState(() {
        offsetX = currentOffsetX;
        translationX = currentTranslationX;

        //todo 未复用
        int leftScale = ((middleValue * 10 - widget.minValue * 10) ~/
                        (widget.unitScale * 10) -
                    translationX ~/ unitScaleLength) >
                0
            ? ((middleValue * 10 - widget.minValue * 10) ~/
                    (widget.unitScale * 10) -
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
        onSelectedValue();
      });
    });
    animateFling.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        smoothToTargetScale();
        print('animateFling--completed');
      }
    });
  }

  void onSelectedValue() {
    widget.onSelectedValue?.call(
        context,
        (currentScale * widget.unitScale * 10).toInt() / 10 +
            widget.minValue.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    if (!touch && widget.middleValue != middleValue) {
      //滑动过程中不能去修改middleValue
      //如果外层重新设置了默认值，重新计算默认值
      translationX = 0;

      currentScale = (widget.middleValue * 10 - widget.minValue * 10) ~/
          (widget.unitScale * 10);
      offsetX = translationX +
          emptyLenth -
          (widget.middleValue * 10 - widget.minValue * 10) *
              unitScaleLength /
              (widget.unitScale * 10);
      print(
          "Ruler():build()：widget.middleValue=${widget.middleValue},middleValue=$middleValue");
      middleValue = widget.middleValue;
    }
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        child: GestureDetector(
          onHorizontalDragStart: (DragStartDetails details) {
            touch = true;
            if (_animationControllerFling.isAnimating) {
              _animationControllerFling.stop();
            }
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            touch = true;
            setState(() {
              translationX += details.delta.dx;
              double currentOffsetX = translationX +
                  emptyLenth -
                  (middleValue * 10 - widget.minValue * 10) *
                      unitScaleLength ~/
                      (widget.unitScale * 10);
              if (currentOffsetX > emptyLenth) {
                currentOffsetX = emptyLenth;
                translationX = (middleValue * 10 - widget.minValue * 10) *
                    unitScaleLength /
                    (widget.unitScale * 10);
              } else if (currentOffsetX < maxOffsetX) {
                currentOffsetX = maxOffsetX;
                translationX = maxOffsetX -
                    emptyLenth +
                    (middleValue * 10 - widget.minValue * 10) *
                        unitScaleLength ~/
                        (widget.unitScale * 10);
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
                                  widget.unitScale) -
                          emptyLenth) &&
                  offsetX < emptyLenth) {
                //fling

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
            painter: RulerPainter(
                currentSacle: currentScale,
                unitScale: widget.unitScale,
                minValue: widget.minValue,
                maxValue: widget.maxValue,
                middleValue: middleValue,
                unitScaleLength: unitScaleLength,
                emptyLenth: emptyLenth,
                offsetX: offsetX,
                scaleNum: scaleNum,
                unit: widget.unit,
                showHL: widget.showHL,
                maxScaleLength: widget.maxScaleLength,
                middleScaleLength: widget.middleScaleLength,
                minScaleLength: widget.minScaleLength,
                cursorScaleLength: widget.cursorScaleLength,
                showScaleNum: widget.showScaleNum),
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
        (middleValue * 10 - widget.minValue * 10) *
            unitScaleLength ~/
            (widget.unitScale * 10);
    if (sourceOffsetX > emptyLenth) {
      sourceOffsetX = emptyLenth;
      sourceTranslationX = ((middleValue * 10 - widget.minValue * 10) *
              unitScaleLength ~/
              (widget.unitScale * 10))
          .toDouble();
    } else if (sourceOffsetX < maxOffsetX) {
      sourceOffsetX = maxOffsetX;
      sourceTranslationX = maxOffsetX -
          emptyLenth +
          (middleValue * 10 - widget.minValue * 10) *
              unitScaleLength ~/
              (widget.unitScale * 10);
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
        ((middleValue* 10  - widget.minValue* 10 ) ~/ (widget.unitScale * 10) -
                    translationX ~/ unitScaleLength) >
                0
            ? ((middleValue* 10 - widget.minValue* 10)  ~/ (widget.unitScale * 10) -
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

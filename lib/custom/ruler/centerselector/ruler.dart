import 'package:flutter/material.dart';
import 'ruler_painter.dart';
import 'dart:math' as Math;

typedef OnSelectedValue = void Function(BuildContext context, double value);

class Ruler extends StatefulWidget {
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
  int scaleNum;

  Ruler(
      {Key key,
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
    scaleNum = (maxValue - minValue) ~/ unitScale;
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
  double width = 0.0;
  double translationX = 0.0;

  //************会引起视图改变的一些配置*****************
  int minValue;
  double middleValue;
  int maxValue;
  double unitScale = 1;
  int showScaleNum = 9;

  //*****************************
  int unitScaleLength = 10;
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

  @override
  void initState() {
    super.initState();
    globalKey = GlobalKey();
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      setState(() {
        init();
        widget.onSelectedValue?.call(context, middleValue.toDouble());
      });
    });
    middleValue = widget.middleValue;
    initAnima();
  }

  void init() {
    translationX = 0.0;
    width = globalKey.currentContext.size.width;
    emptyLenth = width / 2;
    caculateCurrentValue();
  }

  void reSet() {
    if (hasUpdateConfig()) {
      if (_animationControllerSmooth.isAnimating) {
        _animationControllerSmooth.stop();
      }
      if (_animationControllerFling.isAnimating) {
        _animationControllerFling.stop();
      }
      translationX = 0;
      caculateCurrentValue();
      middleValue = widget.middleValue;
      minValue = widget.minValue;
      maxValue = widget.maxValue;
      unitScale = widget.unitScale;
      showScaleNum = widget.showScaleNum;
    }
  }

  bool hasUpdateConfig() {
    return !(widget.middleValue == middleValue &&
        widget.minValue == minValue &&
        widget.maxValue == maxValue &&
        widget.unitScale == unitScale &&
        widget.showScaleNum == showScaleNum);
  }

  void caculateCurrentValue() {
    unitScaleLength = (width ~/ (widget.showScaleNum - 1));
    sumLength = unitScaleLength *
            ((widget.maxValue * 10 - widget.minValue * 10) ~/
                (widget.unitScale * 10)) +
        (widget.showScaleNum - 1) * unitScaleLength; //另外加上一屏的空白宽度使两端能滑到中点
    currentScale = middleValue2minValueScaleNum();
    offsetX = translationX +
        emptyLenth -
        middleValue2minValueScaleNum() * unitScaleLength;
    maxOffsetX = -(unitScaleLength *
            ((widget.maxValue - widget.minValue) ~/ widget.unitScale) -
        emptyLenth);
  }

  void initAnima() {
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
            (emptyLenth - middleValue2minValueScaleNum() * unitScaleLength);
      });
    });
    animateSmooth.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        print('animateSmooth--completed');
        setState(() {
          translationX = offsetX -
              (emptyLenth - middleValue2minValueScaleNum() * unitScaleLength);
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
      onFling(animateFling);
    });
    animateFling.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        smoothToTargetScale();
        print('animateFling--completed');
      }
    });
  }

  void onFling(Animation animateFling) {
    double currentOffsetX = animateFling.value;
    double currentTranslationX = currentOffsetX -
        (emptyLenth - middleValue2minValueScaleNum() * unitScaleLength);
    if (currentOffsetX > emptyLenth) {
      currentOffsetX = emptyLenth;
      currentTranslationX =
          (middleValue2minValueScaleNum() * unitScaleLength).toDouble();
    } else if (currentOffsetX < maxOffsetX) {
      currentOffsetX = maxOffsetX;
      currentTranslationX = maxOffsetX -
          emptyLenth +
          middleValue2minValueScaleNum() * unitScaleLength;
    }
    setState(() {
      offsetX = currentOffsetX;
      translationX = currentTranslationX;
      findScaleByTranslation(offsetX, translationX, refreshCurrentScale: true);
      onSelectedValue();
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
    reSet();
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        child: GestureDetector(
          onTapUp: (TapUpDetails details) {
           onTapUp(details);
          },
          onHorizontalDragStart: (DragStartDetails details) {
            if (_animationControllerFling.isAnimating) {
              _animationControllerFling.stop();
            }
          },
          onHorizontalDragUpdate: (DragUpdateDetails details) {
            setState(() {
              onHorizontalDragUpdate(details);
            });
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            setState(() {
              onHorizontalDragEnd(details);
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
                scaleNum: widget.scaleNum,
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
  void onTapUp(TapUpDetails details) {
    RenderBox renderBox = globalKey.currentContext.findRenderObject();
    Offset offset = renderBox.globalToLocal(details.globalPosition);
    double middle2PointDistance = offset.dx - renderBox.size.width / 2;
    print(
        'onTapUp(): details.globalPosition=${details.globalPosition},offset=$offset');
    if (offsetX <= emptyLenth && offsetX >= maxOffsetX) {
      double targetScaleDistance = offsetX - middle2PointDistance;
      if (targetScaleDistance > emptyLenth) {
        targetScaleDistance = emptyLenth;
      } else if (targetScaleDistance < maxOffsetX) {
        targetScaleDistance = maxOffsetX;
      }
      double currentTranslationX = targetScaleDistance -
          (emptyLenth - middleValue2minValueScaleNum() * unitScaleLength);
      targetScaleDistance =
          findTargetOffsetX(currentTranslationX, targetScaleDistance);
      tweenFling.begin = offsetX;
      tweenFling.end = targetScaleDistance;
      _animationControllerFling.duration = Duration(milliseconds: 200);
      _animationControllerFling.forward(from: 0);
    }
  }
  void onHorizontalDragEnd(DragEndDetails details) {
    velocity = details.velocity.pixelsPerSecond;
    if (velocity.dx.abs() > 0 &&
        offsetX >
            -(unitScaleLength *
                    ((widget.maxValue - widget.minValue) / widget.unitScale) -
                emptyLenth) &&
        offsetX < emptyLenth) {
      //fling
      v0 = velocity.dx;
      double period = (v0 / a).abs(); //以毫秒为单位
      double targetScaleDistance =
          find2TargetScaleDistanceByVelocity(v0, period / 1000, a);
      if (offsetX != targetScaleDistance) {
        tweenFling.begin = offsetX;
        tweenFling.end = targetScaleDistance;
        //  print("distance=${targetScaleDistance - offsetX}");
        _animationControllerFling.duration = Duration(
            milliseconds: (targetScaleDistance - offsetX).abs().toInt());
        _animationControllerFling.forward(from: 0);
      } else {
        onSelectedValue();
      }
    } else if (velocity.dx == 0) {
      //自动居中
      smoothToTargetScale();
    } else {
      onSelectedValue();
    }
  }

  void onHorizontalDragUpdate(DragUpdateDetails details) {
    translationX += details.delta.dx;
    double currentOffsetX = translationX +
        emptyLenth -
        middleValue2minValueScaleNum() * unitScaleLength;
    if (currentOffsetX > emptyLenth) {
      currentOffsetX = emptyLenth;
      translationX =
          (middleValue2minValueScaleNum() * unitScaleLength).toDouble();
    } else if (currentOffsetX < maxOffsetX) {
      currentOffsetX = maxOffsetX;
      translationX = maxOffsetX -
          emptyLenth +
          middleValue2minValueScaleNum() * unitScaleLength;
    }
    offsetX = currentOffsetX;
    findTargetOffsetX(translationX, offsetX, refreshCurrentScale: true);
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
        middleValue2minValueScaleNum() * unitScaleLength;
    if (sourceOffsetX > emptyLenth) {
      sourceOffsetX = emptyLenth;
      sourceTranslationX =
          (middleValue2minValueScaleNum() * unitScaleLength).toDouble();
    } else if (sourceOffsetX < maxOffsetX) {
      sourceOffsetX = maxOffsetX;
      sourceTranslationX = maxOffsetX -
          emptyLenth +
          middleValue2minValueScaleNum() * unitScaleLength;
    }
    return findTargetOffsetX(sourceTranslationX, sourceOffsetX,
        refreshCurrentScale: false);
    //return sourceTranslationX;
  }

  void smoothToTargetScale({int duration = 200}) {
    startAnima(offsetX,
        findTargetOffsetX(translationX, offsetX, refreshCurrentScale: true),
        duration: duration);
  }

  double findTargetOffsetX(double translationX, double offsetX,
      {bool refreshCurrentScale = false}) {
    //translationX 除以 unitScaleLength 如果结果(68.999999999999)很接近一个整数，
    // 那么 ~/和/操作符的结果都是整数(69)
    double end = findScaleByTranslation(offsetX, translationX,
        refreshCurrentScale: refreshCurrentScale);
    return end;
  }

  double findScaleByTranslation(double offsetX, double translationX,
      {bool refreshCurrentScale = false}) {
    double end = offsetX;
    int leftScale =
        (middleValue2minValueScaleNum() - translationScaleNum(translationX)) > 0
            ? (middleValue2minValueScaleNum() -
                translationScaleNum(translationX))
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

  int translationScaleNum(double translationX) =>
      translationX ~/ unitScaleLength;

  int middleValue2minValueScaleNum() =>
      (widget.middleValue * 10 - widget.minValue * 10) ~/
      (widget.unitScale * 10);

  void startAnima(double start, double end, {int duration = 200}) {
    tweenSmooth.begin = start;
    tweenSmooth.end = end;
    _animationControllerSmooth.duration = Duration(milliseconds: duration);
    _animationControllerSmooth.forward(from: 0);
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/fitforce/datarecord/sleep/date_utils.dart';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter_app/fitforce/datarecord/sleep/timeseekbar/sleepseekbar.dart';

class SleepSeekBarPage extends StatefulWidget {
  final OnProgressChange onProgressChange;
  final int dayOffset;

  const SleepSeekBarPage({this.onProgressChange, this.dayOffset});

  @override
  State<StatefulWidget> createState() {
    return new CircularSeekBarState();
  }
}

class CircularSeekBarState extends State<SleepSeekBarPage> {
  Size cirularSize;
  GlobalKey globalKey;
  double startAngle = 360 - 15 / 2;
  double endAngle = 7 * 15 + 15 / 2;
  double startAngleRadian = 0.0;
  double endAngleRadian = 0.0;
  double dtRadian = 0.0;
  Point<double> pointS;
  Point<double> pointE;
  ui.Image sleepImage, nongzhongImage;
  double zeroTimeTanS, zeroTimeTanE;
  DateTime selectedDateTime; //不能修改
  DateTime startDateTime;
  DateTime endDateTime;
  bool isCurrentDay=false;
  @override
  void initState() {
    super.initState();
    cirularSize = Size(240.0, 240.0);
    globalKey = GlobalKey();
    pointS =
        calulatePointPosition(startAngle, cirularSize, cirularSize.width / 2);
    pointE =
        calulatePointPosition(endAngle, cirularSize, cirularSize.width / 2);
    selectedDateTime =
        DateUtils.getOneDayNextDate(DateTime.now(), widget.dayOffset);
    selectedDateTime = DateTime(
        selectedDateTime.year, selectedDateTime.month, selectedDateTime.day);
    startDateTime = selectedDateTime.add(Duration(minutes: -30));
    endDateTime = selectedDateTime.add(Duration(hours: 7, minutes: 30));
    print(
        'startDateTime=${startDateTime.toIso8601String()},endDateTime=${endDateTime.toIso8601String()},selectedDateTime=${selectedDateTime.toIso8601String()}');
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      rangeChange();
      SleepSeekBar.getImage(asset: 'images/data_record_sleep.png')
          .then((image) {
        setState(() {
          sleepImage = image;
        });
      });
      SleepSeekBar.getImage(asset: 'images/data_record_naozhong.png')
          .then((image) {
        setState(() {
          nongzhongImage = image;
        });
      });
    });
  }

  void rangeChange() {
    startAngleRadian = startAngle * pi / 180;
    endAngleRadian = endAngle * pi / 180;
    if (endAngleRadian - startAngleRadian >= 0) {
      dtRadian = endAngleRadian - startAngleRadian;
    } else {
      dtRadian = 2 * pi - (startAngleRadian - endAngleRadian);
    }
    widget.onProgressChange?.call(startDateTime, endDateTime,
        (dtRadian / (2 * pi) * SleepSeekBar.HEX * 60).toInt());
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
              startAngleRadian: startAngleRadian,
              endAngleRadian: endAngleRadian,
              dtAngle: dtRadian,
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
    double touchPointTan = ((globalToLocal.dy - cirularSize.height / 2) /
        (globalToLocal.dx - cirularSize.width / 2));
    double tan = touchPointTan.abs();
    double radian = atan(tan);
    double angle = radian / pi * 180;
    bool touchS = judgeTouchS(globalToLocal);

    if ((globalToLocal.dy - cirularSize.height / 2) < 0 &&
        (globalToLocal.dx - cirularSize.width / 2) > 0) {
      //第一象限
      if (touchS) {
        if (zeroTimeTanS != null) {
          if (zeroTimeTanS > 0) {
            isCurrentDay=true;
            print('caculateRadianByTouchPoint():开始从二进入一&&开始时间要跳到当前这一天,结束时间还是当前这一天');
          }
        }
        zeroTimeTanS = touchPointTan;
      } else {
        if (zeroTimeTanE != null) {
          if (zeroTimeTanE > 0) {
            isCurrentDay=false;
            print(
                'caculateRadianByTouchPoint():结束从二进入一&&原来开始和结束时间都在当前这一天变成开始时间要跳到前一天，结束时间还是当前这一天(零时)');
          }
        }
        zeroTimeTanE = touchPointTan;
      }
      angle = 90 - angle;
    } else if ((globalToLocal.dy - cirularSize.height / 2) < 0 &&
        (globalToLocal.dx - cirularSize.width / 2) < 0) {
      //第二象限
      if (touchS) {
        if (zeroTimeTanS != null) {
          if (zeroTimeTanS < 0) {
            print(
                'caculateRadianByTouchPoint():开始从一进入二&&开始时间要跳到前一天,结束时间还是当前这一天');
          }
        }
        zeroTimeTanS = touchPointTan;
      } else {
        if (zeroTimeTanE != null) {
          if (zeroTimeTanE < 0) {
            isCurrentDay=false;
            print('caculateRadianByTouchPoint():结束从一进入二&&结束时间要跳到前一天,开始为前一天');
          }
        }
        zeroTimeTanE = touchPointTan;
      }
      angle = 270 + angle;
    } else if ((globalToLocal.dy - cirularSize.height / 2) > 0 &&
        (globalToLocal.dx - cirularSize.width / 2) < 0) {
      angle = 270 - angle;
    } else if ((globalToLocal.dy - cirularSize.height / 2) > 0 &&
        (globalToLocal.dx - cirularSize.width / 2) > 0) {
      //第四象限
      angle = 90 + angle;
    } else if ((globalToLocal.dy - cirularSize.height / 2) < 0 &&
        (globalToLocal.dx - cirularSize.width / 2) == 0) {
      angle = 0;
    } else if ((globalToLocal.dy - cirularSize.height / 2) == 0 &&
        (globalToLocal.dx - cirularSize.width / 2) > 0) {
      angle = 90;
    } else if ((globalToLocal.dy - cirularSize.height / 2) > 0 &&
        (globalToLocal.dx - cirularSize.width / 2) == 0) {
      angle = 180;
    } else if ((globalToLocal.dy - cirularSize.height / 2) == 0 &&
        (globalToLocal.dx - cirularSize.width / 2) < 0) {
      angle = 270;
    }

    if (!touchS) {
      endAngle = angle;
      pointE =
          calulatePointPosition(endAngle, cirularSize, cirularSize.width / 2);
    } else {
      startAngle = angle;
      pointS =
          calulatePointPosition(startAngle, cirularSize, cirularSize.width / 2);
    }
    if(startAngle>endAngle){//有时间跨度
      startDateTime = selectedDateTime.add(Duration(
          days: -1,
          minutes: (startAngleRadian / (2 * pi) * 24 * 60).toInt()));
      endDateTime = selectedDateTime.add(Duration(
          minutes: (endAngleRadian / (2 * pi) * 24 * 60).toInt()));
    }else if(startAngle<endAngle){
     // 判断是前一天还是当天
      if(isCurrentDay){
        startDateTime = selectedDateTime.add(Duration(
            minutes: (startAngleRadian / (2 * pi) * 24 * 60).toInt()));
        endDateTime = selectedDateTime.add(Duration(
            minutes: (endAngleRadian / (2 * pi) * 24 * 60).toInt()));
      }else{
        startDateTime = selectedDateTime.add(Duration(
            days: -1,
            minutes: (startAngleRadian / (2 * pi) * 24 * 60).toInt()));
        endDateTime = selectedDateTime.add(Duration(
            days: -1,
            minutes: (endAngleRadian / (2 * pi) * 24 * 60).toInt()));
      }

    }
    rangeChange();
  }

  bool judgeTouchS(Offset globalToLocal) {
    if ((pow(((globalToLocal.dx - cirularSize.width / 2) - pointS.x).abs(), 2) +
            pow(((globalToLocal.dy - cirularSize.height / 2) - pointS.y).abs(),
                2)) >
        (pow(((globalToLocal.dx - cirularSize.width / 2) - pointE.x).abs(), 2) +
            pow(((globalToLocal.dy - cirularSize.height / 2) - pointE.y).abs(),
                2))) {
      return false;
    } else {
      return true;
    }
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

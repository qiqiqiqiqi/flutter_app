import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/services.dart';

typedef OnProgressChange = Function(int startTime, int endTime,int range);

class SleepSeekBar extends CustomPainter {
  double angleS = 0.0;
  double angleE = 0.0;
  double maxAngle = 720.0;
  double padding = 0;
  Point<double> pointS;
  Point<double> pointE;
  double timeValue;
  ui.Image sleepImage, nongzhongImage;

  SleepSeekBar({
    @required this.angleS,
    @required this.angleE,
    this.pointS,
    this.pointE,
    this.sleepImage,
    this.nongzhongImage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    //canvas.drawColor(Colors.redAccent, BlendMode.srcATop);
    if (angleS != null) {
      drawScale(canvas, size);
      drawRing(canvas, size);
      drawArc(canvas, size);
      drawCenter(canvas, size);
    }
  }

  void drawArc(Canvas canvas, Size size) {
    angleS = angleS % 360;
    angleE = angleE % 360;
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    double startAngle = angleS * pi / 180;
    double endAngle = angleE * pi / 180;
    double dt_Angle = endAngle - startAngle >= 0
        ? endAngle - startAngle
        : 2 * pi - (startAngle - endAngle);
    timeValue = dt_Angle / (2 * pi) * 12 * 60;
    canvas.rotate(startAngle - 90 * pi / 180);
    SweepGradient sweepGradient = SweepGradient(
        colors: <Color>[Colors.redAccent, Colors.green],
        startAngle: 0,
        endAngle: dt_Angle);
    Paint paint = Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..color = Color(0xFF1AD9CA)
          ..strokeWidth = 6
        /*..shader = sweepGradient.createShader(Rect.fromLTRB(
          -size.width / 2, -size.height / 2, size.width / 2, size.height / 2))*/
        ;
    canvas.drawArc(
        Rect.fromLTRB(
            -size.width / 2, -size.height / 2, size.width / 2, size.height / 2),
        0,
        dt_Angle,
        false,
        paint);
    canvas.restore();

    drawPoint(canvas, size, angleS, pointS, Colors.redAccent, sleepImage);
    drawPoint(canvas, size, angleE, pointE, Colors.green, nongzhongImage);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void drawScale(Canvas canvas, Size size) {
    canvas.save();
    double unitAngle = maxAngle / 12;
    for (int i = 0; i <= 6; i++) {
      int rightScaleValue = i;
      if (rightScaleValue == 0) {
        rightScaleValue = 12;
      }
      drawScaleText(canvas, size, "$rightScaleValue", unitAngle * i);
      drawScaleLine(canvas, size, unitAngle * i);

      int leftScaleValue = 12 - i;
      drawScaleText(canvas, size, "$leftScaleValue", -unitAngle * i);
      drawScaleLine(canvas, size, -unitAngle * i);
    }
    canvas.restore();
  }

  void drawRing(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    Paint paint = Paint()
      ..isAntiAlias = true
      ..color = Colors.grey[200]
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawArc(
        (Rect.fromLTRB(-size.width / 2 + padding, -size.height / 2 + padding,
            size.width / 2 - padding, size.height / 2 - padding)),
        -pi / 4,
        2 * pi,
        false,
        paint);
    canvas.restore();
  }

  void drawScaleLine(Canvas canvas, Size size, double rotateAngle) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotateAngle * pi / 180);
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = Color(0xFFc7c7c7)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0.0, -size.height / 4 - 8),
        Offset(0.0, -size.height / 4 - 14), paint);
    canvas.restore();
  }

  void drawScaleText(
      Canvas canvas, Size size, String text, double rotateAngle) {
    canvas.save();
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: text,
            style: TextStyle(
                color: Color(0xFFC7C7C7),
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal)));
    textPainter.layout();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotateAngle * pi / 180);
    canvas.translate(0, -size.height * 3 / 8);
    canvas.rotate(-rotateAngle * pi / 180);
    textPainter.paint(canvas,
        Offset(-textPainter.size.width / 2, -textPainter.size.height / 2));
    canvas.restore();
  }

  void drawPoint(Canvas canvas, Size size, double angle, Point point,
      Color color, ui.Image image) {
    if (angle != null && image != null) {
      canvas.save();
      canvas.translate(size.width / 2, size.height / 2);
      Paint paint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill
        ..color = color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2;
      //canvas.drawCircle(Offset(point.x, point.y), 12, paint);

      canvas.drawImageRect(
          image,
          Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
          Rect.fromLTRB(point.x - 18, point.y - 18, point.x + 18, point.y + 18),
          paint);
      canvas.restore();
    }
  }

  Point<num> calulatePointPosition(double angle, Size size, double raduis) {
    Point<num> point = Point(0, 0);
    if (angle >= 0 && angle < 90) {
      double sinValue = sin((90 - angle) / 180 * pi);
      double cosValue = cos((90 - angle) / 180 * pi);
      point = Point(size.width / 2 + raduis * cosValue,
          size.height / 2 - raduis * sinValue);
    } else if (angle >= 90 && angle < 180) {
      double sinValue = sin((angle - 90) / 180 * pi);
      double cosValue = cos((angle - 90) / 180 * pi);
      point = Point(size.width / 2 + raduis * cosValue,
          size.height / 2 + raduis * sinValue);
    } else if (angle >= 180 && angle < 270) {
      double sinValue = sin((270 - angle) / 180 * pi);
      double cosValue = cos((270 - angle) / 180 * pi);
      point = Point(size.width / 2 - raduis * cosValue,
          size.height / 2 + raduis * sinValue);
    } else if (angle >= 270 && angle <= 360) {
      double sinValue = sin((360 - angle) / 180 * pi);
      double cosValue = cos((360 - angle) / 180 * pi);
      point = Point(size.width / 2 - raduis * sinValue,
          size.height / 2 - raduis * cosValue);
    }
    return point;
  }

  void drawCenter(Canvas canvas, Size size) {
    canvas.save();

    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = Colors.grey[200];
    canvas.translate(size.width / 2, size.height / 2);
    canvas.drawCircle(Offset(0.0, 0.0), size.width / 4, paint);
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: timeValue ~/ 60 == 0 ? '' : '${timeValue ~/ 60}',
            style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal),
            children: <TextSpan>[
              TextSpan(
                  text: timeValue ~/ 60 == 0 ? '' : '小时',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal)),
              TextSpan(
                  text: (timeValue % 60).toInt() == 0
                      ? ''
                      : '${(timeValue % 60).toInt()}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal)),
              TextSpan(
                  text: (timeValue % 60).toInt() == 0 ? '' : '分',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal))
            ]));
    textPainter.layout();
    textPainter.paint(canvas,
        Offset(-textPainter.size.width / 2, -textPainter.size.height / 2));
    canvas.restore();
  }

  static Future<ui.Image> getImage({String asset, BuildContext context}) async {
    //ByteData data = await DefaultAssetBundle.of(context).load(asset);
    ByteData data = await rootBundle.load(asset);
    Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }
}

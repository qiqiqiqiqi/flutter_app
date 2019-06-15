import 'package:flutter/material.dart';
import 'dart:math';

class CircularSeekBar extends CustomPainter {
  double angle = 180.0;
  double maxAngle = 360.0;
  double padding = 0;

  CircularSeekBar(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.blue, BlendMode.difference);
    if (angle != null) {
      drawScale(canvas, size);
      drawRing(canvas, size);
      // drawPoint(canvas, size);
    }
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
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
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
    canvas.drawLine(Offset(0.0, -size.height / 4),
        Offset(0.0, -size.height / 4 - 12), paint);
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
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic)));
    textPainter.layout();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotateAngle * pi / 180);
    canvas.translate(0, -size.height / 4 - textPainter.size.height / 2);
    canvas.rotate(-rotateAngle * pi / 180);
    textPainter.paint(canvas,
        Offset(-textPainter.size.width / 2, -textPainter.size.height / 2));
    canvas.restore();
  }

  void drawPoint(Canvas canvas, Size size) {
    if (angle != null) {
      canvas.save();
      print("drawPoint():angle=$angle");
      Point point;
      double raduis = size.width / 2 - padding;

      if (angle >= 0 && angle < 90) {
        double sinValue = sin((90 - angle) / 180 * pi);
        double cosValue = cos((90 - angle) / 180 * pi);
        point = Point(size.width / 2 - raduis * cosValue,
            size.height / 2 + raduis * sinValue);
      } else if (angle > 90 && angle < 180) {
        double sinValue = sin((angle - 90) / 180 * pi);
        double cosValue = cos((angle - 90) / 180 * pi);
        point = Point(size.width / 2 - raduis * cosValue,
            size.height / 2 - raduis * sinValue);
      } else if (angle >= 180 && angle < 270) {
        double sinValue = sin((angle - 180) / 180 * pi);
        double cosValue = cos((angle - 180) / 180 * pi);
        point = Point(size.width / 2 + raduis * sinValue,
            size.height / 2 - raduis * cosValue);
      } else if (angle >= 270 && angle <= 360) {
        double sinValue = sin((angle - 270) / 180 * pi);
        double cosValue = cos((angle - 270) / 180 * pi);
        point = Point(size.width / 2 + raduis * cosValue,
            size.height / 2 + raduis * sinValue);
      }
      Paint paint = Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill
        ..color = Colors.redAccent
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2;
      canvas.drawCircle(Offset(point.x, point.y), 8, paint);
      canvas.restore();
    }
  }
}

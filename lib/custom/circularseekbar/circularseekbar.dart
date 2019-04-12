import 'package:flutter/material.dart';
import 'dart:math';

class CircularSeekBar extends CustomPainter {
  double angle = 135.0;
  double maxAngle = 270.0;
  double padding = 32.0;

  CircularSeekBar(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    //  canvas.drawColor(Colors.blue, BlendMode.difference);
    if (angle != null) {
      drawScale(canvas, size);
      drawRing(canvas, size);
      drawPoint(canvas, size);
      drawCenter(canvas, size);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void drawScale(Canvas canvas, Size size) {
    canvas.save();
    double unitAngle = maxAngle / 20;
    for (int i = 0; i <= 10; i++) {
      int rightScaleValue = 20 + i;
      if (rightScaleValue % 5 == 0) {
        drawScaleText(canvas, size, "${rightScaleValue}", unitAngle * i);
      } else {
        drawScaleLine(canvas, size, unitAngle * i);
      }
      int leftScaleValue = 20 - i;
      if (leftScaleValue % 5 == 0) {
        drawScaleText(canvas, size, "$leftScaleValue", -unitAngle * i);
      } else {
        drawScaleLine(canvas, size, -unitAngle * i);
      }
    }
    canvas.restore();
  }

  void drawRing(Canvas canvas, Size size) {
    double offsetRadian = 10 * pi / 180;
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-5 * pi / 4 - offsetRadian);
    SweepGradient sweepGradient = SweepGradient(
      endAngle: 5 * pi / 4 + offsetRadian,
      startAngle: offsetRadian,
      colors: <Color>[
        Color(0xFF00ADEF),
        Color(0xFF10BDDE),
       /* Color(0XFF3FCDB2)*/Colors.redAccent,

        Color(0xFFB1C04F),
        Color(0xFFF9B512)
      ],
    );
    Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..shader = sweepGradient.createShader(Rect.fromLTRB(
          -size.width / 2, -size.height / 2, size.width / 2, size.height / 2));
    canvas.drawArc(
        (Rect.fromLTRB(-size.width / 2 + padding, -size.height / 2 + padding,
            size.width / 2 - padding, size.height / 2 - padding)),
        offsetRadian,
        3 / 2 * pi,
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
    canvas.drawLine(Offset(0.0, -size.height / 2),
        Offset(0.0, -size.height / 2 + 12), paint);
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
    textPainter.paint(
        canvas, Offset(-textPainter.size.width / 2, -size.height / 2));
    canvas.restore();
  }

  void drawPoint(Canvas canvas, Size size) {
    if (angle != null) {
      canvas.save();
      print("drawPoint():angle=$angle");
      Point point;
      double raduis = size.width / 2 - padding;
      if (angle > 270) {
        angle = 270;
      }
      if (angle < 0) {
        angle = 0;
      }
      if (angle >= 0 && angle < 45) {
        double sinValue = sin((45 - angle) / 180 * pi);
        double cosValue = cos((45 - angle) / 180 * pi);
        point = Point(size.width / 2 - raduis * cosValue,
            size.height / 2 + raduis * sinValue);
      } else if (angle > 45 && angle < 135) {
        double sinValue = sin((angle - 45) / 180 * pi);
        double cosValue = cos((angle - 45) / 180 * pi);
        point = Point(size.width / 2 - raduis * cosValue,
            size.height / 2 - raduis * sinValue);
      } else if (angle >= 135 && angle < 225) {
        double sinValue = sin((angle - 135) / 180 * pi);
        double cosValue = cos((angle - 135) / 180 * pi);
        point = Point(size.width / 2 + raduis * sinValue,
            size.height / 2 - raduis * cosValue);
      } else if (angle >= 225 && angle <= 270) {
        double sinValue = sin((angle - 225) / 180 * pi);
        double cosValue = cos((angle - 225) / 180 * pi);
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

  void drawCenter(Canvas canvas, Size size) {
    canvas.save();
    double raduis = (size.width / 2 - padding) * 3 / 5;
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = getColorByAngle(angle)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), raduis, paint);

    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: "${(angle / maxAngle * 20 + 10).round()}℃",
            style: TextStyle(
                color: Colors.white,
                fontSize: 48.0,
                fontWeight: FontWeight.bold,
                fontFamily: "digital")));
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(size.width / 2 - textPainter.size.width / 2,
            size.height / 2 - textPainter.size.height / 2));
    canvas.restore();
  }

  Color getColorByAngle(double angle) {
    Color startColor = Color(0xFF00ADEF);
    Color endColor = Color(0xFFF9B512);
    int startred = startColor.red;
    int startgreen = startColor.green;
    int startblue = startColor.blue;
    int endred = endColor.red;
    int endgreen = endColor.green;
    int endblue = endColor.blue;

    int red = (startred + (endred - startred) * (angle / 270)).toInt();
    int green = (startgreen + (endgreen - startgreen) * (angle / 270)).toInt();
    int blue = (startblue + (endblue - startblue) * (angle / 270)).toInt();

    return Color.fromARGB(255, red, green, blue);
  }
}

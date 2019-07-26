import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as Math;

class ThumbPainter extends CustomPainter {
  double circleAnimateValue;
  double pathAnimateValue;
  double textSizeAnimateValue;
  bool reverse;
  Paint _paint;
  Path _path;
  List<double> pointsRaduis;
  List<Color> pointsColors;
  String text;

  ThumbPainter(
      {this.circleAnimateValue = 0,
      this.pathAnimateValue = 0,
      this.textSizeAnimateValue = 0,
      this.reverse = false,
      this.text = '真棒，任务完成了!'}) {
//    print(
//        'ThumbPainter--ThumbPainter():circleAnimateValue=${this.circleAnimateValue},pathAnimateValue=$pathAnimateValue,reverse=$reverse');
    init();
  }

  void init() {
    _path = Path();
    pointsRaduis = [5, 6, 5, 5, 8];
    pointsColors = [
      Colors.amber,
      Colors.deepOrange,
      Colors.amber,
      Colors.deepOrange,
      Colors.deepOrange
    ];
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true
      ..strokeWidth = 4
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = Colors.amber;
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawBigCircles(canvas, size);
    drawSmallCircles(canvas, size);
    drawPath(canvas, size);
    drawText(canvas, size);
  }

  void drawBigCircles(Canvas canvas, Size size) {
    canvas.save();
    //  drawBigCircle(canvas, size, Colors.lightBlue, size.width / 2);
    double bottomRadio = size.width / 2;
    double topRadio = size.width / 2;
    bottomRadio = (circleAnimateValue * 1.2 > 1 ? 1 : circleAnimateValue * 1.2);
    topRadio = circleAnimateValue;
    drawBigCircle(
        canvas,
        size,
        Color.fromARGB((255 * 0.8).toInt(), Colors.redAccent.red,
            Colors.redAccent.green, Colors.redAccent.blue),
        size.width / 2 * bottomRadio);
    drawBigCircle(
        canvas,
        size,
        Color.fromARGB((255 * 0.8).toInt(), Colors.amber.red,
            Colors.amber.green, Colors.amber.blue),
        size.width / 2 * topRadio);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void drawBigCircle(Canvas canvas, Size size, Color color, double radius) {
    canvas.save();
    _paint.color = color;
    _paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, _paint);
    canvas.restore();
  }

  void drawSmallCircles(Canvas canvas, Size size) {
    if (pathAnimateValue > 0 && !reverse) {
      canvas.save();
      double interverRadians = 2 * Math.pi / 5;
      canvas.translate(size.width / 2, size.height / 2);
      canvas.rotate(interverRadians / 2 * (pathAnimateValue));
      for (int i = 0; i < pointsRaduis.length; i++) {
        drawSmallCircle(
            canvas, size, i, interverRadians, pointsRaduis[i], pointsColors[i]);
      }
      canvas.restore();
    }
  }

  void drawSmallCircle(Canvas canvas, Size size, int position,
      double interverRadians, double radius, Color color) {
    canvas.save();
    _paint.color = color;
    _paint.style = PaintingStyle.fill;
    canvas.rotate(interverRadians * position);
    canvas.drawCircle(Offset(0, -size.height / 2 - (radius + 4)),
        radius * (1 - pathAnimateValue), _paint);
    canvas.restore();
  }

  void drawPath(Canvas canvas, Size size) {
    if (pathAnimateValue == 0) {
      return;
    }
    canvas.save();
    canvas.translate((size.width / 2) * 0.9, (size.height / 2) * 1.3);
    _paint.color = Colors.white;
    _paint.style = PaintingStyle.stroke;
    _path.moveTo(-Math.pow(Math.pow(size.width / 6, 2), 1 / 2),
        -Math.pow(Math.pow(size.width / 6, 2), 1 / 2));
    _path.lineTo(0, 0);
    _path.lineTo(Math.pow(Math.pow(size.width / 3, 2), 1 / 2),
        -Math.pow(Math.pow(size.width / 3, 2), 1 / 2));
    final PathMetrics pathMetrics = _path.computeMetrics(forceClosed: false);
    final PathMetric pathMetric = pathMetrics.elementAt(0);
    double length = pathMetric.length;
    Path extractPath = pathMetric.extractPath(
        reverse ? ((1 - pathAnimateValue) * length) : 0,
        reverse ? length : pathAnimateValue * length);
    canvas.drawPath(extractPath, _paint);
    canvas.restore();
  }

  void drawText(Canvas canvas, Size size) {
    canvas.save();
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        maxLines: 1,
        text: TextSpan(
            text: text,
            style: TextStyle(
                color: Color.fromARGB((255 * circleAnimateValue).toInt(),
                    Colors.amber.red, Colors.amber.green, Colors.amber.blue),
                fontSize: 16 * textSizeAnimateValue,
                fontWeight: FontWeight.w600)));
    textPainter.layout();
    textPainter.paint(canvas,
        Offset(size.width + 16, size.height / 2 - textPainter.height / 2));
    canvas.restore();
  }
}

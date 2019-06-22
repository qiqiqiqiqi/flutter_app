import 'package:flutter/material.dart';
import 'dart:math' as Math;

class DietRecordSeekBarPainter extends CustomPainter {
  double progress = 0;
  double maxProgress = 100;

  DietRecordSeekBarPainter({this.progress, this.maxProgress});

  @override
  void paint(Canvas canvas, Size size) {
    drawArc(canvas, size);
    drawCenter(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void drawArc(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    Paint paint = Paint()
      ..isAntiAlias = true
      ..color = Colors.grey[200]
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
        Rect.fromCircle(center: Offset(0, 0), radius: size.width / 2),
        -5 / 4 * Math.pi,
        3 / 2 * Math.pi,
        false,
        paint);
    paint.color = Color(0xFF1AD9CA);
    canvas.drawArc(
        Rect.fromCircle(center: Offset(0, 0), radius: size.width / 2),
        -5 / 4 * Math.pi,
        3 / 2 * Math.pi * (progress / maxProgress),
        false,
        paint);
    canvas.restore();
  }

  void drawCenter(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: '${progress.toInt()}',
          style: TextStyle(
              color: Color(0xFF374147),
              fontSize: 35,
              fontWeight: FontWeight.bold),
        ));
    textPainter.layout();
    textPainter.paint(canvas,
        Offset(-textPainter.size.width / 2, -textPainter.size.height / 2));

    TextPainter textPainter2 = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: '${maxProgress.toInt()} kcal',
          style: TextStyle(
              color: Color(0xFFB9B8B8),
              fontSize: 12,
              fontWeight: FontWeight.bold,decorationStyle: TextDecorationStyle.dashed),
        ));
    textPainter2.layout();
    textPainter2.paint(canvas,
        Offset(-textPainter2.size.width / 2, textPainter.size.height / 2 + 12));

    canvas.restore();
  }
}

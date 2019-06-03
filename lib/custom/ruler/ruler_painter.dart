import 'package:flutter/material.dart';

class RulerPainter extends CustomPainter {
  int minValue = 0;
  int middleValue = 0;
  int maxValue = 0;
  double translationX = 0.0;
  double unitScale = 0.5;
  double unitScaleLength;
  int scaleNum;
  double sumLength;
  double emptyLenth;
  Paint _paint;
  int showScaleNum = 9;
  double offsetX = 0.0;

  RulerPainter({this.unitScaleLength, this.offsetX,this.scaleNum}) {
    _paint = Paint()..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawScale(canvas, size);
  }

  void drawScale(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));

    double offsetY = size.height * 9 / 16;
    drawScaleX(canvas, offsetY);
    drawCursor(canvas, offsetY, size);
    canvas.restore();
  }

  void drawScaleX(Canvas canvas, double offsetY) {
    canvas.save();
    canvas.translate(offsetX, offsetY);
    _paint.strokeWidth = 2;
    _paint.color = Color(0xFFE8E9EB);
    List<Offset> scales = List();
    for (int i = 0; i <= scaleNum; i++) {
      scales.add(
        Offset(i * unitScaleLength, 0),
      );
      if (i % 2 == 0) {
        canvas.drawLine(Offset(i * unitScaleLength, 0),
            Offset(i * unitScaleLength, 12), _paint);
        TextPainter textPainter = TextPainter(
            textDirection: TextDirection.ltr,
            text: TextSpan(
                text: '${(i * unitScale).toInt()}',
                style: TextStyle(
                  color: Color(0xFFE8E9EB),
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                )));
        textPainter.layout();
        textPainter.paint(
            canvas, Offset(i * unitScaleLength - textPainter.width / 2, 21));
      } else {
        canvas.drawLine(Offset(i * unitScaleLength, 0),
            Offset(i * unitScaleLength, 4), _paint);
      }
    }
    canvas.drawLine(scales[0], scales[scales.length - 1], _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void drawCursor(Canvas canvas, double offsetY, Size size) {
    canvas.save();
    _paint
      ..color = Color(0xFF1AD9CA)
      ..strokeWidth = 3;
    canvas.translate(size.width / 2, offsetY);
    canvas.drawLine(Offset(0, -12.5), Offset(0, 12.5), _paint);
    canvas.restore();
  }
}

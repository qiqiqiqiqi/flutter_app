import 'package:flutter/material.dart';
import 'dart:math' as Math;

class RulerPainter extends CustomPainter {
  double unitScale = 0.1;
  int unitScaleLength = 0;
  int scaleNum = 0;
  Paint _paint;
  double offsetX = 0.0;
  int minValue = 0;
  int middleValue = 0;
  int maxValue = 0;
  double translationX = 0.0;
  int currentSacle = 0;
  double emptyLenth;
  String unit;
  bool showHL;

  RulerPainter(
      {this.unitScaleLength,
      this.offsetX,
      this.scaleNum,
      this.minValue,
      this.maxValue,
      this.middleValue,
      this.unitScale,
      this.currentSacle,
      this.emptyLenth,
      this.unit,
      this.showHL}) {
    _paint = Paint()..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    draw(canvas, size);
  }

  void draw(Canvas canvas, Size size) {
    canvas.save();
    double offsetY = size.height * 9 / 16;
    drawScaleX(canvas, offsetY, size);
    drawCursor(canvas, offsetY, size);
    drawCurrentValue(canvas, offsetY, size);
    canvas.restore();
  }

  void drawScaleX(Canvas canvas, double offsetY, Size size) {
    canvas.save();
    _paint.strokeWidth = 2;
    _paint.color = Color(0xFFE8E9EB);
    List<Offset> scales = List();
    for (int i = 0; i <= scaleNum; i++) {
      scales.add(
        Offset((i * unitScaleLength).toDouble(), 0),
      );

      if (1 / unitScale < 10) {
        if (unitScale == 1) {
          drawScaleLine(canvas, size, offsetY, i, 12);
          drawScaleText(canvas, size, offsetY, i);
        } else {
          if (i % 2 == 0) {
            drawScaleLine(canvas, size, offsetY, i, 12);
            drawScaleText(canvas, size, offsetY, i);
          } else {
            drawScaleLine(canvas, size, offsetY, i, 4);
          }
        }
      } else {
        if (i % 10 == 0) {
          drawScaleLine(canvas, size, offsetY, i, 12);
          drawScaleText(canvas, size, offsetY, i);
        } else if (i % 5 == 0) {
          drawScaleLine(canvas, size, offsetY, i, 8);
        } else {
          drawScaleLine(canvas, size, offsetY, i, 4);
        }
      }
    }
    if (showHL != null && showHL) {
      drawHLine(canvas, size, offsetY, scales);
    }
    canvas.restore();
  }

  void drawHLine(
      Canvas canvas, Size size, double offsetY, List<Offset> scales) {
    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    canvas.translate(offsetX, offsetY);
    canvas.drawLine(scales[0], scales[scales.length - 1], _paint);
    canvas.restore();
  }

  void drawScaleLine(
      Canvas canvas, Size size, double offsetY, int i, double end) {
    if (((i - currentSacle) * unitScaleLength).abs() > emptyLenth) {
      return;
    }
    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    canvas.translate(offsetX, offsetY);
    canvas.drawLine(Offset((i * unitScaleLength).toDouble(), 0),
        Offset((i * unitScaleLength).toDouble(), end), _paint);
    canvas.restore();
  }

  void drawScaleText(Canvas canvas, Size size, double offsetY, int i) {
    if (((i - currentSacle) * unitScaleLength).abs() > emptyLenth) {
      return;
    }
    canvas.save();
    canvas.clipRect(Rect.fromLTRB(-unitScaleLength / 2, 0,
        size.width + unitScaleLength / 2, size.height));
    canvas.translate(offsetX, offsetY);
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: '${(i * unitScale + minValue).toInt()}',
            style: TextStyle(
              color: currentSacle == i ? Color(0xFF808184) : Color(0xFFE8E9EB),
              fontSize: currentSacle == i ? 13.0 : 12.0,
              fontWeight: FontWeight.bold,
            )));
    textPainter.layout();
    textPainter.paint(
        canvas, Offset(i * unitScaleLength - textPainter.width / 2, 21));
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

  void drawCurrentValue(Canvas canvas, double offsetY, Size size) {
    canvas.save();
    _paint
      ..color = Color(0xFF1AD9CA)
      ..strokeWidth = 3;
    canvas.translate(size.width / 2, offsetY);
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text:
                '${((currentSacle * unitScale + minValue) - (currentSacle * unitScale + minValue).toInt()) == 0 ? ((currentSacle * unitScale) + minValue).toInt() : (((currentSacle * unitScale) * 10).toInt() / 10 + minValue)} $unit',
            style: TextStyle(
              color: Color(0xFF374147),
              fontSize: 23.0,
            )));
    textPainter.layout();
    textPainter.paint(canvas, Offset(-textPainter.width / 2, -45));
    canvas.restore();
  }
}

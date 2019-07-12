import 'package:flutter/material.dart';
import 'dart:math' as Math;

class RulerPainter extends CustomPainter {
  double unitScale = 0.1;
  int unitScaleLength = 0;
  int scaleNum = 0;
  Paint _paint;
  double offsetX = 0.0;
  int minValue = 0;
  double middleValue = 0;
  int maxValue = 0;
  double translationX = 0.0;
  int currentSacle = 0;
  double emptyLenth;
  String unit;
  bool showHL;
  double minScaleLength = 4.0;
  double middleScaleLength = 8.0;
  double maxScaleLength = 12.0;
  double cursorScaleLength = 25.0;
  int showScaleNum;

  RulerPainter({this.unitScaleLength,
    this.offsetX,
    this.scaleNum,
    this.minValue,
    this.maxValue,
    this.middleValue,
    this.unitScale,
    this.currentSacle,
    this.emptyLenth,
    this.unit,
    this.showHL = true,
    this.maxScaleLength = 12,
    this.middleScaleLength = 8.0,
    this.minScaleLength = 4.0,
    this.cursorScaleLength = 25.0,
    this.showScaleNum}) {
    _paint = Paint()
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    draw(canvas, size);
  }

  void draw(Canvas canvas, Size size) {
    canvas.save();
    double offsetY = size.height / 2;
//    if (showHL) {
//      offsetY = size.height * 9 / 16;
//    }
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
          if (showScaleNum != null && showScaleNum > 10) {
            if (i % 10 == 0) {
              drawScaleLine(canvas, size, offsetY, i, maxScaleLength / 2,
                  -maxScaleLength / 2);
              drawScaleText(canvas, size, offsetY, i);
            } else if (i % 5 == 0) {
              drawScaleLine(canvas, size, offsetY, i,
                  middleScaleLength - maxScaleLength / 2, -maxScaleLength / 2);
            } else {
              drawScaleLine(canvas, size, offsetY, i,
                  minScaleLength - maxScaleLength / 2, -maxScaleLength / 2);
            }
          } else {
            if (showHL) {
              drawScaleLine(canvas, size, offsetY, i, maxScaleLength, 0);
            } else {
              drawScaleLine(canvas, size, offsetY, i, maxScaleLength / 2,
                  -maxScaleLength / 2);
            }
            drawScaleText(canvas, size, offsetY, i);
          }
        } else {
          if (i % 2 == 0) {
            drawScaleLine(canvas, size, offsetY, i, maxScaleLength / 2,
                -maxScaleLength / 2);
            drawScaleText(canvas, size, offsetY, i);
          } else {
            drawScaleLine(canvas, size, offsetY, i, minScaleLength / 2,
                -minScaleLength / 2);
          }
        }
      } else {
        if (!showHL) {
          if (i % 10 == 0) {
            drawScaleLine(canvas, size, offsetY, i, maxScaleLength / 2,
                -maxScaleLength / 2);
            drawScaleText(canvas, size, offsetY, i);
          } else if (i % 5 == 0) {
            drawScaleLine(canvas, size, offsetY, i,
                middleScaleLength - maxScaleLength / 2, -maxScaleLength / 2);
          } else {
            drawScaleLine(canvas, size, offsetY, i,
                minScaleLength - maxScaleLength / 2, -maxScaleLength / 2);
          }
        } else {
          if (i % 10 == 0) {
            drawScaleLine(canvas, size, offsetY, i, maxScaleLength, 0);
            drawScaleText(canvas, size, offsetY, i);
          } else if (i % 5 == 0) {
            drawScaleLine(canvas, size, offsetY, i, middleScaleLength, 0);
          } else {
            drawScaleLine(canvas, size, offsetY, i, minScaleLength, 0);
          }
        }
      }
    }
    if (showHL != null && showHL) {
      drawHLine(canvas, size, offsetY, scales);
    }
    canvas.restore();
  }

  void drawHLine(Canvas canvas, Size size, double offsetY,
      List<Offset> scales) {
    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    canvas.translate(offsetX, offsetY);
    canvas.drawLine(scales[0], scales[scales.length - 1], _paint);
    canvas.restore();
  }

  void drawScaleLine(Canvas canvas, Size size, double offsetY, int i,
      double end, double start) {
    if (((i - currentSacle) * unitScaleLength).abs() > emptyLenth) {
      return;
    }
    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    canvas.translate(offsetX, offsetY);
    canvas.drawLine(Offset((i * unitScaleLength).toDouble(), start),
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
        canvas,
        Offset(i * unitScaleLength - textPainter.width / 2,
            cursorScaleLength / 2 + 8));
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
    canvas.drawLine(Offset(0, -cursorScaleLength / 2),
        Offset(0, cursorScaleLength / 2), _paint);
    canvas.restore();
  }

  void drawCurrentValue(Canvas canvas, double offsetY, Size size) {
    double value= (currentSacle * unitScale * 10).toInt() / 10 + minValue.toDouble();
//    print('drawCurrentValue():currentSacle * unitScale + minValue=${currentSacle * unitScale +
//        minValue},((currentSacle * unitScale* 10).toInt() / 10 + minValue.toDouble())=${((currentSacle *
//        unitScale * 10).toInt() / 10 + minValue.toDouble())},value=$value,middleValue=$middleValue,currentSacle=$currentSacle');
    canvas.save();
    _paint
      ..color = Color(0xFF1AD9CA)
      ..strokeWidth = 3;
    canvas.translate(size.width / 2, offsetY);

    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text:
            '${((currentSacle * unitScale + minValue) -
                (currentSacle * unitScale + minValue).toInt()) == 0
                ? ((currentSacle * unitScale) + minValue).toInt()
                : ((currentSacle * unitScale * 10).toInt() / 10 +
                minValue.toDouble())} $unit',
            style: TextStyle(
              color: Color(0xFF374147),
              fontSize: 23.0,
            )));
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2,
            -cursorScaleLength / 2 - textPainter.height - 8));
    canvas.restore();
  }
}

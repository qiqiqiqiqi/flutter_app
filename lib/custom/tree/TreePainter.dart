import 'package:flutter/material.dart';
import 'dart:math' as Math;

class TreePainter extends CustomPainter {
  Paint _paint;
  Color color;
  double initHeight;
  double _ratio = 0.7;

  TreePainter({@required this.color}) {
    initHeight = 80;
    _paint = Paint()
      ..color = this.color
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.2
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    print('TreePainter--paint():size=$size');
    drawHLine(canvas, size);
    drawTree(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void drawHLine(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2 + 100);
    double height = initHeight;
    for (int i = 0; true; i++) {
      if (height < 1) {
        break;
      }
      double offsetY = 0;
      if (i > 0) {
        offsetY = -initHeight * (1 - Math.pow(_ratio, i)) / (1 - _ratio);
      }
      canvas.drawLine(Offset(-size.width / 2, offsetY),
          Offset(size.width / 2, offsetY), _paint);
      height = height * _ratio;
    }
    canvas.restore();
  }

  void drawTree(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2 + 100);
    double height = initHeight;
    for (int i = 0; true; i++) {
      if (height < 1) {
        break;
      }
      double offsetY = 0;
      if (i > 0) {
        offsetY = -initHeight * (1 - Math.pow(_ratio, i)) / (1 - _ratio);
      }
      canvas.drawLine(Offset(-size.width / 2, offsetY),
          Offset(size.width / 2, offsetY), _paint);
      height = height * _ratio;
    }
    canvas.restore();
  }
}

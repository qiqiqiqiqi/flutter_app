import 'package:flutter/material.dart';
import 'dart:math' as Math;

import 'package:flutter_app/custom/tree/TreeNode.dart';

class TreePainter extends CustomPainter {
  Paint _paint;
  Color color;
  double initHeight;
  double initRadian;
  double _ratio = 0.7;
  TreeNode rootTreeNode;

  TreePainter({@required this.color, this.rootTreeNode}) {
    initHeight = 80;
    initRadian = Math.pi / 12;
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
    drawPaths(canvas, size);
    canvas.restore();
  }

  void drawPaths(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    linePaths(canvas,path, rootTreeNode, initHeight,initRadian);
  }

  List<Path> linePaths(Canvas canvas,Path path, TreeNode rootTreeNode, double height,double radian) {
    if (rootTreeNode.right != null && rootTreeNode.left != null) {
      Math.Point rightPoint =
          Math.Point(Math.tan(rootTreeNode.radian) * height, 0);
      path.lineTo(rightPoint.x, rightPoint.y);
    }
  }
}

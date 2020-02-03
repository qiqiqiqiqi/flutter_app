import 'package:flutter/material.dart';
import 'package:flutter_app/custom/tree/branch.dart';
import 'package:flutter_app/custom/tree/tree.dart';
import 'package:flutter_app/custom/tree/treeNode.dart';
import 'dart:math' as Math;
class TreePainter extends CustomPainter {
  Paint _paint;
  Tree tree;

  TreePainter({this.tree}) {
    if (tree != null) {
      _paint = Paint()
        ..style = PaintingStyle.fill
        ..color = (tree.color ??= Colors.red)
        ..strokeWidth = 0.2
        ..isAntiAlias = true;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
//    canvas.translate(size.width / 2, size.height / 2);
//    canvas.rotate(-Math.pi/2);
    if (tree != null) {
      print('TreePainter--paint():size=$size');
      drawTree(canvas, size);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void drawTree(Canvas canvas, Size size) {
    canvas.save();
    tree.branchs.forEach((Branch branch) {
      drawBranch(branch, canvas);
    });
    canvas.restore();
  }

  void drawBranch(Branch branch, Canvas canvas) {
    branch.treeNodes.forEach((TreeNode treeNode) {
      canvas.drawCircle(
          Offset(treeNode.point.x, treeNode.point.y), treeNode.r, _paint);
    });
    if (branch.childs != null && branch.childs.isNotEmpty) {
      branch.childs.forEach((Branch branch) {
        drawBranch(branch, canvas);
      });
    }
  }
}

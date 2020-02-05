import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/custom/tree/branch.dart';
import 'package:flutter_app/custom/tree/tree.dart';
import 'package:flutter_app/custom/tree/treeNode.dart';
import 'dart:math' as Math;
import 'dart:ui';
import 'dart:ui' as ui;

class TreePainter extends CustomPainter {
  Paint _paint;
  Tree tree;
  ui.Image image;
  double scale;

  TreePainter({this.tree, this.image,this.scale}) {
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
    //  print('TreePainter--paint():size=$size');
      drawTree(canvas, size);
    }
    //drawImage(canvas, size, 3);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void drawTree(Canvas canvas, Size size) {
    canvas.save();
    tree.branchs.forEach((Branch branch) {
      drawBranch(branch, canvas, size);
    });
    canvas.restore();
  }

  void drawBranch(Branch branch, Canvas canvas, Size size) {
    _paint.color = tree.color;
    branch.treeNodes.forEach((TreeNode treeNode) {
      canvas.drawCircle(
          Offset(treeNode.point.x, treeNode.point.y), treeNode.r, _paint);
    });
    if (branch.childs != null && branch.childs.isNotEmpty) {
      branch.childs.forEach((Branch branch) {
        drawBranch(branch, canvas, size);
      });
    }
    if (branch.leaf != null) {
      canvas.save();
      canvas.translate(branch.endNode.point.x, branch.endNode.point.y);
      _paint.color = tree.color;
      for (int i = 0; i < branch.leaf.petals; i++) {
        canvas.rotate(2 * Math.pi / 5);
        canvas.drawCircle(Offset(branch.leaf.r, 0), branch.leaf.r, _paint);
      }
      _paint.color = Colors.white;
      canvas.drawCircle(Offset(0, 0), branch.leaf.r*scale / 2, _paint);
      drawImage(canvas, size, branch.leaf.r*scale / 2);
      canvas.restore();
    }
  }

  void drawImage(Canvas canvas, Size size, double r) {
    if (image != null) {
     // canvas.translate(size.width/2, size.height/2);
      Rect src = Rect.fromCircle(
          center:
              Offset(image.width.toDouble() / 2, image.height.toDouble() / 2),
          radius: r);
      Rect dst = Rect.fromCircle(center: Offset(0, 0), radius: r);
      Path path=Path();
      path.addOval(dst);
     canvas.clipPath(path);
      canvas.drawImageRect(image, src, dst, _paint);
    }
  }

  static Future<ui.Image> getImage(String asset) async {
    ByteData data = await rootBundle.load(asset);
    Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }
}

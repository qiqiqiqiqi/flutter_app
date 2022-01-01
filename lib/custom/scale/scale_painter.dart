import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

class ScalePainter extends CustomPainter {
  ui.Image image;
  Paint _paint;
  double scale;
  Offset offset;

  ScalePainter({this.image, this.scale = 1, this.offset}) {
    _init();
  }

  void _init() {
    _paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    print('ScalePainter--paint():size=$size,image=$image');
    canvas.save();
    drawImage(size, canvas);
    canvas.restore();
  }

  void drawImage(Size size, Canvas canvas) {
    canvas.save();
    if (image != null) {
      canvas.translate(size.width / 2, size.height / 2);
      canvas.clipRect(Rect.fromLTRB(
          -size.width / 2, -size.height / 2, size.width / 2, size.height / 2));
      canvas.scale(scale, scale);
      canvas.translate(offset.dx, offset.dy);
      Rect srcRect =
          Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble());
      double imageWHRatio = image.width / image.height;
      double widgetWHRatio = size.width / size.height;
      double left, top, right, bottom;
      if (image.width <= size.width && image.height <= size.height) {
        //图片内容在Widget的范围内
        left = -image.width / 2;
        top = -image.height / 2;
        right = image.width / 2;
        bottom = image.height / 2;
      } else if (imageWHRatio >= widgetWHRatio) {
        double imageW = size.width;
        double imageH = imageW / imageWHRatio;
        left = -imageW / 2;
        top = -imageH / 2;
        right = imageW / 2;
        bottom = imageH / 2;
      } else {
        double imageH = size.height;
        double imageW = imageH * imageWHRatio;
        left = -imageW / 2;
        top = -imageH / 2;
        right = imageW / 2;
        bottom = imageH / 2;
      }
      Rect dstRect = Rect.fromLTRB(left, top, right, bottom);
      canvas.drawImageRect(image, srcRect, dstRect, _paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

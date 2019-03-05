import 'package:flutter/material.dart';
import 'dart:math' as Math;

class BezierWavePainter extends CustomPainter {
  double waveHeight;
  double wavePeak = 30;
  double offSetX;

  @override
  void paint(Canvas canvas, Size size) {
    waveHeight = size.height / 2;
    offSetX = 0;
    double waveLength = size.width / 2;
    int waveCount = (size.width / waveLength).ceil() + 1;
    Path path = Path();
    path.moveTo(-waveLength + offSetX, waveHeight);
    for (int i = 0; i <= waveCount; i++) {
      path.quadraticBezierTo(
          -3 / 4 * waveLength + i * waveLength + offSetX,
          waveHeight + wavePeak,
          -2 / 4 * waveLength + i * waveLength + offSetX,
          waveHeight);

      path.quadraticBezierTo(-1 / 4 * waveLength + i * waveLength + offSetX,
          waveHeight - wavePeak, i * waveLength + offSetX, waveHeight);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(-waveLength + offSetX, size.height);
    path.close();
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = Colors.redAccent;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

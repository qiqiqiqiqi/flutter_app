import 'dart:async';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';

class BezierWavePainter extends CustomPainter {
  double waveHeight;
  double wavePeak;
  double offSetX1;
  double offSetX2;
  ui.Image image;
  double progress;

  BezierWavePainter(
      {this.waveHeight,
      this.wavePeak,
      this.offSetX1,
      this.offSetX2,
      this.image,
      this.progress})
      : assert(waveHeight != null ||
            wavePeak != null ||
            offSetX1 != null ||
            offSetX2 != null);

  @override
  void paint(Canvas canvas, Size size) {
    drawWave(canvas, size, offSetX1, Colors.blueAccent[100], true);
    drawWave(canvas, size, offSetX1, Colors.blueAccent[100], false);
    drawWave(canvas, size, offSetX2, Colors.blueAccent, false);
    drawCenter(canvas, size);
  }

  void drawWave(
      Canvas canvas, Size size, double offSetX, Color color, bool draw) {
    canvas.save();
    canvas.clipRect(Rect.fromLTRB(0, 0, size.width, size.height));
    double waveLength = size.width / 2;
    int waveCount = (size.width / waveLength).ceil() + 1;
    Path path = Path();
    path.moveTo(-waveLength + offSetX, waveHeight);
    for (int i = 0; i < waveCount; i++) {
      path.quadraticBezierTo(
          -3 / 4 * waveLength + i * waveLength + offSetX,
          waveHeight + wavePeak,
          -2 / 4 * waveLength + i * waveLength + offSetX,
          waveHeight);
      path.quadraticBezierTo(
        -1 / 4 * waveLength + i * waveLength + offSetX,
        waveHeight - wavePeak,
        i * waveLength + offSetX,
        waveHeight,
      );
    }

    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = color;

    if (draw && image != null) {
      final PathMetrics pathMetrics = path.computeMetrics(forceClosed: false);
      final PathMetric pathMetric = pathMetrics.elementAt(0);
      double length = pathMetric.length;
      Path extractPath = pathMetric.extractPath(offSetX1 - waveLength,
          length * (size.width / (waveCount * waveLength)) /*+ offSetX1*/);
      paint.style = PaintingStyle.stroke;
      canvas.drawPath(extractPath, paint);
      Tangent tangentForOffset =
          pathMetric.getTangentForOffset(length * progress);
      Offset position = tangentForOffset.position;
      double angle = tangentForOffset.angle;
      canvas.translate(position.dx, position.dy);
      canvas.rotate(-angle);
      canvas.drawImageRect(
          image,
          Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
          Rect.fromLTRB(-20, -20 - 2 * wavePeak / 3, 20, 20 - 2 * wavePeak / 3),
          paint);
      print(
        "drawWave():position=${position},"
        "angle=$angle,"
        "progress=$progress,"
        "extractPath=${extractPath.computeMetrics().elementAt(0).length},"
        "width=${size.width}",
      );
    } else {
      path.lineTo(size.width + offSetX, size.height);
      path.lineTo(-waveLength + offSetX, size.height);
      path.close();
      canvas.drawPath(path, paint);
    }
    canvas.restore();
  }

  void drawCenter(Canvas canvas, Size size) {
    canvas.save();
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: "偶的人生全靠浪...",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold)));
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(size.width / 2 - textPainter.size.width / 2,
            size.height - textPainter.size.height / 2 - 50));
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  static AssetBundle getAssetBundle() => (rootBundle != null)
      ? rootBundle
      : new NetworkAssetBundle(new Uri.directory(Uri.base.origin));

//  static Future<ui.Image> load(String url) async {
//    ImageStream stream = new AssetImage(url, bundle: getAssetBundle())
//        .resolve(ImageConfiguration.empty);
//    Completer<ui.Image> completer = new Completer<ui.Image>();
//    void listener(ImageInfo frame, bool synchronousCall) {
//      ui.Image image = frame.image;
//      completer.complete(image);
//      stream.removeListener(listener);
//    }
//
//    stream.addListener(listener);
//    return completer.future;
//  }

  static Future<ui.Image> getImage(String asset) async {
    ByteData data = await rootBundle.load(asset);
    Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }
}

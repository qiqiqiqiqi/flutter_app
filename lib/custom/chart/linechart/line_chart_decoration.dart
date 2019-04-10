import 'package:flutter/material.dart';
import 'dart:math' as Math;

class ChartDecoration<T> extends Decoration {
  final double itemWith;
  final ScrollController scrollController;
  final List<T> datas;
  final double leftPadding;
  final double rightPadding;

  ChartDecoration(
      {this.itemWith,
      this.scrollController,
      this.datas,
      this.leftPadding,
      this.rightPadding});

  @override
  BoxPainter createBoxPainter([onChanged]) {
    return ChartDecorationBoxPainter(
        itemWith, scrollController, datas, leftPadding, rightPadding);
  }
}

class ChartDecorationBoxPainter<T> extends BoxPainter {
  double itemWith;
  ScrollController scrollController;
  int firstVisiablePosition;
  int lastVisiablePosition;
  int childCount;
  double offsetX;
  Path path = Path();
  List<T> datas;
  double leftPadding;
  double rightPadding;

  ChartDecorationBoxPainter(this.itemWith, this.scrollController, this.datas,
      this.leftPadding, this.rightPadding);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    double pixels = scrollController.position.pixels;
    double extentBefore = scrollController.position.extentBefore;
    double extentInside = scrollController.position.extentInside;
    double extentAfter = scrollController.position.extentAfter;
    offsetX = pixels % itemWith;
    childCount =
        (configuration.size.width - leftPadding - rightPadding) ~/ itemWith;
    firstVisiablePosition =
        (pixels ~/ itemWith) + ((offsetX - itemWith).abs() < 0.1 ? 1 : 0);
    lastVisiablePosition = firstVisiablePosition + childCount;
    if (lastVisiablePosition > datas.length - 1) {
      lastVisiablePosition = datas.length - 1;
    }
    //offsetX=46.857142857142854,itemWith=46.857142857142854 当offsetX十分接近itemWith时置offsetX=0
    if ((offsetX - itemWith).abs() < 0.001) {
      offsetX = 0;
    }
    print(
        'ChartDecorationBoxPainter:paint():firstVisiablePosition=$firstVisiablePosition,lastVisiablePosition=$lastVisiablePosition,childCount=$childCount,offsetX=$offsetX');
    print(
        'ChartDecorationBoxPainter:paint():pixels=$pixels,extentBefore=$extentBefore,extentInside=$extentInside,extentAfter=$extentAfter');
    print('ChartDecorationBoxPainter:paint():itemWith=$itemWith,offset=$offset,'
        'configuration.size=${configuration.size}');

    drawChart(canvas, offset, configuration.size);
  }

  void drawChart(Canvas canvas, Offset offset, Size size) {
    canvas.translate(0, offset.dy);
    canvas.clipRect(
        Rect.fromLTRB(leftPadding, 0, size.width - rightPadding, size.height));
    //canvas.drawColor(Colors.orange, BlendMode.difference);
    drawPath(canvas, size);
    drawPoints(canvas, size);
    drawLine(canvas, size);
  }

  void drawPath(Canvas canvas, Size size) {
    canvas.save();
    path.reset();
    LinearGradient linearGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[Colors.blueAccent, Colors.blueAccent[100]]);
    Paint paint = Paint()..isAntiAlias = true;
    int startPosition = firstVisiablePosition > 0
        ? firstVisiablePosition - 1
        : firstVisiablePosition;
    int endPosition = lastVisiablePosition < (datas.length - 1)
        ? lastVisiablePosition + 1
        : lastVisiablePosition;

    for (int position = startPosition; position <= endPosition; position++) {
      if (position == startPosition) {
        path.moveTo(getLeft(position) + itemWith / 2,
            size.height * (datas[position] as double));
      } else {
        path.lineTo(getLeft(position) + itemWith / 2,
            size.height * (datas[position] as double));
      }
    }
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.blueAccent;
    canvas.drawPath(path, paint);

    paint
      ..style = PaintingStyle.fill
      ..shader = linearGradient
          .createShader(Rect.fromLTRB(0, 0, size.width, size.height));
    path.lineTo(getLeft(endPosition) + itemWith / 2, size.height);
    path.lineTo(getLeft(startPosition) + itemWith / 2, size.height);
    path.close();
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  double getLeft(int position) {
    int scrollPosition = scrollController.position.pixels ~/ itemWith;
    if ((scrollController.position.pixels % itemWith - itemWith).abs() < 0.1) {
      scrollPosition = scrollPosition + 1;
    }
    double left =
        (position - scrollPosition) * itemWith - offsetX + leftPadding;
    print(
        "ChartDecorationBoxPainter:getLeft():left=$left,position=$position,position - scrollController.position.pixels ~/ itemWith=${position - scrollController.position.pixels ~/ itemWith},offsetX=$offsetX");
    return left;
  }

  void drawPoints(Canvas canvas, Size size) {
    canvas.save();
    Paint paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 2
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    for (int position = firstVisiablePosition;
        position <= lastVisiablePosition;
        position++) {
      canvas.drawCircle(
          Offset(getLeft(position) + itemWith / 2,
              size.height * (datas[position] as double)),
          4,
          paint);
    }
    canvas.restore();
  }

  void drawLine(Canvas canvas, Size size) {
    canvas.save();
    Paint paint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 1
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    double spaceHeight = size.height / 5;
    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
          Offset(leftPadding, size.height - spaceHeight * i),
          Offset(size.width - rightPadding, size.height - spaceHeight * i),
          paint);
    }
    canvas.restore();
  }
}

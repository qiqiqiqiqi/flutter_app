import 'package:flutter/material.dart';

class ChartDecoration<T> extends Decoration {
  final double itemWith;
  final ScrollController scrollController;
  final List<T> datas;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;
  final double animationValue;

  ChartDecoration(
      {this.itemWith,
      this.scrollController,
      this.datas,
      this.leftPadding = 0,
      this.rightPadding = 0,
      this.topPadding = 0,
      this.bottomPadding = 0,
      this.animationValue = 1});

  @override
  BoxPainter createBoxPainter([onChanged]) {
    return ChartDecorationBoxPainter(
        itemWith: itemWith,
        scrollController: scrollController,
        datas: datas,
        leftPadding: leftPadding,
        rightPadding: rightPadding,
        topPadding: topPadding,
        bottomPadding: bottomPadding,
        animationValue: animationValue);
  }
}

class ChartDecorationBoxPainter<T> extends BoxPainter {
  static final double DETA = 0.5;
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
  double topPadding;
  double bottomPadding;
  double animationValue;

  ChartDecorationBoxPainter(
      {this.itemWith,
      this.scrollController,
      this.datas,
      this.leftPadding,
      this.rightPadding,
      this.topPadding,
      this.bottomPadding,
      this.animationValue});

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
        (pixels ~/ itemWith) + ((offsetX - itemWith).abs() < DETA ? 1 : 0);
    lastVisiablePosition = firstVisiablePosition + childCount;
    if (lastVisiablePosition > datas.length - 1) {
      lastVisiablePosition = datas.length - 1;
    }
    //offsetX=46.857142857142854,itemWith=46.857142857142855 当offsetX十分接近itemWith时置offsetX=0
    if ((offsetX - itemWith).abs() < DETA) {
      offsetX = 0;
    }
    print(
        'ChartDecorationBoxPainter:paint():firstVisiablePosition=$firstVisiablePosition,lastVisiablePosition=$lastVisiablePosition,childCount=$childCount,offsetX=$offsetX');
    print(
        'ChartDecorationBoxPainter:paint():pixels=$pixels,extentBefore=$extentBefore,extentInside=$extentInside,extentAfter=$extentAfter');
    print('ChartDecorationBoxPainter:paint():itemWith=$itemWith,offset=$offset,'
        'configuration.size=${configuration.size}');

    drawChart(canvas, offset, configuration.size);
    drawCoordinate(canvas, offset, configuration.size);
  }

  void drawChart(Canvas canvas, Offset offset, Size size) {
    canvas.save();
    size = Size(size.width - leftPadding - rightPadding,
        size.height - topPadding - bottomPadding);
    canvas.translate(
        leftPadding, offset.dy + topPadding); //这里统一处理偏移数据，画图时面向size
    canvas.clipRect(
        Rect.fromLTRB(0, -topPadding, size.width, size.height + bottomPadding));

    /* canvas.translate(0, offset.dy);
    canvas.clipRect(
        Rect.fromLTRB(leftPadding, 0, size.width - rightPadding, size.height));*/

    // canvas.drawColor(Colors.orange, BlendMode.difference);
    drawPath(canvas, size);
    drawPoints(canvas, size);
    drawLine(canvas, size);
    canvas.restore();
  }

  void drawPath(Canvas canvas, Size size) {
    canvas.save();
    path.reset();
    LinearGradient linearGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[Color(0xFFffb0bb), Color(0xFFffc1a2)]);
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
            size.height * (1 - (datas[position] as double) * animationValue));
      } else {
        path.lineTo(getLeft(position) + itemWith / 2,
            size.height * (1 - (datas[position] as double) * animationValue));
      }
    }
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Color(0xFFddc5fe);
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
    if ((scrollController.position.pixels % itemWith - itemWith).abs() < DETA) {
      scrollPosition = scrollPosition + 1;
    }
    double left =
        (position - scrollPosition) * itemWith - offsetX /*+ leftPadding*/;
    print(
        "ChartDecorationBoxPainter:getLeft():left=$left,position=$position,position - scrollController.position.pixels ~/ itemWith=${position - scrollController.position.pixels ~/ itemWith},offsetX=$offsetX");
    return left;
  }

  void drawPoints(Canvas canvas, Size size) {
    canvas.save();
    Paint paint = Paint()
      ..color = Color(0xFFddc5fe)
      ..strokeWidth = 2
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    for (int position = firstVisiablePosition;
        position <= lastVisiablePosition;
        position++) {
      canvas.drawCircle(
          Offset(getLeft(position) + itemWith / 2,
              size.height * (1 - (datas[position] as double) * animationValue)),
          4,
          paint);
    }
    canvas.restore();
  }

  void drawLine(Canvas canvas, Size size) {
    canvas.save();
    Paint paint = Paint()
      ..color = Color(0xFFddc5fe)
      ..strokeWidth = 1
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    double spaceHeight = size.height / 5;
    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
          Offset(/*leftPadding*/ 0, size.height - spaceHeight * i),
          Offset(size.width /*- rightPadding*/, size.height - spaceHeight * i),
          paint);
    }
    canvas.restore();
  }

  void drawCoordinate(Canvas canvas, Offset offset, Size size) {
    canvas.save();
    canvas.translate(leftPadding, offset.dy);
    double spaceHeight = (size.height - topPadding - bottomPadding) / 5;
    for (int i = 0; i < 5; i++) {
      TextPainter textPainter = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(
              text: '$i',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold)));
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(
              -leftPadding / 2 - textPainter.size.width / 2,
              size.height -
                  bottomPadding -
                  i * spaceHeight -
                  textPainter.size.height / 2));
    }

    canvas.clipRect(Rect.fromLTRB(
        0, 0, size.width - rightPadding - leftPadding, size.height));
    for (int position = firstVisiablePosition;
        position <= lastVisiablePosition;
        position++) {
      if (position % 5 == 0) {
        TextPainter textPainter = TextPainter(
            textDirection: TextDirection.ltr,
            text: TextSpan(
                text: '$position',
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold)));
        textPainter.layout();
        textPainter.paint(
            canvas,
            Offset(
                getLeft(position) + itemWith / 2 + -textPainter.size.width / 2,
                size.height - bottomPadding / 2 - textPainter.size.height / 2));
      }
    }
    canvas.restore();
  }
}

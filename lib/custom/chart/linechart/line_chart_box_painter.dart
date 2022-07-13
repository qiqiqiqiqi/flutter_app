import 'package:flutter/material.dart';

import 'line_chart_data.dart';

abstract class BaseChartDecorationBoxPainter extends BoxPainter {
  static final double DETA = 0.5;
  double itemWidth;
  ScrollController scrollController;
  int firstVisiablePosition;
  int lastVisiablePosition;
  int childCount;
  double offsetX;
  List<ChartData> datas;
  double leftPadding;
  double rightPadding;
  double topPadding;
  double bottomPadding;
  double animationValue;
  List<double> minMaxChartData;
  int levels;

  BaseChartDecorationBoxPainter(
      {this.itemWidth,
      this.scrollController,
      this.datas,
      this.leftPadding,
      this.rightPadding,
      this.topPadding,
      this.bottomPadding,
      this.animationValue,
      this.levels = 4});

  /// paint方法的Offset offset参数表示控件左上角的位置。
  /// configuration.size 可以得到控件的宽高。
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    double pixels = scrollController.position.pixels;
    double extentBefore = scrollController.position.extentBefore;
    double extentInside = scrollController.position.extentInside;
    double extentAfter = scrollController.position.extentAfter;
    offsetX = pixels % itemWidth;
    childCount =
        (configuration.size.width - leftPadding - rightPadding) ~/ itemWidth;
    firstVisiablePosition = (pixels ~/ itemWidth) +
        ((offsetX - itemWidth).abs() < BaseChartDecorationBoxPainter.DETA
            ? 1
            : 0);
    lastVisiablePosition = firstVisiablePosition + childCount;
    if (lastVisiablePosition > datas.length - 1) {
      lastVisiablePosition = datas.length - 1;
    }
    //offsetX=46.857142857142854,itemWith=46.857142857142855 当offsetX十分接近itemWith时置offsetX=0
    if ((offsetX - itemWidth).abs() < BaseChartDecorationBoxPainter.DETA) {
      offsetX = 0;
    }
    print(
      'BaseChartDecorationBoxPainter--paint():'
      'firstVisiablePosition=$firstVisiablePosition,'
      'lastVisiablePosition=$lastVisiablePosition,'
      'childCount=$childCount,'
      'offsetX=$offsetX',
    );
    print(
      'BaseChartDecorationBoxPainter--paint():'
      'pixels=$pixels,'
      'extentBefore=$extentBefore,'
      'extentInside=$extentInside,'
      'extentAfter=$extentAfter',
    );
    print(
      'BaseChartDecorationBoxPainter--paint():'
      'itemWith=$itemWidth,'
      'offset=$offset,'
      'configuration.size=${configuration.size}',
    );
    minMaxChartData = getMinMaxChartData();
    drawCoordinate(canvas, offset, configuration.size);
    _drawContent(canvas, offset, configuration.size);
  }

  ///item 相对内容区域左边的位置
  double getLeft(int position) {
    int scrollPosition = scrollController.position.pixels ~/ itemWidth;
    if ((scrollController.position.pixels % itemWidth - itemWidth).abs() <
        BaseChartDecorationBoxPainter.DETA) {
      scrollPosition = scrollPosition + 1;
    }
    double left = (position - scrollPosition) * itemWidth - offsetX;
    print("BaseChartDecorationBoxPainter--getLeft():"
        "left=$left,position=$position,"
        "position - scrollController.position.pixels ~/ itemWith=${position - scrollController.position.pixels ~/ itemWidth}"
        ",offsetX=$offsetX");
    return left;
  }

  double getHeightRatio(int position) {
    return ((datas[position].dataValue - minMaxChartData.first) /
            (minMaxChartData.last - minMaxChartData.first)) *
        animationValue;
  }

  List<ChartData> getVisiableRangeDatas() {
    int startPosition = firstVisiablePosition > 0
        ? firstVisiablePosition - 1
        : firstVisiablePosition;
    int endPosition = lastVisiablePosition < (datas.length - 1)
        ? lastVisiablePosition + 1
        : lastVisiablePosition;
    return datas?.sublist(startPosition, endPosition);
  }

  ///绘制坐标
  void drawCoordinate(Canvas canvas, Offset offset, Size size) {
    canvas.save();
    canvas.translate(leftPadding, offset.dy);
    _drawVertical(canvas, size, levels);
    drawHorizontal(canvas, size);
    canvas.restore();
  }

  void drawHorizontal(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTRB(
        0, 0, size.width - rightPadding - leftPadding, size.height));
    for (int position = firstVisiablePosition;
        position <= lastVisiablePosition;
        position++) {
      if ((childCount > 10 && position % 5 == 0) ||
          (childCount <= 10 && position % 2 == 0)) {
        drawText(
            canvas,
            '$position',
            Offset(getLeft(position) + itemWidth / 2,
                size.height - bottomPadding / 2));
      }
    }
  }

  void _drawVertical(Canvas canvas, Size size, int levels) {
    double spaceHeight = (size.height - topPadding - bottomPadding) / levels;
    for (int i = 0; i <= levels; i++) {
      Offset textOffset = Offset(
          -leftPadding / 2, size.height - bottomPadding - i * spaceHeight);
      drawVerticalScale(canvas, i, textOffset);
    }
  }

  void drawVerticalScale(Canvas canvas, int i, Offset offset) {
    String text =
        '${((i * ((minMaxChartData.last - minMaxChartData.first) / levels) + minMaxChartData.first) * 1).toInt()}';
    drawText(canvas, text, offset);
  }

  List<double> getMinMaxChartData() {
    List<double> minMaxChartData = List();
    List<ChartData> visiableRangeDatas = getVisiableRangeDatas();
    visiableRangeDatas.sort((ChartData data1, ChartData data2) {
      return data1.dataValue.compareTo(data2.dataValue);
    });
    double minChartData = visiableRangeDatas.first.dataValue;
    double maxChartData = visiableRangeDatas.last.dataValue;
    if (minChartData == maxChartData) {
      minChartData = minChartData - minChartData / 10;
      maxChartData = maxChartData + maxChartData / 10;
    } else {
      if (minChartData > (maxChartData - minChartData) / 10) {
        minChartData = minChartData - (maxChartData - minChartData) / 10;
      } else {
        minChartData = minChartData - minChartData / 10;
      }
      maxChartData = maxChartData + (maxChartData - minChartData) / 10;
    }
    minMaxChartData.add(minChartData);
    minMaxChartData.add(maxChartData);
    return minMaxChartData;
  }

  void drawText(Canvas canvas, String text, Offset offset) {
    TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: '$text',
            style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 16.0,
                fontWeight: FontWeight.bold)));
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(offset.dx - textPainter.size.width / 2,
            offset.dy - textPainter.size.height / 2));
  }

  void _drawContent(Canvas canvas, Offset offset, Size size) {
    canvas.save();
    Size contentSize = Size(size.width - leftPadding - rightPadding,
        size.height - topPadding - bottomPadding);
    canvas.translate(
        leftPadding, offset.dy + topPadding); //这里统一处理偏移数据，画图时面向size
    canvas.clipRect(Rect.fromLTRB(
        0, -topPadding, contentSize.width, contentSize.height + bottomPadding));

    //canvas.drawColor(Colors.orange, BlendMode.difference);

    drawChart(canvas, contentSize);
    drawLine(canvas, contentSize);
    canvas.restore();
  }

  ///绘制纵轴的刻度线
  void drawLine(Canvas canvas, Size size) {
    canvas.save();
    Paint paint = Paint()
      ..color = Color(0xFFddc5fe)
      ..strokeWidth = 1
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;
    double spaceHeight = size.height / 4;
    for (int i = 0; i <= 4; i++) {
      canvas.drawLine(Offset(0, size.height - spaceHeight * i),
          Offset(size.width, size.height - spaceHeight * i), paint);
    }
    canvas.restore();
  }

  ///绘制图表内容
  void drawChart(Canvas canvas, Size size);
}

/// 折线图
class LineChartDecorationBoxPainter extends BaseChartDecorationBoxPainter {
  bool bezier;
  Path path = Path();

  LineChartDecorationBoxPainter(
      {double itemWidth,
      ScrollController scrollController,
      List<ChartData> datas,
      double leftPadding,
      double rightPadding,
      double topPadding,
      double bottomPadding,
      double animationValue,
      this.bezier = false})
      : super(
            itemWidth: itemWidth,
            scrollController: scrollController,
            datas: datas,
            leftPadding: leftPadding,
            rightPadding: rightPadding,
            topPadding: topPadding,
            bottomPadding: bottomPadding,
            animationValue: animationValue);

  @override
  void drawChart(Canvas canvas, Size size) {
    if (animationValue == 0) {
      return;
    }
    canvas.save();
    drawPath(canvas, size);
    drawPoints(canvas, size);
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
        path.moveTo(getLeft(position) + itemWidth / 2,
            size.height * (1 - getHeightRatio(position)));
      } else {
        if (!bezier) {
          path.lineTo(getLeft(position) + itemWidth / 2,
              size.height * (1 - getHeightRatio(position)));
        } else {
          Offset perPositionOffset = Offset(
              getLeft(position - 1) + itemWidth / 2,
              size.height * (1 - getHeightRatio(position - 1)));
          Offset currPositionOffset = Offset(getLeft(position) + itemWidth / 2,
              size.height * (1 - getHeightRatio(position)));
          Offset c_1 = Offset(
              (perPositionOffset.dx + currPositionOffset.dx) / 2,
              perPositionOffset.dy);
          Offset c_2 = Offset(
              (perPositionOffset.dx + currPositionOffset.dx) / 2,
              currPositionOffset.dy);
          path.cubicTo(c_1.dx, c_1.dy, c_2.dx, c_2.dy, currPositionOffset.dx,
              currPositionOffset.dy);
        }
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
    path.lineTo(getLeft(endPosition) + itemWidth / 2, size.height);
    path.lineTo(getLeft(startPosition) + itemWidth / 2, size.height);
    path.close();
    canvas.drawPath(path, paint);
    canvas.restore();
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
          Offset(getLeft(position) + itemWidth / 2,
              size.height * (1 - getHeightRatio(position))),
          4,
          paint);
    }
    canvas.restore();
  }
}

///直方图
class BarChartDecorationBoxPainter extends BaseChartDecorationBoxPainter {
  bool circula;

  BarChartDecorationBoxPainter(
      {double itemWidth,
      ScrollController scrollController,
      List<ChartData> datas,
      double leftPadding,
      double rightPadding,
      double topPadding,
      double bottomPadding,
      double animationValue,
      this.circula = false})
      : super(
            itemWidth: itemWidth,
            scrollController: scrollController,
            datas: datas,
            leftPadding: leftPadding,
            rightPadding: rightPadding,
            topPadding: topPadding,
            bottomPadding: bottomPadding,
            animationValue: animationValue);

  @override
  void drawChart(Canvas canvas, Size size) {
    canvas.save();
    drawBar(canvas, size);
    canvas.restore();
  }

  void drawBar(Canvas canvas, Size size) {
    canvas.save();
    LinearGradient linearGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[Color(0xFFffb0bb), Color(0xFFffc1a2)]);
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..shader = linearGradient
          .createShader(Rect.fromLTRB(0, 0, size.width, size.height));
    for (int position = firstVisiablePosition;
        position <= lastVisiablePosition;
        position++) {
      Rect rect = Rect.fromLTRB(
          getLeft(position) + itemWidth / 2 - 8,
          (1 - getHeightRatio(position)) * size.height,
          getLeft(position) + itemWidth / 2 + 8,
          size.height);
      if (circula) {
        RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(8));
        canvas.drawRRect(rRect, paint);
      } else {
        canvas.drawRect(rect, paint);
      }
    }
    canvas.restore();
  }
}

///点图
class PointChartDecorationBoxPainter extends BaseChartDecorationBoxPainter {
  List<String> levelStrings;
  int minValue, maxValue;

  PointChartDecorationBoxPainter(
      {double itemWidth,
      ScrollController scrollController,
      List<ChartData> datas,
      double leftPadding,
      double rightPadding,
      double topPadding,
      double bottomPadding,
      double animationValue,
      int levels,
      this.minValue,
      this.maxValue,
      this.levelStrings})
      : super(
            itemWidth: itemWidth,
            scrollController: scrollController,
            datas: datas,
            leftPadding: leftPadding,
            rightPadding: rightPadding,
            topPadding: topPadding,
            bottomPadding: bottomPadding,
            animationValue: animationValue,
            levels: levels);

  @override
  void drawChart(Canvas canvas, Size size) {
    drawPoint(canvas, size);
  }

  @override
  void drawVerticalScale(Canvas canvas, int i, Offset offset) {
    drawText(canvas, levelStrings[i], offset);
  }

  @override
  double getHeightRatio(int position) {
    return ((datas[position].dataValue - minValue) / (maxValue - minValue)) *
        animationValue;
  }

  void drawPoint(Canvas canvas, Size size) {
    canvas.save();
    LinearGradient linearGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          Colors.red,
          Colors.redAccent,
          Colors.green,
          Colors.blue,
          Colors.blueAccent
        ]);
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..shader = linearGradient
          .createShader(Rect.fromLTRB(0, 0, size.width, size.height));
    for (int position = firstVisiablePosition;
        position <= lastVisiablePosition;
        position++) {
      Offset offset = Offset(getLeft(position) + itemWidth / 2,
          (1 - getHeightRatio(position)) * size.height);
      canvas.drawCircle(offset, 4, paint);
    }
    canvas.restore();
  }
}

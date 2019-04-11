import 'package:flutter/material.dart';
import 'line_chart_box_painter.dart';

enum ChartType {
  LINE, //折线图
  GRAPH, //曲线图
  BAR, //直方图
  CIRCULAR_BAR, //圆角直方图
}

class LineChartDecoration<T> extends Decoration {
  final double itemWidth;
  final ScrollController scrollController;
  final List<T> datas;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;
  final double animationValue;
  final ChartType chartType;

  LineChartDecoration(
      {this.itemWidth,
      this.scrollController,
      this.datas,
      this.leftPadding = 0,
      this.rightPadding = 0,
      this.topPadding = 0,
      this.bottomPadding = 0,
      this.animationValue = 1,
      this.chartType = ChartType.LINE});

  @override
  BoxPainter createBoxPainter([onChanged]) {
    BaseChartDecorationBoxPainter baseChartDecorationBoxPainter;
    switch (chartType) {
      case ChartType.LINE:
        baseChartDecorationBoxPainter = LineChartDecorationBoxPainter(
            itemWidth: itemWidth,
            scrollController: scrollController,
            datas: datas,
            leftPadding: leftPadding,
            rightPadding: rightPadding,
            topPadding: topPadding,
            bottomPadding: bottomPadding,
            animationValue: animationValue,
            bezier: false);
        break;
      case ChartType.GRAPH:
        baseChartDecorationBoxPainter = LineChartDecorationBoxPainter(
            itemWidth: itemWidth,
            scrollController: scrollController,
            datas: datas,
            leftPadding: leftPadding,
            rightPadding: rightPadding,
            topPadding: topPadding,
            bottomPadding: bottomPadding,
            animationValue: animationValue,
            bezier: true);
        break;
      case ChartType.CIRCULAR_BAR:
        break;
      case ChartType.BAR:
        break;
      default:
        baseChartDecorationBoxPainter = LineChartDecorationBoxPainter(
            itemWidth: itemWidth,
            scrollController: scrollController,
            datas: datas,
            leftPadding: leftPadding,
            rightPadding: rightPadding,
            topPadding: topPadding,
            bottomPadding: bottomPadding,
            animationValue: animationValue,
            bezier: false);
        break;
    }
    return baseChartDecorationBoxPainter;
  }
}

import 'package:flutter/material.dart';
import 'line_chart_box_painter.dart';
import 'line_chart_data.dart';

enum ChartType {
  LINE, //折线图
  GRAPH, //曲线图
  BAR, //直方图
  R_BAR, //圆角直方图
  POINT, //圆角直方图
}

class LineChartDecoration extends Decoration {
  final double itemWidth;
  final ScrollController scrollController;
  final List<ChartData> datas;
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
            bezier: chartType == ChartType.GRAPH);
        break;
      case ChartType.R_BAR:
      case ChartType.BAR:
        baseChartDecorationBoxPainter = BarChartDecorationBoxPainter(
            itemWidth: itemWidth,
            scrollController: scrollController,
            datas: datas,
            leftPadding: leftPadding,
            rightPadding: rightPadding,
            topPadding: topPadding,
            bottomPadding: bottomPadding,
            animationValue: animationValue,
            circula: chartType == ChartType.R_BAR);
        break;
      case ChartType.POINT:
        List<String> levelStrings = <String>['无损', '轻微', '一般', '较严重', '严重'];
        baseChartDecorationBoxPainter = PointChartDecorationBoxPainter(
            itemWidth: itemWidth,
            scrollController: scrollController,
            datas: datas,
            leftPadding: leftPadding,
            rightPadding: rightPadding,
            topPadding: topPadding,
            bottomPadding: bottomPadding,
            animationValue: animationValue,
            levelStrings: levelStrings,
            levels: levelStrings.length - 1,
            minValue: 0,
            maxValue: levelStrings.length - 1);
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

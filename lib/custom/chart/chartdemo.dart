import 'package:flutter/material.dart';
import 'dart:math' as Math;
import 'linechart/line_chart.dart';
import 'linechart/line_chart_decoration.dart';
import 'linechart/line_chart_data.dart';

main() {
  runApp(ChartDemo());
}

class ChartDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChartDemoState();
  }
}

class ChartDemoState extends State<ChartDemo> {
  List<ChartData> datas;
  final int childCount = 7;

  @override
  void initState() {
    super.initState();
    datas = List.generate(1000, (int position) {
      return ChartData()..dataValue = Math.Random().nextDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "chart demo",
      home: Scaffold(
        appBar: AppBar(
          title: Text("chart demo"),
        ),
        body: LineChart(
          childCount: childCount,
          chartType: ChartType.GRAPH,
          datas: datas,
          leftPadding: 32,
          topPadding: 16,
          rightPadding: 16,
          bottomPadding: 32,
        ),
      ),
    );
  }
}

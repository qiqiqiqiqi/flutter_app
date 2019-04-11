import 'package:flutter/material.dart';
import 'dart:math' as Math;
import 'linechart/line_chart.dart';

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
  List<double> datas;
  final int childCount = 7;

  @override
  void initState() {
    super.initState();
    datas = List.generate(1000, (int position) {
      return Math.Random().nextDouble();
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
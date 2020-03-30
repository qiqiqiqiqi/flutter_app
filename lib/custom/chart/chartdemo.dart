import 'package:flutter/material.dart';
import 'package:flutter_app/custom/tree/treeUtil.dart';
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
  final int childCount = 15;
  ChartType chartType = ChartType.POINT;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() {
    if (chartType != ChartType.POINT) {
      datas = List.generate(1000, (int position) {
        //return ChartData()..dataValue = Math.Random().nextDouble();
        return ChartData()..dataValue = TreeUtil.random(70, 80)/*Math.Random().nextDouble()*/;
      });
    } else {
      datas = List.generate(1000, (int position) {
        return ChartData()..dataValue = (Math.Random().nextDouble() * 4).ceilToDouble();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "chart demo",
      home: Scaffold(
        appBar: AppBar(
          title: Text("chart demo"),
        ),
        body: Column(
          children: <Widget>[
            LineChart(
              childCount: childCount,
              chartType: chartType,
              datas: datas,
              leftPadding: chartType == ChartType.POINT ? 56 :56,
              topPadding: 16,
              rightPadding: 16,
              bottomPadding: 32,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Wrap(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        chartType = ChartType.LINE;
                        refresh();
                      });
                    },
                    child: Text("折线"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        chartType = ChartType.GRAPH;
                        refresh();
                      });
                    },
                    child: Text("曲线"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        chartType = ChartType.BAR;
                        refresh();
                      });
                    },
                    child: Text("直方图"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        chartType = ChartType.R_BAR;
                        refresh();
                      });
                    },
                    child: Text("圆角直方图"),
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        chartType = ChartType.POINT;
                        refresh();
                      });
                    },
                    child: Text("点图"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

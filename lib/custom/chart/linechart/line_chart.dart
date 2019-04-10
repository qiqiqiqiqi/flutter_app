import 'package:flutter/material.dart';
import 'line_chart_decoration.dart';

class LineChart<T> extends StatefulWidget {
  final int childCount;
  final List<T> datas;

  LineChart({this.childCount, this.datas});

  @override
  State<StatefulWidget> createState() {
    return LineChartState();
  }
}

class LineChartState extends State<LineChart> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double itemWith = (constraints.maxWidth - 32) / widget.childCount;
      return Container(
        foregroundDecoration: ChartDecoration(
            itemWith: itemWith,
            scrollController: scrollController,
            datas: widget.datas,
            leftPadding: 16,
            rightPadding: 16),
        height: 300,
        child: NotificationListener(
            onNotification: (ScrollNotification scrollNotification) {
              setState(() {});
            },
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              controller: scrollController,
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  width: itemWith,
                  /*child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Center(
                        child: Text('$index'),
                      )),
                      Container(
                        color: Colors.grey,
                        width: 1,
                      )
                    ],
                  ),*/
                );
              },
              scrollDirection: Axis.horizontal,
              itemCount: widget.datas.length,
            )),
      );
    });
  }
}

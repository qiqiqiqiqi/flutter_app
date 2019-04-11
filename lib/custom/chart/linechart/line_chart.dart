import 'package:flutter/material.dart';
import 'line_chart_decoration.dart';

class LineChart<T> extends StatefulWidget {
  final int childCount;
  final List<T> datas;
  double leftPadding;
  double rightPadding;
  double topPadding;
  double bottomPadding;

  LineChart(
      {this.childCount,
      this.datas,
      this.leftPadding = 0,
      this.rightPadding = 0,
      this.topPadding = 0,
      this.bottomPadding = 0});

  @override
  State<StatefulWidget> createState() {
    return LineChartState();
  }
}

class LineChartState extends State<LineChart> with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  double animationValue = 1;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
    Animation curvedAnimation = CurvedAnimation(parent: animationController, curve: ElasticOutCurve(1.0));
    animationController.forward();
    curvedAnimation.addListener(() {
      setState(() {
        animationValue = curvedAnimation.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double itemWidth =
          (constraints.maxWidth - (widget.leftPadding + widget.rightPadding)) /
              widget.childCount;
      return Container(
        foregroundDecoration: LineChartDecoration(
            itemWidth: itemWidth,
            scrollController: scrollController,
            datas: widget.datas,
            leftPadding: widget.leftPadding,
            rightPadding: widget.rightPadding,
            topPadding: widget.topPadding,
            bottomPadding: widget.bottomPadding,
            animationValue: animationValue),
        height: 300,
        child: NotificationListener(
            onNotification: (ScrollNotification scrollNotification) {
              setState(() {});
            },
            child: ListView.builder(
              padding: EdgeInsets.only(
                  left: widget.leftPadding,
                  top: widget.topPadding,
                  right: widget.rightPadding,
                  bottom: widget.bottomPadding),
              controller: scrollController,
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  width: itemWidth,
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

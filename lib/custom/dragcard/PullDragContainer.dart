import 'package:flutter/material.dart';
import 'PullController.dart';

class PullDragContiner extends StatefulWidget {
  Widget headWidget, contentWidget;

  PullDragContiner({this.headWidget, this.contentWidget});

  @override
  State<StatefulWidget> createState() {
    return PullDragState();
  }
}

class PullDragState extends State<PullDragContiner>
    with SingleTickerProviderStateMixin {
  double offsetY = 0;
  PullController pullController;

  @override
  void initState() {
    pullController = PullController(this,
        onOffsetYChange: onOffsetYChange, onRefresh: onRefresh);
    super.initState();
  }

  onOffsetYChange(double offsetY) {
    setState(() {
      this.offsetY = offsetY;
    });
  }

  onRefresh() {
    print("onRefresh():");
    //todo
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: Stack(
        children: <Widget>[
          Positioned(
              height: 100,
              top: -(100 - offsetY),
              left: 0,
              right: 0,
              child: widget.headWidget),
          Positioned(
              bottom: -offsetY,
              top: offsetY,
              left: 0,
              right: 0,
              child: widget.contentWidget)
        ],
      ),
    );
  }

  void onPanUpdate(DragUpdateDetails dragUpdateDetails) {
    setState(() {
      offsetY = pullController.caculatePullHeight(
          dragUpdateDetails.delta.dy, TouchState.touch);
      print("PullDragContiner:onPanUpdate():offsetY=$offsetY");
    });
  }

  void onPanEnd(DragEndDetails dragEndDetails) {
    print("PullDragContiner:onPanEnd():offsetY=$offsetY");
    pullController.caculatePullHeight(0, TouchState.no_touch);
  }
}

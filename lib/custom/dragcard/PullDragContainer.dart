import 'package:flutter/material.dart';
import 'PullController.dart';
import 'custom_gesture_detector.dart';
import 'custom_drag_gesture_recognizer.dart';

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
  bool isOpen = false;

  @override
  void initState() {
    pullController = PullController(this,
        onOffsetYChange: onOffsetYChange, onRefresh: onRefresh);
    super.initState();
  }

  onOffsetYChange(double offsetY, PullState pullState) {
    setState(() {
      this.offsetY = offsetY;
      this.isOpen = pullState == PullState.pull_refreshing;
      print("onOffsetYChange():offsetY=${this.offsetY}");
    });
  }

  onRefresh() {
    print("onRefresh():");
    //todo
  }

  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      direction: Direction.bottom|Direction.top,
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
              child: AbsorbPointer(
                child: widget.contentWidget,
                absorbing: isOpen,
              ))
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

import 'package:flutter/material.dart';
import 'PullController.dart';
import 'custom_gesture_detector.dart';
import 'custom_drag_gesture_recognizer.dart';
import 'pullHeadContainer.dart';
import 'DragCardContentContainer.dart';

main() {
  runApp(MaterialApp(
    home: PullDragContiner(),
  ));
}

typedef OnRefresh = void Function();

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
  PullState currentPullState = PullState.pull_close;
  bool isOpen = false;

  @override
  void initState() {
    pullController = PullController(this,
        onOffsetYChange: onOffsetYChange,
        onRefresh: onRefresh,
        onStateChange: onStateChange);
    super.initState();
  }

  onOffsetYChange(double offsetY) {
    setState(() {
      this.offsetY = offsetY;
      print("onOffsetYChange():offsetY=${this.offsetY}");
    });
  }

  onRefresh() {
    print("onRefresh():");
  }

  onStateChange(PullState pullState) {
    setState(() {
      this.isOpen = pullState == PullState.pull_refreshing;
      currentPullState = pullState;
      print("onStateChange:currentPullState=$currentPullState");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFD8D8D8),
      appBar: AppBar(),
      body: CustomGestureDetector(
        direction: Direction.bottom | Direction.top,
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        child: Stack(
          children: <Widget>[
            Positioned(
                height: PullController.REFRESH_HEIGHT,
                top: -(PullController.REFRESH_HEIGHT - offsetY),
                left: 0,
                right: 0,
                child: PullHeadContainer(
                    pullState: currentPullState) /*widget.headWidget*/),
            Positioned(
                bottom: -offsetY,
                top: offsetY,
                left: 0,
                right: 0,
                child: AbsorbPointer(
                  child: PullContentContainer() /*widget.contentWidget*/,
                  absorbing: isOpen,
                ))
          ],
        ),
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

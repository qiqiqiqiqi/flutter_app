import 'package:flutter/material.dart';
import 'PullController.dart';
import 'dart:math' as Math;

class PullHeadContainer extends StatefulWidget {
  PullState pullState;

  @override
  State<StatefulWidget> createState() {
    return PullHeadContainerState();
  }

  PullHeadContainer({this.pullState});
}

class PullHeadContainerState extends State<PullHeadContainer>
    with SingleTickerProviderStateMixin {
  double rotateAngle = 0.0;
  AnimationController animationController;
  PullState currentPullState;

  @override
  void initState() {
    super.initState();
    currentPullState = widget.pullState;
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    print("PullHeadContainer--initState():pullState=${widget.pullState}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
     /* color: Colors.cyan,*/
      child: Center(
        child: buildHeadWidget(widget.pullState),
      ),
    );
  }

  void startAnimation(PullState pullState) {
    print(
        "PullHeadContainer--startAnimation():pullState=${widget.pullState},currentPullState=$currentPullState,rotateAngle=$rotateAngle");
    if (currentPullState != null && currentPullState == pullState) {
      return;
    }
    animationController.stop();
    rotateAngle = 0.0;
    if (pullState == PullState.pull_refreshing ||
        pullState == PullState.pull_refreshing_hide) {
      currentPullState = pullState;
      animationController.duration = Duration(milliseconds: 1000);
      Tween tween = Tween(begin: 0, end: 2 * Math.pi);
      Animation animate = tween.animate(animationController);
      animate.addStatusListener((AnimationStatus animationStatus) {
        if (animationStatus == AnimationStatus.forward) {}
      });
      animate.addListener(() {
        setState(() {
          rotateAngle = animate.value;
          print("PullHeadContainer--pull_refreshing:rotateAngle=$rotateAngle");
        });
      });
      animationController.repeat();
    } else if (pullState == PullState.pull_refresh &&
        currentPullState == PullState.pull_release) {
      currentPullState = pullState;
      animationController.duration = Duration(milliseconds: 200);
      Tween tween = Tween(begin: 0.0, end: -Math.pi);
      Animation animate = tween.animate(animationController);
      animate.addStatusListener((AnimationStatus animationStatus) {
        if (animationStatus == AnimationStatus.forward) {}
      });
      animate.addListener(() {
        setState(() {
          rotateAngle = animate.value;
          print("PullHeadContainer--pull_refresh:rotateAngle=$rotateAngle");
        });
      });
      animationController.reverse();
    } else if (pullState == PullState.pull_release) {
      currentPullState = pullState;
      animationController.duration = Duration(milliseconds: 200);
      Tween tween = Tween(begin: 0.0, end: Math.pi);
      Animation animate = tween.animate(animationController);
      animate.addStatusListener((AnimationStatus animationStatus) {
        if (animationStatus == AnimationStatus.forward) {}
      });
      animate.addListener(() {
        setState(() {
          rotateAngle = animate.value;
          print("PullHeadContainer--pull_release:rotateAngle=$rotateAngle");
        });
      });
      animationController.forward(from: 0.0);
    }
  }

  Widget buildHeadWidget(PullState pullState) {
    Map statusMap = Map();
    if (pullState == PullState.pull_refreshing ||
        pullState == PullState.pull_refreshing_hide) {
      statusMap['leftIcon'] = 'images/refresh_arrow_loading.png';
      statusMap['rightText'] = '正在刷新';
    } else if (pullState == PullState.pull_release) {
      statusMap['leftIcon'] = 'images/refresh_arrow_down.png';
      statusMap['rightText'] = '释放刷新';
    } else {
      statusMap['leftIcon'] = 'images/refresh_arrow_down.png';
      statusMap['rightText'] = '下拉刷新';
    }
    startAnimation(pullState);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Transform.rotate(
            angle: rotateAngle,
            child: Image.asset(
              statusMap['leftIcon'],
              width: 16,
              height: 16,
            )),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "${statusMap['rightText']}",
            style: TextStyle(color: Colors.blueGrey, fontSize: 16),
          ),
        )
      ],
    );
  }
}

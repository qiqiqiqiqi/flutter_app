import 'package:flutter/material.dart';
import 'dart:math' as Math;
import 'base_refresh_head.dart';
import 'refresh_state.dart';

class DefualtRefreshHead extends BaseRefreshHead {
  @override
  State<StatefulWidget> createState() {
    return DefualtRefreshHeadState();
  }

  DefualtRefreshHead();
}

class DefualtRefreshHeadState extends BaseRefreshHeadState<DefualtRefreshHead>
    with SingleTickerProviderStateMixin {
  double rotateAngle = 0.0;
  AnimationController animationController;
  RefreshState currentRefreshState = RefreshState.pull_reset;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      /* color: Colors.cyan,*/
      child: Center(
        child: buildHeadWidget(currentRefreshState),
      ),
    );
  }

  void startAnimation(RefreshState pullState) {

    animationController.stop();
    if (pullState == RefreshState.pull_refreshing) {
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
    } else if (pullState == RefreshState.pull_release_to_refresh) {
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
      animationController.forward();
    } else {
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
    }
  }

  @override
  void onRefreshState(RefreshState refreshState, double offsetY) {
    print(
        "DefualtRefreshHead:onRefreshState():refreshState=$refreshState,offsetY=$offsetY");
    switch (refreshState) {
      case RefreshState.pull_release_to_refresh:
        break;
      case RefreshState.pull_refreshing:
        break;
      case RefreshState.pull_reset:
        break;
    }
    if (currentRefreshState != refreshState) {
      setState(() {
        currentRefreshState = refreshState;
      });
    }
  }

  Widget buildHeadWidget(RefreshState pullState) {
    Map statusMap = Map();
    if (pullState == RefreshState.pull_refreshing) {
      statusMap['leftIcon'] = 'images/refresh_arrow_loading.png';
      statusMap['rightText'] = '正在刷新';
    } else if (pullState == RefreshState.pull_release_to_refresh) {
      statusMap['leftIcon'] = 'images/refresh_arrow_down.png';
      statusMap['rightText'] = '释放刷新';
    } else {
      statusMap['leftIcon'] = 'images/refresh_arrow_down.png';
      statusMap['rightText'] = '下拉刷新';
    }
    startAnimation(pullState);
    return Container(
      height: 60,
      child: Row(
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
      ),
    );
  }
}

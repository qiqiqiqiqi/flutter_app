import 'package:flutter/material.dart';

typedef OnOffsetYChange = void Function(double offsetY);
typedef OnRefresh = void Function();

class PullController {
  static const double REFRESH_HEIGHT = 100;
  double offsetY = 0;
  OnOffsetYChange onOffsetYChange;
  OnRefresh onRefresh;
  PullState currentPullState = PullState.pull_refresh;
  AnimationController animationController;

  PullController(TickerProvider tickerProvider,
      {this.onOffsetYChange, this.onRefresh}) {
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: tickerProvider);
  }

  void caculateCurrentState(TouchState touchState) {
//    if (currentPullState == PullState.pull_refreshing) {
//      return;
//    }
    if (offsetY < REFRESH_HEIGHT) {
      currentPullState = PullState.pull_refresh;
      if (touchState == TouchState.no_touch) {
        smoothClose();
      }
    } else {
      if (touchState == TouchState.touch) {
        currentPullState = PullState.pull_release;
      } else {
        currentPullState = PullState.pull_refreshing;
        if (onRefresh != null) {
          onRefresh();
        }
        smoothToRefresh();
      }
    }
  }

  double caculatePullHeight(double dy, TouchState touchState) {
    if (touchState == TouchState.touch) {
      if (offsetY < 20) {
        offsetY += dy * 9 / 10;
      } else if (offsetY < 40) {
        offsetY += dy * 8 / 10;
      } else if (offsetY < 60) {
        offsetY += dy * 7 / 10;
      } else if (offsetY < 80) {
        offsetY += dy * 6 / 10;
      } else if (offsetY < 100) {
        offsetY += dy * 5 / 10;
      } else {
        offsetY += dy * 1 / 10;
      }
    }
    caculateCurrentState(touchState);
    return offsetY;
  }

  smoothOpen() {
    if (offsetY == REFRESH_HEIGHT) {
      return;
    }
    animationController.value = offsetY / REFRESH_HEIGHT;
    animationController?.forward();
  }

  smoothClose() {
    if (offsetY == 0.0 || animationController == null) {
      return;
    }
    print("smoothClose():offsetY=$offsetY");
    animationController.duration = Duration(milliseconds: 200);
    Animation<double> animation =
        Tween(begin: offsetY, end: 0.0).animate(animationController);
    animation
      ..addListener(() {
        offsetY = animation.value;
        onOffsetYChange(offsetY);
        print("PullController:addListener():offsetY=$offsetY");
      })
      ..addStatusListener((AnimationStatus animationStatus) {
        if (animationStatus == AnimationStatus.completed) {
          if (currentPullState == PullState.pull_refreshing) {}
        }
      });
    animationController.forward(from: 0);
  }

  smoothToRefresh() {
    if (offsetY <= REFRESH_HEIGHT || animationController == null) {
      return;
    }
    print("smoothToRefresh():offsetY=$offsetY");
    animationController.duration = Duration(milliseconds: 200);
    Animation<double> animation =
        Tween(begin: offsetY, end: REFRESH_HEIGHT).animate(animationController);
    animation
      ..addListener(() {
        offsetY = animation.value;
        if (onOffsetYChange != null) {
          onOffsetYChange(offsetY);
        }
        print("PullController:addListener():offsetY=$offsetY");
      })
      ..addStatusListener((AnimationStatus animationStatus) {
        if (animationStatus == AnimationStatus.completed) {}
      });
    animationController.forward(from: 0);
  }
}

enum PullState {
  ///下拉刷新
  pull_refresh,

  ///释放刷新
  pull_release,

  ///正在刷新
  pull_refreshing
}

enum TouchState {
  ///
  touch,

  ///
  no_touch
}

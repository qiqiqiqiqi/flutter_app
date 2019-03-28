import 'package:flutter/material.dart';
import 'dart:math' as Math;

typedef OnOffsetYChange = void Function(double offsetY);
typedef OnRefresh = void Function();
typedef OnStateChange = void Function(PullState pullState);

class PullController {
  static const double REFRESH_HEIGHT = 50;
  double offsetY = 0;
  OnOffsetYChange onOffsetYChange;
  OnRefresh onRefresh;
  OnStateChange onStateChange;
  PullState currentPullState = PullState.pull_refresh;
  AnimationController animationController;

  PullController(TickerProvider tickerProvider,
      {this.onOffsetYChange, this.onRefresh, this.onStateChange}) {
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: tickerProvider);
  }

  void judgeCurrentState(TouchState touchState, PullState pullState) {
    if (currentPullState != PullState.pull_refreshing &&
        currentPullState != PullState.pull_refreshing_hide) {
      if (offsetY > 0 && offsetY < REFRESH_HEIGHT) {
        currentPullState = PullState.pull_refresh;
        if (touchState == TouchState.no_touch) {
          smoothClose();
        }
      } else if (offsetY >= REFRESH_HEIGHT) {
        if (touchState == TouchState.touch) {
          currentPullState = PullState.pull_release;
        } else {
          if (onRefresh != null) {
            onRefresh();
          }
          smoothToRefresh();
        }
      } else if (offsetY <= 0) {
        currentPullState = PullState.pull_close;
      }
    } else {
      if (offsetY >= REFRESH_HEIGHT) {
        if (touchState == TouchState.no_touch) {
          smoothToRefresh();
        }
      } else if (offsetY <= 0) {
        currentPullState = PullState.pull_refreshing_hide;
      }
    }
    if (currentPullState != pullState) {
      onStateChange(currentPullState);
    }
  }

  double caculatePullHeight(double dy, TouchState touchState) {
    if (touchState == TouchState.touch) {
//      if (offsetY < REFRESH_HEIGHT / 10) {
//        offsetY += dy * 9 / 10;
//      } else if (offsetY < REFRESH_HEIGHT * 2 / 10) {
//        offsetY += dy * 8 / 10;
//      } else if (offsetY < REFRESH_HEIGHT * 3 / 10) {
//        offsetY += dy * 7 / 10;
//      } else if (offsetY < REFRESH_HEIGHT * 4 / 10) {
//        offsetY += dy * 6 / 10;
//      } else if (offsetY < REFRESH_HEIGHT * 5 / 10) {
//        offsetY += dy * 5 / 10;
//      } else {
//        offsetY += dy * 1 / 10;
//      }
      offsetY += dy;
    }
    if (offsetY <= 0) {
      offsetY = 0;
    }
    judgeCurrentState(touchState, currentPullState);
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
          currentPullState = PullState.pull_close;
          onStateChange(currentPullState);
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
        if (animationStatus == AnimationStatus.completed) {
          currentPullState = PullState.pull_refreshing;
          onStateChange(currentPullState);
        }
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
  pull_refreshing,

  ///关闭
  pull_close,
  pull_refreshing_hide,
}

enum TouchState {
  ///
  touch,

  ///
  no_touch
}

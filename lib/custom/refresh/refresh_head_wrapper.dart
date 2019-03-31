import 'package:flutter/material.dart';
import 'package:flutter_app/custom/refresh/refresh_state.dart';
import 'refresh_observer.dart';
import 'PullController.dart';

typedef HeadBuilder = Widget Function(BuildContext context);

class RefreshHeadWrapper extends StatefulWidget {
  HeadBuilder headBuilder;
  double height;
  PullController pullController;

  RefreshHeadWrapper({Key key, this.headBuilder, this.height})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RefreshHeadState();
  }
}

class RefreshHeadState extends State<RefreshHeadWrapper>
    with TickerProviderStateMixin, RefreshObserve {
  AnimationController animationController;
  RefreshObserver refreshObserver;

  @override
  void initState() {
    super.initState();
    refreshObserver = RefreshObserver();
    animationController = AnimationController(
        vsync: this,
        lowerBound: 0.000001,
        duration: Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizeTransition(
              sizeFactor: animationController,
              child: Container(height: widget.height)),
          HeadContainerInheritedWidget(
              child: widget.headBuilder(context),
              refreshObserver: refreshObserver)
        ],
      ),
    );
  }

  @override
  void onRefreshState(RefreshState refreshState, double offsetY) {
    print(
        "RefreshHeadWrapper:onRefreshState():refreshState=$refreshState,offsetY=$offsetY");
    switch (refreshState) {
      case RefreshState.pull_release_to_refresh:
        break;
      case RefreshState.pull_refreshing:
        animationController.duration = Duration(milliseconds: 1);
        animationController.animateTo(1);
        break;
      case RefreshState.pull_reset:
        animationController.duration = Duration(milliseconds: 200);
        animationController.animateTo(0);
        break;
    }
    refreshObserver.notifyStateChange(refreshState, offsetY);
  }
}

class HeadContainerInheritedWidget extends InheritedWidget {
  RefreshObserver refreshObserver;

  static HeadContainerInheritedWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(HeadContainerInheritedWidget);
  }

  HeadContainerInheritedWidget({Key key, Widget child, this.refreshObserver})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(HeadContainerInheritedWidget oldWidget) {
    return refreshObserver != oldWidget.refreshObserver;
  }
}

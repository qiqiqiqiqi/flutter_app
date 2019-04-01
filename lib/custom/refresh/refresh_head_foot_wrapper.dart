import 'package:flutter/material.dart';
import 'package:flutter_app/custom/refresh/refresh_state.dart';
import 'refresh_observer.dart';

typedef HeadFootBuilder = Widget Function(BuildContext context);

class BaseRefreshWrapper extends StatefulWidget {
  HeadFootBuilder headFootBuilder;
  double height;

  BaseRefreshWrapper({Key key, this.headFootBuilder, this.height})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RefreshHeadFootState();
  }
}

class RefreshHeadFootState extends State<BaseRefreshWrapper>
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
      child: buildHeadFootWidget(context),
    );
  }

  Widget buildHeadFootWidget(BuildContext context) {
    if (widget is RefreshHeadWrapper) {
      return Column(
        children: <Widget>[
          SizeTransition(
              sizeFactor: animationController,
              child: Container(height: widget.height)),
          HeadFootContainerInheritedWidget(
              child: widget.headFootBuilder(context),
              refreshObserver: refreshObserver)
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          HeadFootContainerInheritedWidget(
              child: widget.headFootBuilder(context),
              refreshObserver: refreshObserver),
          SizeTransition(
              sizeFactor: animationController,
              child: Container(height: widget.height))
        ],
      );
    }
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
      case RefreshState.pull_release_to_load:
        break;
      case RefreshState.pull_loading:
        animationController.duration = Duration(milliseconds: 1);
        animationController.animateTo(1);
        break;
      case RefreshState.pull_reset:
        animationController.duration = Duration(milliseconds: 200);
        animationController.animateTo(0);
        break;
      default:
        break;
    }
    refreshObserver.notifyStateChange(refreshState, offsetY);
  }
}

class RefreshHeadWrapper extends BaseRefreshWrapper {
  RefreshHeadWrapper({Key key, HeadFootBuilder headFootBuilder, double height})
      : super(key: key, headFootBuilder: headFootBuilder, height: height);
}

class RefreshFootWrapper extends BaseRefreshWrapper {
  RefreshFootWrapper({Key key, HeadFootBuilder headFootBuilder, double height})
      : super(key: key, headFootBuilder: headFootBuilder, height: height);
}

class HeadFootContainerInheritedWidget extends InheritedWidget {
  RefreshObserver refreshObserver;

  static HeadFootContainerInheritedWidget of(BuildContext context) {
    return context
        .inheritFromWidgetOfExactType(HeadFootContainerInheritedWidget);
  }

  HeadFootContainerInheritedWidget(
      {Key key, Widget child, this.refreshObserver})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(HeadFootContainerInheritedWidget oldWidget) {
    return refreshObserver != oldWidget.refreshObserver;
  }
}

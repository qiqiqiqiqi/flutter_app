import 'package:flutter/material.dart';
import 'package:flutter_app/custom/refresh/refresh_state.dart';
import 'refresh_observer.dart';
import 'refresh_head_foot_wrapper.dart';

class BaseRefreshHead extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return null;
  }
}

abstract class BaseRefreshHeadState<T extends StatefulWidget> extends State<T>
    with RefreshObserve {
  HeadFootContainerInheritedWidget headContainerInheritedWidget;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    headContainerInheritedWidget = HeadFootContainerInheritedWidget.of(context);
    if (headContainerInheritedWidget != null &&
        headContainerInheritedWidget.refreshObserver != null) {
      headContainerInheritedWidget.refreshObserver.subscribe(this);
    }
  }

  @override
  void dispose() {
    headContainerInheritedWidget = HeadFootContainerInheritedWidget.of(context);
    if (headContainerInheritedWidget != null &&
        headContainerInheritedWidget.refreshObserver != null) {
      headContainerInheritedWidget.refreshObserver.unsubscribe(this);
    }
    super.dispose();
  }

  @override
  void onRefreshState(RefreshState refreshState, double offsetY) {

  }
}

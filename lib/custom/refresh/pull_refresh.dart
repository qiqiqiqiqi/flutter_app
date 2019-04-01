import 'package:flutter/material.dart';
import 'refresh_head_wrapper.dart';
import 'refresh_observer.dart';
import 'refresh_state.dart';
import 'custom_scroll_physics.dart' as custom;

typedef Future<void> OnRefresh();

class PullRefresh extends StatefulWidget {
  HeadBuilder headBuilder;
  ScrollView child;
  OnRefresh onRefresh;

  PullRefresh({this.headBuilder, this.child, this.onRefresh});

  @override
  State<StatefulWidget> createState() {
    return PullRefreshState();
  }
}

class PullRefreshState extends State<PullRefresh>
    with TickerProviderStateMixin {
  double offsetY = 0;
  GlobalKey headGlobalKey = GlobalKey();
  double headHeight = 0;
  double scrollY = 0;
  double offsetHeight = 0;
  ScrollController scrollController;
  AnimationController animationController;
  AnimationController animationController_size;
  RefreshState currentRefreshState;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    animationController_size =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    scrollController = ScrollController();
    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((Duration duration) {
      setState(() {
        headHeight = headGlobalKey.currentContext.size.height;
        offsetY = -headHeight;
        offsetHeight = headHeight;
        var maxScrollExtent = scrollController.position.maxScrollExtent;
        if (maxScrollExtent > 0) {}
        print(
            "initState():headHeight=$headHeight,maxScrollExtent=$maxScrollExtent");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets =
        List.from(widget.child.buildSlivers(context), growable: true);
    widgets.insert(
        0,
        SliverToBoxAdapter(
            child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                RefreshHeadWrapper(
                  key: headGlobalKey,
                  headBuilder: widget.headBuilder,
                  height: headHeight,
                )
              ],
            )
          ],
        )));
    if (scrollController.positions.isNotEmpty &&scrollController.position!=null&&
        scrollController.position.maxScrollExtent > 0) {
      widgets.add(SliverToBoxAdapter(
          child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              RefreshHeadWrapper(
                headBuilder: widget.headBuilder,
                height: headHeight,
              )
            ],
          )
        ],
      )));
    }
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(
        children: <Widget>[
          Positioned(
              left: 0,
              right: 0,
              top: offsetY,
              bottom: 0,
              child: NotificationListener(
                child: CustomScrollView(
                    physics: custom.BouncingScrollPhysics(),
                    controller: scrollController,
                    slivers: widgets),
                onNotification: (ScrollNotification scrollNotification) {
                  handleScrollNotification(scrollNotification);
                },
              ))
        ],
      );
    });
  }

  handleScrollNotification(ScrollNotification scrollNotification) {
    print(
        "handleScrollNotification():currentRefreshState=$currentRefreshState");
    RefreshObserve refreshObserve =
        headGlobalKey.currentState as RefreshObserve;
    double extentInside = scrollNotification.metrics.extentInside;
    double maxScrollExtent = scrollNotification.metrics.maxScrollExtent;
    double minScrollExtent = scrollNotification.metrics.minScrollExtent;
    double pixels = scrollNotification.metrics.pixels;
    double viewportHeight = extentInside;
    if (pixels < 0) {
      viewportHeight = viewportHeight - pixels;
    }
    double offset = viewportHeight - extentInside;
    if (scrollNotification is ScrollStartNotification) {
      print("handleScrollNotification():ScrollStartNotification");
    } else if (scrollNotification is ScrollUpdateNotification) {
      DragUpdateDetails dragUpdateDetails = scrollNotification.dragDetails;

      if (offset > headHeight) {
        if (dragUpdateDetails == null) {
          currentRefreshState = RefreshState.pull_refreshing;

          // 调用刷新接口
          Future onRefresh = widget.onRefresh();
          onRefresh.whenComplete(() {
            currentRefreshState = RefreshState.pull_reset;
            refreshObserve.onRefreshState(RefreshState.pull_reset, offset);
          });
        } else if (currentRefreshState != RefreshState.pull_refreshing) {
          currentRefreshState = RefreshState.pull_release_to_refresh;
        }
        print(
            "handleScrollNotification():ScrollUpdateNotification:offsetHeight=$offsetHeight,headHeight=$headHeight");
      } else {
        if (dragUpdateDetails != null &&
            currentRefreshState != RefreshState.pull_refreshing) {
          currentRefreshState = RefreshState.pull_reset;
        }
      }
    } else if (scrollNotification is ScrollEndNotification) {
      if (currentRefreshState == RefreshState.pull_refreshing) {}
    } else if (scrollNotification is OverscrollNotification) {
      //CustomScrollView设置BouncingScrollPhysics后无OverscrollNotification
      print("handleScrollNotification():OverscrollNotification");
    } else if (scrollNotification is UserScrollNotification) {
      print("handleScrollNotification():UserScrollNotification");
    }
    refreshObserve.onRefreshState(currentRefreshState, offset);
    if (currentRefreshState == RefreshState.pull_refreshing) {
      //scrollController.jumpTo(0);

    }
  }
}

import 'package:flutter/material.dart';
import 'refresh_head_foot_wrapper.dart';
import 'refresh_observer.dart';
import 'refresh_state.dart';
import 'custom_scroll_physics.dart' as custom;
import 'package:flutter/gestures.dart';

typedef Future<void> OnRefresh();
typedef Future<void> OnLoadMore();

class PullRefresh extends StatefulWidget {
  HeadFootBuilder headBuilder;
  HeadFootBuilder footBuilder;
  ScrollView child;
  OnRefresh onRefresh;
  OnLoadMore onLoadMore;

  PullRefresh(
      {this.headBuilder,
      this.footBuilder,
      this.onRefresh,
      this.onLoadMore,
      this.child});

  @override
  State<StatefulWidget> createState() {
    return PullRefreshState();
  }
}

class PullRefreshState extends State<PullRefresh>
    with TickerProviderStateMixin {
  GlobalKey headGlobalKey = GlobalKey();
  GlobalKey footGlobalKey = GlobalKey();
  GlobalKey listGlobalKey = GlobalKey();
  double headHeight = 0;
  double footHeight = 0;
  ScrollController scrollController;
  AnimationController animationController;
  RefreshState currentRefreshState;
  double viewPortHeight = 0.0;
  double listHeight = 0.0;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    scrollController = ScrollController();
    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callBack) {
      listHeight = listGlobalKey.currentContext.size.height;
      print("initState():listHeight=$listHeight");
    });
    widgetsBinding.addPersistentFrameCallback((Duration duration) {
      if (headGlobalKey.currentContext != null) {
        double headHeight = headGlobalKey.currentContext.size.height;
        if (this.headHeight == 0 && headHeight != 0) {
          setState(() {
            this.headHeight = headHeight;
          });
        }
      }
      if (footGlobalKey.currentContext != null) {
        double footHeight = footGlobalKey.currentContext.size.height;
        if (this.footHeight == 0 && footHeight != 0) {
          setState(() {
            this.footHeight = footHeight;
          });
        }
      }

      print("initState():headHeight=$headHeight,footHeight=$footHeight");
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies()");
    super.didChangeDependencies();
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
                  headFootBuilder: widget.headBuilder,
                  height: headHeight,
                )
              ],
            )
          ],
        )));

    if (scrollController.positions.isNotEmpty &&
        scrollController.position != null &&
        scrollController.position.maxScrollExtent > 0) {
      double maxScrollExtent = scrollController.position.maxScrollExtent;
      print("build():"
          "currentRefreshState=$currentRefreshState,"
          "extentInside=${scrollController.position.extentInside},"
          "extentBefore=${scrollController.position.extentBefore},"
          "extentAfter=${scrollController.position.extentAfter},"
          "pixels=${scrollController.position.pixels},"
          "maxScrollExtent=${scrollController.position.maxScrollExtent},"
          "minScrollExtent=${scrollController.position.minScrollExtent},"
          "outOfRange=${scrollController.position.outOfRange},"
          "atEdge=${scrollController.position.atEdge},"
          "offset=${scrollController.offset}");
      widgets.add(SliverToBoxAdapter(
          child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              RefreshFootWrapper(
                key: footGlobalKey,
                headFootBuilder: widget.footBuilder,
                height: footHeight,
              )
            ],
          )
        ],
      )));
    }
    return Column(
      children: <Widget>[
        Expanded(
            child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              top: -headHeight,
              bottom: -footHeight,
              child: NotificationListener(
                key: listGlobalKey,
                child: CustomScrollView(
                    physics: custom.BouncingScrollPhysics(),
                    controller: scrollController,
                    slivers: widgets),
                onNotification: (ScrollNotification scrollNotification) {
                  handleScrollNotification(scrollNotification);
                },
              ),
            )
          ],
        ))
      ],
    );
  }

  handleScrollNotification(ScrollNotification scrollNotification) {
    double extentInside = scrollNotification.metrics.extentInside;
    double maxScrollExtent = scrollNotification.metrics.maxScrollExtent;
    double minScrollExtent = scrollNotification.metrics.minScrollExtent;
    bool outOfRange = scrollNotification.metrics.outOfRange; //是否越界
    bool atEdge = scrollNotification.metrics.atEdge; //是否在边界
    double pixels = scrollNotification.metrics.pixels;
    double offset = 0;

    ///pixels<0时，下拉；outOfRange==true
    ///pixels>maxScrollExtent时，上拉；outOfRange==true
    if (outOfRange) {
      if (pixels < 0) {
        offset = pixels;
      } else if (pixels > maxScrollExtent) {
        offset = pixels - maxScrollExtent;
      }
    }

    print("handleScrollNotification():scrollNotification=$scrollNotification,"
        "currentRefreshState=$currentRefreshState,"
        "extentInside=$extentInside,"
        "pixels=$pixels,"
        "maxScrollExtent=$maxScrollExtent,"
        "minScrollExtent=$minScrollExtent,"
        "outOfRange=$outOfRange,"
        "atEdge=$atEdge,"
        "offset=$offset,"
        "footHeight=$footHeight,"
        "headHeight=$headHeight");
    if (scrollNotification is ScrollUpdateNotification) {
      DragUpdateDetails dragUpdateDetails = scrollNotification.dragDetails;
      if (offset < 0 && currentRefreshState != RefreshState.pull_loading) {
        RefreshObserve refreshObserve =
            headGlobalKey.currentState as RefreshObserve;
        if (offset.abs() > headHeight) {
          if (dragUpdateDetails == null &&
              currentRefreshState != RefreshState.pull_refreshing) {
            currentRefreshState = RefreshState.pull_refreshing;
            // 调用刷新接口
            Future onRefresh = widget.onRefresh();
            onRefresh.whenComplete(() {
              currentRefreshState = RefreshState.pull_reset;
              refreshObserve?.onRefreshState(RefreshState.pull_reset, offset);
            });
          } else if (currentRefreshState != RefreshState.pull_refreshing) {
            currentRefreshState = RefreshState.pull_release_to_refresh;
          }
        } else {
          if (dragUpdateDetails != null &&
              currentRefreshState != RefreshState.pull_refreshing) {
            currentRefreshState = RefreshState.pull_reset;
          }
        }
        refreshObserve?.onRefreshState(currentRefreshState, offset);
      } else if (currentRefreshState != RefreshState.pull_refreshing) {
        RefreshObserve refreshObserve =
            footGlobalKey.currentState as RefreshObserve;
        if (offset > footHeight) {
          if (maxScrollExtent > 0 &&
              dragUpdateDetails == null &&
              currentRefreshState != RefreshState.pull_loading) {
            currentRefreshState = RefreshState.pull_loading;
            // 调用加载更多接口
            Future onRefresh = widget.onLoadMore();
            onRefresh.whenComplete(() {
              currentRefreshState = RefreshState.pull_reset;
              refreshObserve?.onRefreshState(RefreshState.pull_reset, offset);
            });
          } else if (currentRefreshState != RefreshState.pull_loading) {
            currentRefreshState = RefreshState.pull_release_to_load;
          }
        } else {
          if (dragUpdateDetails != null &&
              currentRefreshState != RefreshState.pull_loading) {
            currentRefreshState = RefreshState.pull_reset;
          }
        }
        refreshObserve?.onRefreshState(currentRefreshState, offset);
      }
    }
  }
}

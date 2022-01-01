import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('refresh_sliver'),
        ),
        body: RefreshContainer(
          onRefresh: () async {
            print('RefreshContainer-----------------onRefresh()');
            return Future.delayed(Duration(seconds: 5));
          },
        ),
      ),
    ),
  );
}

typedef OnRefresh = Future Function();

class RefreshContainer extends StatefulWidget {
  final OnRefresh onRefresh;

  RefreshContainer({this.onRefresh});

  @override
  State<StatefulWidget> createState() {
    return RefreshContainerState();
  }
}

class RefreshContainerState extends State<RefreshContainer> {
  ScrollController _scrollController;
  final ValueNotifier<RefreshState> _refreshStateNotifier =
      ValueNotifier(RefreshState.IDLE);
  static const double HEAD_HEIGHT = 100;

  @override
  void initState() {
    super.initState();
    setState(() {});
    _scrollController = ScrollController(initialScrollOffset: 0);
    _refreshStateNotifier.addListener(() async {
      print(
          'RefreshContainerState--initState():refreshState=${_refreshStateNotifier.value}');
      if (_refreshStateNotifier.value == RefreshState.PREPARING_REFRESH) {
        dynamic result = await widget.onRefresh();
        _refreshStateNotifier.value = RefreshState.IDLE;
        print('RefreshContainerState--initState():result=$result');
        _scrollController.animateTo(HEAD_HEIGHT,
            duration: Duration(milliseconds: 200), curve: Curves.linear);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: NotificationListener(
        onNotification: onNotification,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            CustomRefreshWidget(
              scrollController: _scrollController,
              refreshStateNotifier: _refreshStateNotifier,
              onRefresh: widget.onRefresh,
              child: Container(
                color: Colors.red,
                height: HEAD_HEIGHT,
                child: Center(
                  child: Text("CustomSliver"),
                ),
              ),
            ),
            _buildListView(),
          ],
        ),
      ),
    );
  }

  bool onNotification(ScrollNotification scrollNotification) {
    print(
      'RefreshContainerState--onNotification():pixels=${scrollNotification.metrics.pixels}',
    );
    double overOffset = scrollNotification.metrics.pixels.abs();
    if (scrollNotification is ScrollUpdateNotification) {
      /*print(
        'RefreshContainerState--onNotification():dragDetails=${scrollNotification.dragDetails}',
      );*/

      /// 手抬起
      if (scrollNotification.dragDetails == null) {
        if (_refreshStateNotifier.value == RefreshState.IDLE) {
          if (overOffset * 2 > HEAD_HEIGHT) {
            _refreshStateNotifier.value = RefreshState.PREPARING_REFRESH_PRE;
          } else if (_refreshStateNotifier.value ==
              RefreshState.PREPARING_REFRESH_PRE) {
            _refreshStateNotifier.value = RefreshState.PREPARING_REFRESH;
          }
        }
      }
    }
    return true;
  }

  Widget _buildListView() {
    return SliverFixedExtentList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int position) {
          return Container(
            color: Color.fromRGBO(
              (255 * Random().nextDouble()).toInt(),
              (255 * Random().nextDouble()).toInt(),
              (255 * Random().nextDouble()).toInt(),
              1,
            ),
          );
        },
        childCount: 20,
      ),
      itemExtent: 80,
    );
  }
}

enum RefreshState {
  /// 达到 [headerTrigger]，准备进入刷新状态
  ///
  /// Reach [headerTrigger], ready to enter refresh state
  PREPARING_REFRESH,
  PREPARING_REFRESH_PRE,

  /// 刷新中
  ///
  /// Refreshing
  REFRESHING,

  /// 刷新结束中
  ///
  /// End of refresh
  FINISHING,

  /// 空闲状态
  ///
  /// Idle state
  IDLE,
}

class CustomRefreshWidget extends SingleChildRenderObjectWidget {
  final ScrollController scrollController;
  final ValueNotifier<RefreshState> refreshStateNotifier;
  final OnRefresh onRefresh;

  const CustomRefreshWidget({
    Key key,
    Widget child,
    this.onRefresh,
    this.scrollController,
    this.refreshStateNotifier,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return SimpleRefreshSliver(
        scrollController: scrollController,
        refreshStateNotifier: refreshStateNotifier,
        onRefresh: onRefresh);
  }
}

/// 一个简单的下拉刷新 Widget link[SliverToBoxAdapter]
class SimpleRefreshSliver extends RenderSliverSingleBoxAdapter {
  final ScrollController scrollController;
  final ValueNotifier<RefreshState> refreshStateNotifier;
  final OnRefresh onRefresh;

  SimpleRefreshSliver(
      {this.scrollController, this.refreshStateNotifier, this.onRefresh});

  @override
  void performLayout() {
    child.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child.size.width;
        break;
      case Axis.vertical:
        childExtent = child.size.height;
        break;
    }

    assert(childExtent != null);
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    final bool active = constraints.overlap < 0.0;
    final double overscrolledExtent =
        constraints.overlap < 0.0 ? constraints.overlap.abs() : 0.0;
    double childHeight = child.size.height;
    /*print(
      "SimpleRefreshSliver--performLayout():"
      "overscrolledExtent:$overscrolledExtent,"
      "childHeight=$childHeight,"
      "scrollOffset=${constraints.scrollOffset}",
    );*/

    double paintOrigin = 0;
    double layoutExtent = 0;
    if (refreshStateNotifier.value == RefreshState.PREPARING_REFRESH_PRE) {
      geometry = SliverGeometry(
        scrollExtent: childHeight,
        paintOrigin: 0,
        paintExtent:
            calculatePaintOffset(constraints, from: 0.0, to: childExtent),
        cacheExtent:
            calculateCacheOffset(constraints, from: 0.0, to: childExtent),
        maxPaintExtent: childHeight,
      );
      refreshStateNotifier.value = RefreshState.PREPARING_REFRESH;
    } else if (refreshStateNotifier.value == RefreshState.PREPARING_REFRESH) {
      paintOrigin = 0;
      layoutExtent = childHeight - constraints.scrollOffset;
      geometry = SliverGeometry(
        ///
        scrollExtent: childHeight,
        paintOrigin: paintOrigin,
        paintExtent:
            calculatePaintOffset(constraints, from: 0.0, to: childExtent),
        cacheExtent:
            calculateCacheOffset(constraints, from: 0.0, to: childExtent),
        maxPaintExtent: childHeight,
      );
    } else {
      paintOrigin = min(overscrolledExtent - childHeight, 0);
      layoutExtent = max(min(overscrolledExtent, childHeight), 0.0);
      geometry = SliverGeometry(
        ///
        scrollExtent: childHeight,

        /// 绘制起始位置
        paintOrigin: paintOrigin,

        ///
        paintExtent: layoutExtent,

        ///
        maxPaintExtent: childHeight,

        /// 布局占位  SliverGeometry 的 layoutExtent 会影响下一个 Sliver 的布局位置，所以 layoutExtent 也需要随着滑动而逐渐变大
        // layoutExtent: layoutExtent,
        cacheExtent: calculateCacheOffset(
          constraints,
          from: 0.0,
          to: childExtent,
        ),
      );
    }

    setChildParentData(child, constraints, geometry);
  }
}

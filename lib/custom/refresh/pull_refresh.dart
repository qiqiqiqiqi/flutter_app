import 'package:flutter/material.dart';
import 'PullController.dart';
import 'pullHeadContainer.dart';
import 'dart:math' as math;

typedef HeadBuilder = Widget Function(PullController pullController);

class PullRefresh extends StatefulWidget {
  HeadBuilder headBuilder;
  ScrollView child;
  PullController pullController;

  PullRefresh({this.pullController, this.headBuilder, this.child});

  @override
  State<StatefulWidget> createState() {
    return PullRefreshState();
  }
}

class PullRefreshState extends State<PullRefresh> {
  double offsetY = 0;
  GlobalKey headGlobalKey = GlobalKey();
  double headHeight = 0;
  double scrollY = 0;
  double marginTop = 0;

  @override
  void initState() {
    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((Duration duration) {
      setState(() {
        headHeight = headGlobalKey.currentContext.size.height;
        offsetY = -headHeight;
        print("initState():headHeight=$headHeight");
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget headWidget = widget.headBuilder(widget.pullController);
    List<Widget> widgets =
        List.from(widget.child.buildSlivers(context), growable: true);
    widgets.insert(
        0,
        SliverToBoxAdapter(
          child: Container(
            color: Colors.redAccent,
            margin: EdgeInsets.only(top: marginTop),
            key: headGlobalKey,
            child: headWidget,
          ),
        ));
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
                  physics: BouncingScrollPhysics(),
                  slivers: widgets,
                ),
                onNotification: (ScrollNotification scrollNotification) {
                  handleScrollNotification(scrollNotification);
                },
              ))
        ],
      );
    });
  }

  handleScrollNotification(ScrollNotification scrollNotification) {
    if (scrollNotification is ScrollStartNotification) {
      print("handleScrollNotification():ScrollStartNotification");
    } else if (scrollNotification is ScrollUpdateNotification) {
      print("handleScrollNotification():ScrollUpdateNotification");
      double dy = scrollNotification.dragDetails.delta.dy;
      scrollY += dy;
      setState(() {
        if (scrollY > headHeight) {
         // marginTop=headHeight;
        }

      });
      print(
          "handleScrollNotification():ScrollUpdateNotification--offsetY=$offsetY");
    } else if (scrollNotification is ScrollEndNotification) {
      setState(() {
        if (scrollY > headHeight) {
          offsetY = 0;
        }
      });
      print("handleScrollNotification():ScrollEndNotification");
    } else if (scrollNotification is OverscrollNotification) {
      //CustomScrollView设置BouncingScrollPhysics后无OverscrollNotification
      print("handleScrollNotification():OverscrollNotification");
      double dy = scrollNotification.dragDetails.delta.dy;
      double distance = scrollNotification.dragDetails.delta.distance;
      print(
          "handleScrollNotification():OverscrollNotification--dy=$dy,distance=$distance");
    }
  }
}

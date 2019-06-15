import 'package:flutter/material.dart';
import 'dart:ui';

main() {
  runApp(MaterialApp(
    title: "CustomScrollView demo",
    home: CustomScrollViewDemo(),
  ));
}

class CustomScrollViewDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CustomScrollViewState();
  }
}

class CustomScrollViewState extends State<CustomScrollViewDemo> {
  GlobalKey bigCircleAvatarGlobalKey = GlobalKey();
  GlobalKey smallCircleAvatarGlobalKey = GlobalKey();
  double barHeight = MediaQueryData.fromWindow(window).padding.top;
  double titleHeight = kToolbarHeight;
  double scale = 1.0;
  double translationX = 0, translationY = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return NotificationListener(
        onNotification: (ScrollNotification scrollNotification) {
          setState(() {
            double pixels = scrollNotification.metrics.pixels;

            RenderBox bigRenderBox =
                bigCircleAvatarGlobalKey.currentContext.findRenderObject();
            Offset bigLocalToGlobal = bigRenderBox.localToGlobal(Offset.zero);

            RenderBox smallRenderBox =
                smallCircleAvatarGlobalKey.currentContext.findRenderObject();
            Offset smalllocalToGlobal =
                smallRenderBox.localToGlobal(Offset.zero);
            double minScale =
                smallRenderBox.size.width / bigRenderBox.size.width;
            scale = 1 -
                (pixels > (240 - barHeight - titleHeight)
                        ? (240 - barHeight - titleHeight)
                        : pixels) /
                    (240 - barHeight - titleHeight);
            scale = scale > minScale ? scale : minScale;
            translationX = ((bigLocalToGlobal.dx +
                        bigRenderBox.size.width / 2) -
                    (smalllocalToGlobal.dx + smallRenderBox.size.width / 2)) *
                (pixels > (240 - barHeight - titleHeight)
                    ? (240 - barHeight - titleHeight)
                    : pixels) /
                (240 - barHeight - titleHeight);
            translationY = ((bigLocalToGlobal.dy +
                        bigRenderBox.size.height / 2) -
                    (smalllocalToGlobal.dy + smallRenderBox.size.height / 2)) *
                (pixels > (240 - barHeight - titleHeight)
                    ? (240 - barHeight - titleHeight)
                    : pixels) /
                (240 - barHeight - titleHeight);
            print(
                "${(pixels > (240 - barHeight - titleHeight) ? (240 - barHeight - titleHeight) : pixels) / (240 - barHeight - titleHeight)},${MediaQuery.of(context).size.width}");
            print(
                "CustomScrollViewDemo:pixels=$pixels,bigLocalToGlobal=${bigLocalToGlobal.toString()},bigRenderBox=${bigRenderBox.size.width},smalllocalToGlobal=${smalllocalToGlobal.toString()},"
                "smallRenderBox=${smallRenderBox.size.width},scale=$scale,translationX=$translationX,translationY=$translationY");
          });
        },
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  /* title: Text("SliverAppBarTitle"),*/
                  centerTitle: true,
                  leading: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child:
                        Icon(null, key: smallCircleAvatarGlobalKey, size: 36),
                  ),
                  expandedHeight: 240.0,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text("FlexibleSpaceBarTitle"),
                    centerTitle: true,
                    collapseMode: CollapseMode.pin,

                    background: Center(
                      child: Stack(
                        alignment: AlignmentDirectional(0, 0),
                        children: <Widget>[
                          Image.asset(
                            "images/ic_img_default.jpg",
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverFixedExtentList(
                    delegate: SliverChildBuilderDelegate((context, position) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: <Widget>[
                            Positioned(
                                left: 5,
                                child: Image.asset(
                                  "images/ic_img_default.jpg",
                                  fit: BoxFit.cover,
                                )),
                            Positioned(
                              right: 40,
                              child: Text("item$position"),
                            )
                          ],
                        ),
                        color: Colors.blueAccent,
                      );
                    }, childCount: 12),
                    itemExtent: 120)
              ],
            ),
            Positioned(
              top: 70,
              child: SizedBox(
                key: bigCircleAvatarGlobalKey,
                width: 100,
                height: 80,
                child: Transform(
                    transform: Matrix4.translationValues(
                        -translationX, -translationY, 0),
                    child: Transform.scale(
                      scale: scale,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blueGrey,
                        child: Image.asset(
                          "images/ic_img_default.jpg",
                          fit: BoxFit.fill,
                        ),
                      ),
                    )),
              ),
            )
          ],
        ));
    ;
  }
}

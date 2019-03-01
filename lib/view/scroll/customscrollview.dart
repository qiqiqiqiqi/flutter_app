import 'package:flutter/material.dart';
import 'dart:ui';
main() {
  runApp(MaterialApp(
    title: "CustomScrollView demo",
    home: CustomScrollViewDemo(),
  ));
}

class CustomScrollViewDemo extends StatelessWidget {
  GlobalKey bigCircleAvatarGlobalKey = GlobalKey();
  GlobalKey smallCircleAvatarGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    MediaQueryData.fromWindow(window).padding.top;
    return NotificationListener(
        onNotification: (ScrollNotification scrollNotification) {
          double pixels = scrollNotification.metrics.pixels;

          RenderBox bigRenderBox =
              bigCircleAvatarGlobalKey.currentContext.findRenderObject();
          Offset bigLocalToGlobal = bigRenderBox.localToGlobal(Offset.zero);

          RenderBox smallRenderBox =
              smallCircleAvatarGlobalKey.currentContext.findRenderObject();
          Offset smalllocalToGlobal = smallRenderBox.localToGlobal(Offset.zero);
          print(
              "CustomScrollViewDemo:pixels=$pixels,bigLocalToGlobal=${bigLocalToGlobal.toString()},bigRenderBox=${bigRenderBox.size.width},smalllocalToGlobal=${smalllocalToGlobal.toString()},smallRenderBox=${smallRenderBox.size.width}");
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
            SizedBox(
              key: bigCircleAvatarGlobalKey,
              width: 100,
              height: 100,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueGrey,
                child: Image.asset(
                  "images/ic_img_default.jpg",
                  fit: BoxFit.fill,
                ),
              ),
            )
          ],
        ));
  }
}

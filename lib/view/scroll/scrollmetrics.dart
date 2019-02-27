import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(
    title: "scrollbar demo",
    home: ScrollBarDemo(),
  ));
}

class ScrollBarDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScrollBarState();
  }
}

class ScrollBarState extends State<ScrollBarDemo> {
  String _progressText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("scrollbar demo"),
      ),
      body: Scrollbar(
          child: NotificationListener(
              onNotification: (ScrollNotification scrollNotification) {
                int ds = scrollNotification.metrics.pixels
                    .toInt(); //当前滚动位置（与extentBefore相等）
                int maxScrollExtent = scrollNotification.metrics.maxScrollExtent
                    .toInt(); //最大可滚动长度，（不是固定值（maxScrollExtent=extentBefore+extentAfter））
                int extentBefore = scrollNotification.metrics.extentBefore
                    .toInt(); //滚出viewport顶部的长度
                int extentAfter = scrollNotification.metrics.extentAfter
                    .toInt(); //未滑入viewport部分的长度
                int extentInside = scrollNotification.metrics.extentInside
                    .toInt(); //viewport内部的长度
                int minScrollExtent =
                    scrollNotification.metrics.minScrollExtent.toInt(); //
                bool atEdge = scrollNotification.metrics.atEdge; //是否滑动到边界
                bool outOfRange = scrollNotification.metrics.outOfRange; //
                print("build():ds=$ds,maxScrollExtent=$maxScrollExtent,"
                    "extentBefore=$extentBefore,extentAfter=${extentAfter},extentInside=${extentInside},"
                    "minScrollExtent=$minScrollExtent,atEdge=$atEdge,outOfRange=$outOfRange");
                setState(() {
                  _progressText = "${(ds * 100 / maxScrollExtent).toInt()}%";
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: Text(
                        "text$index",
                      ));
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 1.0,
                        color: Colors.blueAccent,
                      );
                    },
                    itemCount: 100,
                  ),
                  CircleAvatar(
                    child: Text(
                      "${_progressText}",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    backgroundColor: Colors.black12,
                  )
                ],
              ))),
    );
  }
}

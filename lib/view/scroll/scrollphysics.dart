import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(
    title: "scrollphysics demo",
    home: ScrollPhysiceDemo(),
  ));
}

class ScrollPhysiceDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScrollPhysicsState();
  }
}

class ScrollPhysicsState extends State<ScrollPhysiceDemo> {
  PageController _pageController = PageController();
  double currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("scrollphysics demo"),
        ),
        body: NotificationListener(
            onNotification: (ScrollNotification scrollNotification) {
          setState(() {
            currentPage = _pageController.page;
          });
        }, child: LayoutBuilder(builder: (context, constrains) {
          return Container(
              color: Colors.redAccent,
              width: MediaQuery.of(context).size.width,
              height: 300.0,
              child: PageView.custom(
                physics: BouncingScrollPhysics(),
                  controller: _pageController,
                  childrenDelegate:
                      SliverChildBuilderDelegate((context, position) {
                    return Container(
                      color: Colors.blueAccent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("$position"),
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                              child: Transform(
                                transform: Matrix4.translationValues(
                                    constrains.maxWidth /
                                        2 *
                                        (position - currentPage),
                                    0,
                                    0),
                                child: Text("左右移动,第二行的文字移动的速度会快一点"),
                              ))
                        ],
                      ),
                    );
                  }, childCount: 10)));
        })));
  }
}

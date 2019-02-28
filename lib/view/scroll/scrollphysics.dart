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
  List datas = List(10);

  List<Widget> getPoint(List datas) {
    return datas.map((position) {
      return Padding(
          padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
          child: SizedBox(
            width: 8,
            height: 8,
            child: CircleAvatar(backgroundColor: Colors.blueGrey),
          ));
    }).toList();
  }

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
              child: Stack(
                alignment: Alignment(0, 0.9),
                children: <Widget>[
                  PageView.custom(
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
                      }, childCount: 10)),
                  Stack(
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: getPoint(datas),
                      ),
                      Transform(
                          transform:
                              Matrix4.translationValues(12 * currentPage, 0, 0),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                            child: SizedBox(
                              width: 8,
                              height: 8,
                              child: CircleAvatar(
                                  backgroundColor: Colors.redAccent),
                            ),
                          ))
                    ],
                  )
                ],
              ));
        })));
  }
}

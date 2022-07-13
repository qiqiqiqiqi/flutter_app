import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(
    home: ClipPathDemo(),
  ));
}

class ClipPathDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ClipPathState();
  }
}

class ClipPathState extends State<ClipPathDemo> {
  int offsetY = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: 240,
                child: ClipPath(
                  clipper: BottomCustomClipper(offsetY: offsetY),
                  child: Container(
                    color: Colors.redAccent,
                    child: Image.asset(
                      "images/bg_rank.png",
                      height: 240,
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
            Positioned(
                left: 0,
                right: 0,
                top: 240,
                bottom: 0,
                child: NotificationListener(
                    onNotification: (ScrollNotification scrollNotification) {
                      if (scrollNotification is ScrollUpdateNotification) {
                        int scrollDistance =
                            scrollNotification.metrics.pixels.toInt();
                        print(
                            "NotificationListener:scrollDistance=$scrollDistance");
                        setState(() {
                          offsetY = scrollDistance;
                        });
                      }
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.all(0),
                      primary: true,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              child: Row(
                                children: <Widget>[
                                  Image.asset(
                                    "images/no1.png",
                                    width: 26,
                                    height: 31,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: ClipOval(
                                      child: Image.network(
                                        "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1553076814485&di=ac8f2b476f79f75bd43f5ad26234af5b&imgtype=0&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201410%2F30%2F20141030134409_2uB8m.thumb.700_0.jpeg",
                                        width: 33,
                                        height: 33,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "处女座的设计师",
                                    style: TextStyle(
                                        color: Color(0XFF303133),
                                        fontSize: 14,
                                        decoration: null),
                                  ),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        "10节",
                                        style: TextStyle(
                                            color: Color(0XFF406266),
                                            fontSize: 12,
                                            decoration: null),
                                      ),
                                      Text(
                                        "300分钟",
                                        style: TextStyle(
                                            color: Color(0XFF406266),
                                            fontSize: 10,
                                            decoration: null),
                                      )
                                    ],
                                  ))
                                ],
                                crossAxisAlignment: CrossAxisAlignment.center,
                              ),
                            ),
                            Padding(
                              child: new Divider(
                                height: 1,
                                color: Color(0XFFD8D8D8),
                              ),
                              padding: EdgeInsets.only(left: 16),
                            )
                          ],
                        );
                      },
                      itemCount: 100,
                      // physics: BouncingScrollPhysics(),
                    )))
          ],
        ),
      ),
    );
  }
}

class BottomCustomClipper extends CustomClipper<Path> {
  int offsetY;

  @override
  getClip(Size size) {
    if (offsetY <= 0) {
      offsetY = 0;
    } else if (offsetY >= 40) {
      offsetY = 40;
    }

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }

  BottomCustomClipper({this.offsetY});
}

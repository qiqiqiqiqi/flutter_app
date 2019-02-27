import 'package:flutter/material.dart';

main() {
  runApp(new MaterialApp(
    title: "pageview demo",
    home: PageViewDemo(),
  ));
}

class PageViewDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PageViewState();
  }
}

class PageViewState extends State<PageViewDemo> {
  int currentPosition = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("pageview  demo"),
      ),
      body: PageView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        controller: _pageController,
        children: <Widget>[
          Container(
              color: Colors.redAccent,
              child: Center(
                child: Text("one"),
              )),
          Container(
              color: Colors.greenAccent,
              child: Center(
                child: Text("two"),
              )),
          Container(
              color: Colors.blueAccent,
              child: Center(
                child: Text("three"),
              ))
        ],
        onPageChanged: (int position) {
          setState(() {
            currentPosition = position;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.android), title: Text("one")),
          BottomNavigationBarItem(
              icon: Icon(Icons.android), title: Text("two")),
          BottomNavigationBarItem(
              icon: Icon(Icons.android), title: Text("tree")),
        ],
        onTap: (int position) {
          setState(() {
            currentPosition = position;
            //  _pageController.jumpToPage(currentPosition);直接切换，无动画过渡
            _pageController.animateToPage(currentPosition,
                duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
          });
        },
        currentIndex: currentPosition,
      ),
    );
  }
}

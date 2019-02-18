import 'package:flutter/material.dart';

main() {
  runApp(new MaterialApp(
    title: "bottom navigation bar demo",
    home: MainPager(),
  ));
}

class MainPager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainState();
  }
}
//https://www.jianshu.com/p/c3c9beacbb94
//Widget 是临时对象，用于构建当前状态下的应用程序，而 State 对象在多次调用build()之间保持不变，允许它们记住信息(状态)。
class MainState extends State<MainPager> {
  List<PagerBody> pagerBodys;
  int index = 0;
  PagerBody currentPagerBody;

  @override
  void initState() {
    super.initState();
    pagerBodys = List();
    pagerBodys
      ..add(PagerBody("main1"))
      ..add(PagerBody('main2'))
      ..add(PagerBody('main3'));
    currentPagerBody = pagerBodys[0];
  }

  @override
  Widget build(BuildContext context) {
    print("MainState:build()");
    return new Scaffold(
      appBar: AppBar(title: new Text("${pagerBodys[index].title}")),
      body: currentPagerBody,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.redAccent,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            title: new Text("main1"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            title: new Text("main2"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            title: new Text("main3"),
          )
        ],
        currentIndex: index,
        onTap: (int i) {
          setState(() {//每当调用 States.setState() 时，都会重新build一次 ，然后将新的 Views代替原先的，并显示给用户
            print("${pagerBodys[index].state}");
            index = i;
            currentPagerBody = pagerBodys[index];
          });
        },
        iconSize: 20,
      ),
    );
  }
}

class PagerBody extends StatefulWidget {
  String title;
  State state;

  PagerBody(this.title);

  @override
  State<StatefulWidget> createState() {
    print("PagerBody:createState()");
    state = PagerBodyState();
    return state;
  }
}

class PagerBodyState
    extends State<PagerBody> /*with AutomaticKeepAliveClientMixin*/ {
  int _count = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("PagerBodyState:build():this=$this");
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("$_count");
          setState(() {
            _count++;
          });
        },
        child: new Icon(Icons.add),
      ),
      body: Center(
        child: Text("${widget.title}:count=$_count"),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
/* @override
  bool get wantKeepAlive => false;*/
}

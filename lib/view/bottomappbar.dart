import 'package:flutter/material.dart';

main() {
  runApp(MaterialApp(
    title: "bottom navigator demo",
    home: MainPager(),
  ));
}

class MainPager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainState();
  }
}

class MainState extends State<MainPager> with SingleTickerProviderStateMixin {
  List<PagerBody> _pagerBodys;
  int _index = 0;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _pagerBodys = List<PagerBody>();
    _pagerBodys
      ..add(PagerBody("main1"))
      ..add(PagerBody("main2"))
      ..add(PagerBody("main3"))
      ..add(PagerBody("main4"));
    _tabController = buildTabController();
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _index = _tabController.index;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("${_pagerBodys[_index].title}"),
      ),
      body: _pagerBodys[_index],
      bottomNavigationBar: BottomAppBar(
          //BottomAppBar无法与Tabbar共同使用
          color: Colors.lightBlue,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  changeTab(0);
                },
                icon: Icon(Icons.android),
              ),
              IconButton(
                onPressed: () {
                  changeTab(1);
                },
                icon: Icon(Icons.android),
              ),
              IconButton(
                onPressed: () {
                  changeTab(2);
                },
                icon: Icon(Icons.android),
              ),
              IconButton(
                onPressed: () {
                  changeTab(3);
                },
                icon: Icon(Icons.android),
              )
            ],
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: new FloatingActionButton(
          onPressed: () {},
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }

  changeTab(int index) {
    _index = index;
    setState(() {});
  }

  TabController buildTabController() {
    return TabController(
        length: _pagerBodys.length, vsync: this, initialIndex: 0);
  }
}

class PagerBody extends StatelessWidget {
  String title;

  PagerBody(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: new Text('$title'),
      ),
    );
  }
}

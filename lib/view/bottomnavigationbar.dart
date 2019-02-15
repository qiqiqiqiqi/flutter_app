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

class MainState extends State<MainPager> {
  List<PagerBody> pagerBodys;
  int index = 0;

  @override
  void initState() {
    super.initState();
    pagerBodys = List();
    pagerBodys
      ..add(PagerBody("main1"))
      ..add(PagerBody('main2'))
      ..add(PagerBody('main3'));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: new Icon(Icons.add),
      ),
      appBar: AppBar(title: new Text("${pagerBodys[index].title}")),
      body: pagerBodys[index],
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
          index = i;
          setState(() {});
        },
        iconSize: 20,
      ),
    );
  }
}

class PagerBody extends StatelessWidget {
  String title;

  PagerBody(this.title);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Text('$title'),
    );
  }
}
